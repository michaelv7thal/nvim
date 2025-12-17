# Neovim DevContainer Setup Guide

## 🐳 What was installed

- **nvim-dev-container**: Full devcontainer support in Neovim
- **JSONC Treesitter parser**: For syntax highlighting in devcontainer.json files
- **Dockerfile parser**: For Dockerfile syntax highlighting

## 📋 Prerequisites

You need to install the DevContainer CLI:

```bash
npm install -g @devcontainers/cli
```

Or use Docker/Podman directly (auto-detected).

## ⌨️ Keybindings

| Keymap | Command | Description |
|--------|---------|-------------|
| `<leader>dc` | `:DevcontainerStart` | Start and attach to devcontainer |
| `<leader>ds` | `:DevcontainerStop` | Stop running devcontainer |
| `<leader>da` | `:DevcontainerAttach` | Attach to existing container |
| `<leader>dr` | `:DevcontainerRemove` | Remove devcontainer |
| `<leader>di` | `:DevcontainerInfo` | Show devcontainer information |
| `<leader>dl` | `:DevcontainerLogs` | View devcontainer logs |
| `<leader>de` | `:DevcontainerExec` | Execute command in container |
| `<leader>db` | `:DevcontainerBuild` | Build devcontainer image |

## 🚀 Basic Workflow

1. **Create a devcontainer.json** in your project:
   ```bash
   mkdir -p .devcontainer
   nvim .devcontainer/devcontainer.json
   ```

2. **Example devcontainer.json** (Python):
   ```json
   {
     "name": "Python Dev",
     "image": "mcr.microsoft.com/devcontainers/python:3.11",
     "customizations": {
       "vscode": {
         "settings": {},
         "extensions": []
       }
     },
     "postCreateCommand": "pip install -r requirements.txt",
     "remoteUser": "vscode"
   }
   ```

3. **Start the container**:
   - Press `<leader>dc` (or `:DevcontainerStart`)
   - Neovim will restart inside the container automatically

4. **Your Neovim config is mounted read-only** into the container, so all your plugins and settings work!

## 📦 Sample devcontainer.json Files

### Python Project
```json
{
  "name": "Python Development",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {}
  },
  "postCreateCommand": "pip install -r requirements.txt",
  "customizations": {
    "vscode": {
      "extensions": ["ms-python.python"]
    }
  }
}
```

### Node.js Project
```json
{
  "name": "Node.js Development",
  "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {}
  },
  "postCreateCommand": "npm install",
  "remoteUser": "node"
}
```

### Rust Project
```json
{
  "name": "Rust Development",
  "image": "mcr.microsoft.com/devcontainers/rust:latest",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {}
  },
  "postCreateCommand": "cargo build"
}
```

### Custom Dockerfile
```json
{
  "name": "Custom Dev Environment",
  "build": {
    "dockerfile": "Dockerfile",
    "context": ".."
  },
  "customizations": {
    "vscode": {
      "settings": {},
      "extensions": []
    }
  }
}
```

## 🔧 Configuration Options

The plugin is configured in `lua/plugins/devcontainer.lua`:

- **attach_mounts**: Automatically mounts your Neovim config (read-only)
- **autocommands**: Auto-start containers when opening projects
- **container_runtime**: Supports docker, podman, or devcontainer CLI
- **compose_command**: For docker-compose or podman-compose projects

## 💡 How It Works

Unlike VS Code which runs a server in the container:
1. Neovim runs **entirely inside the container**
2. Your config is mounted from the host (read-only)
3. All LSPs, formatters, and tools use the container's environment
4. Changes to files are reflected on both host and container

## 🎯 Best Practices

1. **Mount your config as read-only** (default) to prevent accidental changes
2. **Install language tools in the container**, not on your host
3. **Use `postCreateCommand`** to set up dependencies automatically
4. **Test your devcontainer** before committing: `<leader>db` to build

## 🐛 Troubleshooting

**Container won't start:**
- Check Docker/Podman is running: `docker ps`
- View logs: `<leader>dl`
- Check devcontainer.json syntax

**LSP not working:**
- Ensure LSP servers are installed **in the container**
- Add installation to `postCreateCommand`
- Example: `"postCreateCommand": "pip install black pylint"`

**Config not loading:**
- Config is mounted automatically
- Check `:DevcontainerInfo` for mount paths
- Ensure Neovim is installed in the container

**Command not found:**
- Install devcontainer CLI: `npm install -g @devcontainers/cli`
- Or ensure Docker/Podman is available

## 📚 Additional Resources

- [Dev Containers Spec](https://containers.dev/)
- [nvim-dev-container Docs](https://codeberg.org/esensar/nvim-dev-container)
- [Dev Container Images](https://github.com/devcontainers/images)

## ⚡ Quick Start Example

Try it now:

1. Create a test project:
   ```bash
   mkdir ~/test-devcontainer && cd ~/test-devcontainer
   mkdir .devcontainer
   ```

2. Create `.devcontainer/devcontainer.json`:
   ```json
   {
     "name": "Test Python",
     "image": "python:3.11-slim",
     "postCreateCommand": "apt-get update && apt-get install -y git ripgrep fd-find"
   }
   ```

3. Open in Neovim:
   ```bash
   nvim .
   ```

4. Start container: `<leader>dc`

5. Neovim will restart inside the container - try `:! python --version`!
