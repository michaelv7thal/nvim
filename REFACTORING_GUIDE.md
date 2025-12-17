# Refactoring Plugin Usage Guide

## What Changed

1. **Added Telescope Integration** - You now have a menu to see available refactoring operations
2. **Added Success Messages** - The plugin will now show messages when operations succeed or fail
3. **Added Debug Print Functions** - Quickly add print/console.log statements for debugging

## How to Use

### Quick Start: Use the Refactoring Menu

**Best approach:** Use `<leader>rr` in normal or visual mode to see a Telescope menu of all available refactoring operations for your current context.

### Manual Refactoring Operations

#### Visual Mode (Select code first with `v` or `V`)

1. **Extract Function** - `<leader>re`
   - Select lines of code you want to extract into a function
   - Press `<leader>re`
   - Type the new function name
   - The selected code becomes a new function

2. **Extract Function To File** - `<leader>rf`
   - Same as above but creates the function in a new file
   - You'll be prompted for the file name

3. **Extract Variable** - `<leader>rv`
   - Select an expression/value
   - Press `<leader>rv`
   - Type the new variable name
   - The expression becomes a variable

#### Normal Mode (Cursor on code)

1. **Inline Function** - `<leader>rI`
   - Put cursor on a function call
   - Press `<leader>rI`
   - Replaces the function call with the function's body

2. **Inline Variable** - `<leader>ri`
   - Put cursor on a variable usage
   - Press `<leader>ri`
   - Replaces variable with its value (also works in visual mode)

3. **Extract Block** - `<leader>rb`
   - Put cursor inside a code block
   - Press `<leader>rb`
   - Extracts the block into a new function

4. **Extract Block To File** - `<leader>rbf`
   - Same as above but creates in a new file

### Debug Print Operations

1. **Print Variable** - `<leader>rp`
   - In visual mode: select variable
   - In normal mode: cursor on variable
   - Adds a print/console.log statement for that variable

2. **Cleanup Debug Prints** - `<leader>rc`
   - Removes all print statements added by the plugin

## Supported Languages

The refactoring plugin works with languages that have Treesitter support installed:
- ✓ Lua
- ✓ Python
- ✓ JavaScript
- ✓ TypeScript (requires `typescript` parser)
- ✓ Rust
- ✓ C/C++
- ✓ HTML/CSS
- ✓ Bash

## Example Workflow

### Extract Function Example (Lua)

Before:
```lua
local x = 10
local y = 20
local sum = x + y
print(sum)
```

Steps:
1. Enter visual mode: `V`
2. Select lines with `x + y` and `print(sum)`
3. Press `<leader>re`
4. Type function name: `calculateSum`

After:
```lua
local function calculateSum(x, y)
    local sum = x + y
    print(sum)
end

local x = 10
local y = 20
calculateSum(x, y)
```

### Extract Variable Example (Python)

Before:
```python
result = some_function(arg1, arg2, arg3 * 2 + arg4)
```

Steps:
1. Enter visual mode: `v`
2. Select `arg3 * 2 + arg4`
3. Press `<leader>rv`
4. Type variable name: `calculated_value`

After:
```python
calculated_value = arg3 * 2 + arg4
result = some_function(arg1, arg2, calculated_value)
```

## Troubleshooting

### "Nothing happens" when pressing refactoring keys

1. **Check you're in the right mode:**
   - Extract Function/Variable require VISUAL mode (`v` or `V`)
   - Inline operations require NORMAL mode

2. **Check the language is supported:**
   - Run `:TSInstallInfo` to see installed Treesitter parsers
   - The file type must have a parser installed

3. **Check for error messages:**
   - Run `:messages` to see recent error messages
   - The plugin now shows success/failure messages

4. **Use the Telescope menu:**
   - Press `<leader>rr` to see what operations are available
   - If the menu is empty, the plugin doesn't support the current context

5. **Verify the plugin is loaded:**
   - Run `:Lazy` and check that `refactoring.nvim` is loaded
   - If not, try `:Lazy sync`

### Common Issues

**Issue:** "Refactor not available for this language"
- **Solution:** Install Treesitter parser with `:TSInstall <language>`

**Issue:** Visual mode selection doesn't work
- **Solution:** Make sure you're selecting complete statements/expressions

**Issue:** Can't extract certain code
- **Solution:** Some complex code patterns aren't supported. Try simplifying first.

## Key Bindings Summary

| Key | Mode | Action |
|-----|------|--------|
| `<leader>rr` | n/v | Open refactoring menu (Telescope) |
| `<leader>re` | v | Extract Function |
| `<leader>rf` | v | Extract Function To File |
| `<leader>rv` | v | Extract Variable |
| `<leader>ri` | n/v | Inline Variable |
| `<leader>rI` | n | Inline Function |
| `<leader>rb` | n | Extract Block |
| `<leader>rbf` | n | Extract Block To File |
| `<leader>rp` | n/v | Print variable (debug) |
| `<leader>rc` | n | Cleanup debug prints |

## Testing Your Setup

1. Open the test file: `:e /tmp/test_refactor.lua`
2. Enter visual mode and select `local result = a + b`
3. Press `<leader>rv` and name it `my_sum`
4. You should see the code refactored and a success message

Alternatively, press `<leader>rr` to open the Telescope menu and see available operations.
