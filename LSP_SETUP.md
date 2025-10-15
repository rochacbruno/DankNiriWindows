# QML LSP Setup for NiriWindows Plugin

This document describes the LSP configuration for developing the NiriWindows plugin with proper autocompletion for DMS and Quickshell APIs.

## Problem

The NiriWindows plugin is developed separately from the main DMS codebase, which causes the QML Language Server to fail to resolve:
- DMS services (e.g., `NiriService`, `CompositorService`, `DesktopEntries`, `ToastService`)
- DMS widgets (e.g., `DankTextField`)
- Quickshell modules (e.g., `Quickshell.Io`, `Quickshell.Wayland`)

## Solution

### 1. QML LSP Configuration File

Created `.qmlls.ini` in the plugin directory with the following content:

```ini
[General]
no-cmake-calls=true
buildDir="/run/user/1000/quickshell/vfs/0c8e042c7cd2ac6750c31be2fde46ddb"
importPaths="/usr/bin:/usr/lib64/qt6/qml"
```

**IMPORTANT**:  The buildDir is dynamic, you have to update with the proper value,
check the `.qmlls.ini` from the root of your dms folder

**Location**: `/home/rochacbruno/.config/DankMaterialShell/plugins/NiriWindows/.qmlls.ini`

This configuration tells the QML Language Server where to find:
- Quickshell's installed QML modules at `/usr/lib64/qt6/qml`
- DMS source code at `/home/rochacbruno/.config/quickshell/dms`

### 2. Namespace Symlink

Created a symlink to enable `qs.*` namespace resolution:

```bash
ln -sfn /home/rochacbruno/.config/quickshell/dms /home/rochacbruno/.config/quickshell/qs
```

**Symlink**: `/home/rochacbruno/.config/quickshell/qs` → `/home/rochacbruno/.config/quickshell/dms`

This allows the LSP to properly resolve imports like:
- `import qs.Services` → `/home/rochacbruno/.config/quickshell/qs/Services/`
- `import qs.Widgets` → `/home/rochacbruno/.config/quickshell/qs/Widgets/`
- `import qs.Common` → `/home/rochacbruno/.config/quickshell/qs/Common/`

## What This Enables

With this setup, your Vim LSP (or any QML-aware LSP) can now autocomplete:

### Quickshell APIs
- `Quickshell` - Core Quickshell functionality
- `Quickshell.Io` - Process management, file I/O
- `Quickshell.Wayland` - Wayland compositor integration
- `Quickshell.Services.*` - System services (Mpris, Notifications, etc.)

### DMS Services
- `NiriService` - Niri window manager integration
  - Properties: `windows`, `workspaces`, `focusedWorkspaceId`
  - Methods: `focusWindow(windowId)`, `switchToWorkspace(index)`
- `CompositorService` - Compositor detection
  - Properties: `isNiri`, `isHyprland`
- `DesktopEntries` - Desktop entry lookup
  - Methods: `heuristicLookup(appId)`
- `ToastService` - Toast notifications
  - Methods: `showInfo(title, message)`, `showError(title, message)`
- `PluginService` - Plugin data management (injected as `pluginService`)
  - Methods: `loadPluginData(pluginId, key, defaultValue)`, `savePluginData(pluginId, key, value)`

### DMS Widgets
- `DankTextField` - Styled text input field
- `DankToggle` - Toggle switch
- `DankSlider` - Slider control
- Other custom widgets in `/home/rochacbruno/.config/quickshell/dms/Widgets/`

### DMS Common Utilities
- Common utilities from `/home/rochacbruno/.config/quickshell/dms/Common/`

## Directory Structure Reference

```
/usr/lib64/qt6/qml/Quickshell/           # Quickshell installed modules
├── Io/
├── Wayland/
├── Services/
│   ├── Mpris/
│   ├── Notifications/
│   └── SystemTray/
└── ...

/home/rochacbruno/.config/quickshell/
├── dms/                                  # DMS source code
│   ├── Services/                         # DMS services (NiriService, etc.)
│   ├── Widgets/                          # DMS widgets (DankTextField, etc.)
│   ├── Common/                           # Common utilities
│   ├── Modals/
│   ├── Modules/
│   └── shell.qml
└── qs -> dms/                           # Symlink for qs.* namespace

/home/rochacbruno/.config/DankMaterialShell/plugins/NiriWindows/
├── .qmlls.ini                           # LSP configuration (THIS FILE)
├── NiriWindowsLauncher.qml
├── NiriWindowsSettings.qml
└── plugin.json
```

## Verification

To verify the setup is working:

1. Open a QML file from this plugin in Vim
2. Type `NiriService.` and you should see autocomplete suggestions for properties like `windows`, `workspaces`
3. Type `import qs.` and you should see autocomplete suggestions for `Services`, `Widgets`, `Common`

## Notes

- This configuration is specific to this plugin directory
- The `.qmlls.ini` file is read by QML language servers (like `qmlls`)
- Make sure your Vim LSP is configured to use the QML language server for `.qml` files
- The symlink must remain in place for the `qs.*` namespace imports to work

## Environment Details

- **System**: Fedora 42 (Linux 6.16.9-200.fc42.x86_64)
- **Qt Version**: Qt 6.9.2
- **Quickshell**: Installed at `/usr/bin/quickshell`
- **DMS Version**: > 0.1.18


----

## Vim setup (not neovim)

```
" ---------------------------------------------------------------------------
" QML Language Server (qmlls)
" ---------------------------------------------------------------------------
" Requirements: Install qmlls (comes with Qt 6)
"   - Via Qt installation: Part of Qt 6.2+ development tools
"   - Arch Linux: pacman -S qt6-declarative (includes qmlls)
"   - Fedora: sudo dnf install qt6-declarative-devel
" Features: QML syntax checking, completion, diagnostics, hover information
if executable('qmlls')
    call LspAddServer([{'name': 'qmlls',
                 \   'filetype': 'qml',
                 \   'path': 'qmlls',
                 \   'args': []
                 \ }])
else
    call Alert("QML language server not found. Please install qmlls (Qt 6 declarative tools).")
endif
```
