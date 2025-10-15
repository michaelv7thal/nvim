# 🚀 Neovim LSP Quick Reference

## Essential LSP Commands (Save This!)

### Navigation (Most Important!)
```
gd         - Go to Definition (THE main one you wanted!)
gr         - Show References
gi         - Go to Implementation
K          - Hover Documentation
```

### Code Editing
```
<leader>ca - Code Actions (fixes, refactorings)
<leader>rn - Rename Symbol
<leader>f  - Format File
```

### Diagnostics (Errors/Warnings)
```
]d         - Next Diagnostic
[d         - Previous Diagnostic
<leader>d  - Show Diagnostic Float
```

### Telescope + LSP
```
<leader>fs - Document Symbols (functions, classes, etc.)
<leader>fw - Workspace Symbols (search all symbols)
<leader>fd - All Diagnostics
```

---

## What I Fixed

**MAIN ISSUE**: Your LSP servers were being installed but never configured!

**The Fix**: Added the missing `setup_handlers()` call in `lspconfig.lua` that actually configures each LSP server.

---

## How to Test It Works

1. Open a Python file: `nvim test.py`
2. Type: `def hello(): pass` and `hello()`
3. Put cursor on the second `hello`
4. Press `gd` - should jump to the function definition
5. Press `K` - should show documentation

---

## Installed LSPs

- Python (pyright)
- C/C++ (clangd)  
- JavaScript/TypeScript (vtsls)
- Rust (rust_analyzer)
- HTML, CSS
- R
- Lua (for editing your Neovim config!)

Add more with: `:Mason` then press `i` on any server

---

## Best Practices Added

✅ Proper LSP capabilities for completion  
✅ Rounded borders on hover windows  
✅ Diagnostic icons and severity sorting  
✅ Auto-highlight symbol under cursor  
✅ Server-specific optimizations  
✅ Persistent undo with dedicated directory  
✅ System clipboard integration  
✅ Faster update time (300ms)  
✅ Better keybinding descriptions  
✅ No conflicting keymaps  

---

## Common Issues & Solutions

**Q: `gd` shows "No definition found"**  
A: Make sure `:LspInfo` shows client is attached. Save the file first.

**Q: No LSP diagnostics showing**  
A: Check `:LspInfo` and make sure file is saved

**Q: How do I add a new LSP?**  
A: `:Mason` → find server → press `i` → it auto-configures!

**Q: Format not working?**  
A: Some languages use conform.nvim instead (already configured)

---

## Pro Tips

💡 Use `gr` to find where a function is used  
💡 Use `<leader>rn` to rename variables safely  
💡 Use `<leader>ca` on errors for quick fixes  
💡 Learn `[d` and `]d` to navigate errors quickly  
💡 Install trouble.nvim for better diagnostic UI  

---

For full documentation: See `LSP_SETUP_GUIDE.md`
