# DevContainers with Neovim

How I use devcontainers: **Neovim edits on the host; the container provides the
toolchain.** There is no Neovim plugin involved — everything goes through the
official [`devcontainer` CLI](https://github.com/devcontainers/cli) and Docker,
which are spec-compliant, editor-agnostic, and identical to what CI and VS Code
use.

## The model

- **Edit** with your normal host `nvim` (full config, host-side LSP/format).
- **Run** the project's runtime, deps, tests, and builds *inside* the container
  via `devcontainer exec`.
- The container bind-mounts your project, so edits on the host are instantly
  visible inside the container and vice-versa.

> **LSP caveat (the trade-off of this model):** your LSP runs on the host, so it
> can't see container-only dependencies (`node_modules`, a venv, `mix` deps,
> etc.). In-editor diagnostics reflect the *host* environment. If you need
> diagnostics that match the container exactly, run Neovim *inside* the
> container instead — see [Neovim inside the container](#neovim-inside-the-container).

## Prerequisites

Already installed on this machine: Docker, `docker compose`, and the
`devcontainer` CLI (`devcontainer --version`). A project needs a
`.devcontainer/devcontainer.json`.

## One-time per project

Copy the reference template and adapt it (base image, language `features`,
`postCreateCommand`):

```bash
mkdir -p myproject/.devcontainer
cp ~/.config/nvim/templates/devcontainer/devcontainer.json \
   myproject/.devcontainer/devcontainer.json
```

## Daily flow (from the terminal)

```bash
cd ~/projects/myproject

# Build + start (first run builds the image; re-run is fast)
devcontainer up --workspace-folder .

# Run things INSIDE the container
devcontainer exec --workspace-folder . bash        # interactive shell
devcontainer exec --workspace-folder . npm test    # tests
devcontainer exec --workspace-folder . mix deps.get

# Edit on the host as usual
nvim .
```

Rebuild after changing `devcontainer.json`/`Dockerfile`:

```bash
devcontainer up --workspace-folder . --remove-existing-container
# add --build-no-cache to rebuild the image from scratch
```

(If you want one-keystroke `dcup`/`dcx` aliases in `~/.bashrc`, ask and I'll add
them.)

## Neovim inside the container

The opposite model: **Neovim runs in the container**, so its LSP/format/test
tooling sees the container's exact dependencies — no host-vs-container
diagnostic skew. Use this when the toolchain is the point (container-only deps,
matching CI exactly, a runtime you don't have on the host).

The trick is to share the *config* but not the *data*:

- **Bind-mount** the central `~/.config/nvim` (read-write) so it's the same
  files inside and out — one source of truth, edits sync both ways.
- Keep `~/.local/share/nvim` (lazy plugins, **Mason** LSP servers, compiled
  **Treesitter** parsers) in a **container-local named volume**. These are
  arch/libc-specific native artifacts that must never be shared with the host;
  the volume also makes rebuilds fast (no re-download/recompile each time).

Scaffolded reference: `~/.config/nvim/templates/devcontainer-nvim-inside/devcontainer.json`.

```bash
mkdir -p myproject/.devcontainer
cp ~/.config/nvim/templates/devcontainer-nvim-inside/devcontainer.json \
   myproject/.devcontainer/devcontainer.json
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . nvim .   # full config, container-side LSP
```

Four things that bite if you skip them (the template handles all four):

- **Neovim version.** This config needs **≥ 0.11** (native `vim.lsp.config`,
  mason-lspconfig v2, `vim.diagnostic.jump`, `vim.o.winborder`). `apt-get
  install neovim` ships something far older — use the Neovim devcontainer
  feature or a tarball/appimage. *(A too-old nvim is the usual reason a config
  "installs but does nothing.")*
- **Build deps for Mason/Treesitter.** A C compiler + `git`/`curl`/`unzip`, plus
  **Node** for the npm-based servers you `ensure_installed` (vtsls, eslint,
  pyright, angularls, html, cssls), plus `ripgrep`/`fd` for Telescope — **and the
  `tree-sitter` CLI**: nvim-treesitter's `main` branch compiles parsers by
  invoking it, so a C compiler alone won't build them (`npm i -g tree-sitter-cli`).
- **Volume ownership (chown the *parents*, and self-heal on every start).** Named
  volumes mount root-owned, **and Docker creates the volume's parent dirs
  (`~/.local`, `~/.local/share`) as root** to host the mount — which also blocks
  `~/.local/state/nvim`, so nvim can't even write its log. `chown` **all of
  `~/.local`** (not just the volume) to the remote user. Do the one-time
  recursive fix in `postCreateCommand` **and** re-assert it (non-recursive) in
  `postStartCommand`: those parent dirs come back root-owned on every container
  *recreate*, and a chown buried in a long `&&` chain is silently skipped the
  moment an earlier step fails. Symptom if you skip it: `Failed to clone
  lazy.nvim: ... could not create leading directories ... Permission denied`.
- **Don't force public clones through SSH.** If the project's setup runs
  `git config --global url."git@github.com:".insteadOf "https://github.com/"`,
  **every** `https://github.com/...` clone (lazy.nvim and all its plugins) is
  rewritten to SSH — and a *headless* `nvim '+Lazy! sync'` then blocks forever on
  an SSH auth prompt when no key is loaded in the container's agent. Use
  **`pushInsteadOf`** instead of `insteadOf` (pushes still go over SSH; fetches
  use anonymous HTTPS), and run the headless sync with
  `GIT_SSH_COMMAND='ssh -o BatchMode=yes'` so it fails fast instead of hanging.

> **Clipboard:** a containerized Neovim has no host clipboard provider. Neovim
> ≥ 0.10 falls back to OSC52 in many terminals; if yank-to-`+` doesn't reach the
> host, set an explicit OSC52 `vim.g.clipboard`.

## Troubleshooting

**`failed to add host <=> sandbox pair interfaces: operation not supported`** —
kernel/module mismatch, common on Arch after a kernel update when the running
kernel no longer matches `/lib/modules/`. Fix by rebooting:

```bash
uname -r; ls /lib/modules/   # mismatched? reboot
sudo reboot
lsmod | grep veth            # after reboot: should list veth
```

**`container name is already in use`** — a stale container from a previous run:

```bash
devcontainer up --workspace-folder . --remove-existing-container
# or, for compose stacks:
docker compose -f .devcontainer/*.yml down
```

**Root-owned files on the host** — set `remoteUser` + `updateRemoteUserUID: true`
in `devcontainer.json` (the template already does).

**Docker daemon not running** — `docker ps` to check.

**`Failed to clone lazy.nvim: ... could not create leading directories ... Permission denied`**
— the nvim data dir or its parents are root-owned (see *Volume ownership* above).
Fix a live container without rebuilding, then re-warm plugins:

```bash
devcontainer exec --workspace-folder . sudo chown -R $(id -u):$(id -g) ~/.local
devcontainer exec --workspace-folder . bash -c "GIT_SSH_COMMAND='ssh -o BatchMode=yes' nvim --headless '+Lazy! sync' +qa"
```

**Headless `Lazy! sync` hangs (empty `~/.local/share/nvim/lazy`)** — a github
HTTPS→SSH `insteadOf` rewrite is sending plugin clones over SSH with no key
loaded, so git is stuck on an auth prompt. Switch the rule to `pushInsteadOf`
and re-run with `GIT_SSH_COMMAND='ssh -o BatchMode=yes'` (see *Don't force public
clones through SSH* above). Verify the rewrite with
`git config --global --get-regexp insteadof`.

## Reference

- Reference template: `~/.config/nvim/templates/devcontainer/devcontainer.json`
- Spec & variables: https://containers.dev/
- Prebuilt features: https://containers.dev/features
- CLI: https://github.com/devcontainers/cli
