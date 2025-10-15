# Neovim LSP Configuration Guide

## 🔧 What Was Fixed

### Critical Issue
**The LSP servers were not being configured!** The `lspconfig.lua` file was setting up Mason and mason-lspconfig but never actually called `lspconfig[server_name].setup()`. This is why `gd` (go to definition) and other LSP features weren't working.

### Solution Applied
Added `mason_lspconfig.setup_handlers()` which automatically configures all installed LSP servers with proper capabilities, keybindings, and handlers.

---

## 📋 Key LSP Features Now Available

### Navigation Commands (Normal Mode)
| Keymap | Action | Description |
|--------|--------|-------------|
| `gd` | Go to Definition | Jump to where a symbol is defined |
| `gD` | Go to Declaration | Jump to where a symbol is declared |
| `gi` | Go to Implementation | Jump to implementation |
| `gr` | Show References | List all references to symbol |
| `gt` | Go to Type Definition | Jump to type definition |
| `K` | Hover Documentation | Show documentation for symbol under cursor |
| `<C-k>` | Signature Help | Show function signature (Normal & Insert mode) |

### Code Actions & Refactoring
| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>ca` | Code Action | Show available code actions |
| `<leader>rn` | Rename Symbol | Rename symbol across workspace |
| `<leader>f` | Format Buffer | Format current buffer |

### Diagnostics
| Keymap | Action | Description |
|--------|--------|-------------|
| `[d` | Previous Diagnostic | Jump to previous diagnostic |
| `]d` | Next Diagnostic | Jump to next diagnostic |
| `<leader>d` | Show Diagnostic | Show diagnostic in floating window |
| `<leader>q` | Diagnostic List | Open diagnostics in quickfix list |

### Workspace Management
| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>wa` | Add Workspace Folder | Add folder to workspace |
| `<leader>wr` | Remove Workspace Folder | Remove folder from workspace |
| `<leader>wl` | List Workspace Folders | Print workspace folders |

---

## 🎨 LSP Best Practices Implemented

### 1. **Proper Capabilities Configuration**
```lua
capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
```
Ensures LSP servers know Neovim supports snippets and advanced completion features.

### 2. **Enhanced Diagnostic Display**
- Visual text indicators with icons
- Severity sorting (errors shown first)
- Rounded floating windows
- Source attribution for diagnostics

### 3. **Document Highlight**
Automatically highlights all occurrences of the symbol under cursor when you pause (using `CursorHold`).

### 4. **Server-Specific Configurations**
Each LSP has optimized settings:
- **lua_ls**: Recognizes `vim` global, workspace library
- **pyright**: Basic type checking, auto search paths
- **clangd**: Background indexing, clang-tidy, header insertion
- **rust_analyzer**: Clippy on save

### 5. **Custom Handlers**
Rounded borders on hover and signature help windows for better aesthetics.

---

## 🚀 Additional Improvements

### Telescope LSP Integration
New keymaps for LSP navigation using Telescope:
| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>fs` | Document Symbols | Browse symbols in current file |
| `<leader>fw` | Workspace Symbols | Browse symbols in entire workspace |
| `<leader>fd` | Diagnostics | Browse all diagnostics |

### Better Keymaps
- Added descriptive labels to all keymaps (visible with which-key if installed)
- Resolved conflicts (e.g., `<C-k>` for window navigation vs LSP signature)
- Used Alt/Meta keys for window resizing to avoid conflicts

### Buffer & Window Management
| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>sv` | Split Vertical | Split window vertically |
| `<leader>sh` | Split Horizontal | Split window horizontally |
| `<leader>se` | Equal Windows | Make windows equal size |
| `<leader>sx` | Close Window | Close current window |
| `<leader>bd` | Delete Buffer | Delete current buffer |
| `<leader>bn` | Next Buffer | Go to next buffer |
| `<leader>bp` | Previous Buffer | Go to previous buffer |

### Visual Mode Enhancements
- `<` and `>` reselect after indenting (makes repeated indenting easy)
- `<A-j>` and `<A-k>` move selected lines up/down

### Settings Improvements
- Persistent undo with dedicated directory
- Faster update time (300ms) for better LSP responsiveness
- System clipboard integration by default
- Better completion options

---

## 🔍 How to Verify LSP is Working

1. **Open a file with LSP support** (e.g., `.lua`, `.py`, `.rs`, `.c`)
2. **Check LSP is attached**:
   ```vim
   :LspInfo
   ```
   Should show attached LSP client(s)

3. **Test navigation**:
   - Hover over a function call
   - Press `gd` to jump to its definition
   - Press `K` to see documentation
   - Press `gr` to see all references

4. **Check diagnostics**:
   - Errors should appear in the sign column and as virtual text
   - Icons: ` ` for errors, ` ` for warnings, `󰠠 ` for hints, ` ` for info

---

## 📦 LSP Servers Installed

The following LSP servers are configured to auto-install via Mason:

- **pyright** - Python
- **clangd** - C/C++
- **vtsls** - TypeScript/JavaScript (replaces tsserver)
- **eslint** - JavaScript linting
- **rust_analyzer** - Rust
- **html** - HTML
- **cssls** - CSS
- **r_language_server** - R
- **lua_ls** - Lua (newly added for Neovim config editing)

### Installing Additional LSPs
1. Run `:Mason` to open Mason UI
2. Press `i` on a server to install it
3. The server will auto-configure thanks to the setup handler

---

## 🐛 Troubleshooting

### LSP Not Attaching
1. Check Mason installation: `:Mason`
2. Check if server is installed: `:MasonLog`
3. Check LSP status: `:LspInfo`
4. Restart LSP: `:LspRestart`

### `gd` Not Working
1. Ensure LSP is attached (`:LspInfo`)
2. Make sure you're on a valid symbol (variable, function, etc.)
3. Some languages require the project to be fully indexed first

### Diagnostics Not Showing
1. Check diagnostic config: `:lua vim.print(vim.diagnostic.config())`
2. Make sure file is saved (some LSPs only diagnose saved files)
3. Check if LSP supports diagnostics: `:lua vim.print(vim.lsp.get_active_clients()[1].server_capabilities)`

### Formatting Not Working
1. Check if LSP supports formatting
2. Try conform.nvim (you have it configured): `<leader>f`
3. Some LSPs need explicit formatter installation

---

## 📚 Additional Resources

- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Server Configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)

---

## ⚡ Quick Tips

1. **Use Telescope for multi-result navigation**: `gr`, `gi` work better with Telescope UI
2. **Learn the diagnostic workflow**: `]d` → `<leader>d` → `<leader>ca` (next diagnostic → view it → apply fix)
3. **Rename refactoring**: Place cursor on symbol → `<leader>rn` → type new name → Enter
4. **Code actions are powerful**: Try `<leader>ca` when you see warnings/errors
5. **Signature help while typing**: In insert mode, press `<C-k>` to see function signatures

---

## 🎯 Next Steps

Consider adding these plugins for even better LSP experience:
- **trouble.nvim** - Better diagnostic list
- **fidget.nvim** - LSP progress notifications
- **lspsaga.nvim** - Enhanced LSP UI
- **nvim-navic** - Breadcrumb navigation showing current code context
