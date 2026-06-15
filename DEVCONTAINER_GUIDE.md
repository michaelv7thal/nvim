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
> diagnostics that match the container exactly, you'd run Neovim *inside* the
> container instead (a different setup — ask and I'll scaffold it).

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

## Reference

- Reference template: `~/.config/nvim/templates/devcontainer/devcontainer.json`
- Spec & variables: https://containers.dev/
- Prebuilt features: https://containers.dev/features
- CLI: https://github.com/devcontainers/cli
