# Niri Windows Plugin for DMS Launcher

[![RELEASE](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgithub.com%2Frochacbruno%2FDankNiriWindows%2Fraw%2Frefs%2Fheads%2Fmain%2Fplugin.json&query=version&style=for-the-badge&label=RELEASE&labelColor=101418&color=9ccbfb)](https://plugins.danklinux.com/niriwindows.html)

A launcher plugin that lists all open windows in the Niri window manager and allows quick switching between them.

*Example: Type `!` to list all open windows, or `!!` to list only windows on the current workspace.*

Grid Mode

![Niri Windows Plugin Screenshot](screenshot.png)


List Mode

![Niri Windows Plugin Screenshot](list_mode.png)

## Features

- **Window Listing**: Displays all open windows from the Niri window manager
- **Smart Search**: Filter windows by application name, window title, or workspace
- **Current Workspace Filter**: Repeat the configured trigger to show only windows on the current workspace
- **Quick Switching**: Click or press Enter to instantly switch to any window
- **Workspace Info**: Shows which workspace each window is on
- **Smart Sorting**: Focused windows appear first, then sorted by workspace
- **Default Trigger**: Uses `!` as the default trigger prefix (configurable)
- **Desktop Integration**: Automatically fetches application icons from desktop entries

## Installation

### Via DMS

```bash
dms plugins install NiriWindows
```

### Via DMS GUI
- Mod + ,
- Go to Plugins Tab
- Choose Browse
- Enable third party
- install NiriWindows

### Manually

```
cd ~/.config/DankMaterialShell/plugins
git clone https://github.com/rochacbruno/DankNiriWindows NiriWindows
```

1. Open DMS Settings (Ctrl+,)
2. Navigate to Plugins tab
3. Click "Scan for Plugins"
4. Enable the "NiriWindow" plugin with the toggle switch

## Requirements

- **Niri Window Manager**: This plugin only works when DMS is running on Niri WM
- **DMS Version**: Requires DMS version 0.1.18

## Usage

### With Default Settings (`!` Trigger)

- **Show all windows on all workspaces**: `!`
- **Search all workspaces for `firefox`**: `!firefox`
- **Show all windows on current workspace**: `!!`
- **Search current workspace for `firefox`**: `!!firefox`

The current-workspace mode is activated by repeating the configured trigger. For example, if the trigger is changed to `@`, use `@` to show all windows on all workspaces and `@@` to show all windows on the current workspace. For multi-character triggers, separate a current-workspace search term with a space (for example, `winwin firefox`).

### Searching for Windows

- **By application**: `!firefox` - Shows all Firefox windows
- **By title**: `!document` - Shows windows with "document" in the title
- **By workspace**: `!Workspace 2` - Shows windows on Workspace 2
- **All windows**: `!` - Shows all open windows
- **Current workspace**: `!!` - Shows all windows on the current workspace
- **Current workspace search**: `!!firefox` - Shows Firefox windows on the current workspace

### Always Active Mode

Enable **Always Active** in the plugin settings to include Niri windows in regular launcher searches without an activation trigger. The repeated trigger remains the current-workspace shortcut.

With the default trigger (`!`):

- Open the launcher with an empty query to include all Niri windows
- Type `firefox` to search windows across all workspaces
- Type `!!` to show only windows on the current workspace
- Type `!!firefox` to search Firefox windows only on the current workspace

### Customizing the Trigger

1. Open Settings → Plugins → Niri Windows
2. Change the trigger to a custom value (e.g., `@` or `win`)
3. Use the trigger once for all workspaces and repeat it for the current workspace (e.g., `@` / `@@` or `win` / `winwin`)
4. Or enable **Always Active** to remove the activation-trigger requirement. The repeated trigger still selects the current workspace


### Adding keybindings (niri)

```kdl
binds {
    Alt+Tab hotkey-overlay-title="Switch Windows" {
        spawn "dms" "ipc" "call" "spotlight" "openQuery" "!";
    }

    Mod+Shift+W hotkey-overlay-title="Windows on Current Workspace" {
        spawn "dms" "ipc" "call" "spotlight" "openQuery" "!!";
    }
}
```


## Window Information Display

Each window item shows:
- **Name**: Window title (or application name if no title)
- **Icon**: Application icon from desktop entry
- **Comment**: Application ID and workspace location

Example:
```
Window Title
org.mozilla.firefox • Workspace 1
```

## Sorting Behavior

Windows are sorted in the following order:
1. Currently focused window (appears first)
2. Workspace index (lower workspace numbers first)
3. Window name (alphabetically)

## How It Works

The plugin integrates with DMS's NiriService to:
1. Monitor all open windows via Niri's event stream
2. Track window properties (app_id, title, workspace, focus state)
3. Track the currently focused workspace for current-workspace filtering
4. Use `NiriService.focusWindow(windowId)` to switch windows
5. Refresh launcher results when windows or the focused workspace change

## Configuration

Settings are stored in `~/.config/DankMaterialShell/plugin_settings.json` under the `niriWindows` plugin key:

```json
{
  "pluginSettings": {
    "niriWindows": {
      "trigger": "!",
      "noTrigger": false
    }
  }
}
```

## Troubleshooting

**No windows appear:**
- Make sure you're running DMS on Niri window manager
- Check that the plugin is enabled in Settings → Plugins
- Verify you have open windows

**Plugin doesn't work:**
- This plugin only works on Niri WM, not Hyprland or other compositors
- Make sure DMS version is > 0.1.18

**Wrong icons showing:**
- Icons are fetched from desktop entries using heuristic lookup
- Some applications may not have proper desktop entries

## Files

- `plugin.json` - Plugin manifest and metadata
- `NiriWindowsLauncher.qml` - Main launcher component
- `NiriWindowsSettings.qml` - Settings UI
- `README.md` - This documentation file
- `screenshot.png` - Plugin screenshot

## Version

1.2.0

## Author

Bruno Cesar Rocha

