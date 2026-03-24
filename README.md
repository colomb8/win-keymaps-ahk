# AHK Vim Mode + CapsLock Mod

AutoHotkey v2 script that adds a Vim-style navigation mode and some useful remappings for 60% keyboards. Designed for Windows environments but easily adaptable to other systems.

## Features

* Modal navigation mode to manage 60% keyboards and/or use some Vim motions without leaving the home row; visual mode indicator via a non-intrusive popup
* Quick insertion of accented characters using Right Alt as a layer

For ergonomics:

* CapsLock mapped to Ctrl
* Backtick mapped to Esc

## Modes

### INSERT (default)

* Standard keyboard behavior
* `Ctrl + CapsLock` activates NORMAL mode (aka vimMode)

### NORMAL

* Navigation:

  * `h` / `j` / `k` / `l` → arrow keys
  * `w` / `b` → word navigation
  * `o` / `p` → beginning / end of line
  * other bindings configurable in the script
* In NORMAL mode, return to INSERT with `i`, `a`
* For the full list of mappings, check the block:

```autohotkey
#HotIf vimMode
...
```

* Unmapped keys are blocked and the user is notified via a non-intrusive popup

## Special Character Input

The idea is to use `Right Alt` as the standard key to access additional characters (layer). A cycling mechanism allows quick insertion of accented characters and symbols. Check the mapping to view the full list and/or add custom characters.

Examples:

* `Right Alt + a` → `à`
* `Right Alt + e` → cycles through `è`, `é`, `€`
* `Right Alt + i` → `ì`
* `Right Alt + o` → `ò`
* `Right Alt + u` → `ù`

## Requirements

* Windows
* AutoHotkey v2.0

## Auto-start (optional)

To start the script automatically on login:

1. Press `Win + R`
2. Type `shell:startup`
3. Place the script (or a shortcut) in the folder

## Notes

* CapsLock no longer toggles uppercase. Remapped to `Right Alt + CapsLock`
* Some Windows system shortcuts cannot be intercepted by AutoHotkey (e.g. Win+L)
* Mappings are designed to be easily modified directly in the script
