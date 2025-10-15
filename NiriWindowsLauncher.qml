import QtQuick
import Quickshell
import qs.Services
import qs.Common

Item {
    id: root

    // Plugin properties
    property var pluginService: null
    property string trigger: "!"

    // Plugin interface signals
    signal itemsChanged()

    Component.onCompleted: {
        console.log("NiriWindows: Plugin loaded")

        // Load custom trigger from settings
        if (pluginService) {
            trigger = pluginService.loadPluginData("niriWindows", "trigger", "!")
        }
    }

    // Watch for Niri window changes
    Connections {
        target: NiriService
        function onWindowsChanged() {
            itemsChanged()
        }
    }

    // Required function: Get items for launcher
    function getItems(query) {
        // Check if we're running on Niri
        if (!CompositorService.isNiri) {
            return []
        }

        // Get all windows from NiriService
        const windows = NiriService.windows || []

        if (windows.length === 0) {
            return []
        }

        // Prepare query for filtering
        const lowerQuery = query ? query.toLowerCase().trim() : ""

        // Map windows to launcher items
        const items = []
        for (const window of windows) {
            // Skip windows without app_id
            if (!window.app_id) continue

            // Get window information
            const appId = window.app_id || "unknown"
            const title = window.title || ""
            const windowId = window.id
            const workspaceId = window.workspace_id

            // Find workspace name
            let workspaceName = ""
            const workspace = NiriService.workspaces[workspaceId]
            if (workspace) {
                workspaceName = workspace.name || `Workspace ${workspace.idx + 1}`
            }

            // Create display name
            const displayName = title || appId
            const comment = title ? `${appId} • ${workspaceName}` : workspaceName

            // Filter by query if provided
            if (lowerQuery.length > 0) {
                const searchText = `${appId} ${title} ${workspaceName}`.toLowerCase()
                if (!searchText.includes(lowerQuery)) {
                    continue
                }
            }

            // Try to get icon from desktop entry
            // Note: Don't call Quickshell.iconPath() here - the spotlight renderer does that
            let icon = appId // Start with app_id as icon name (works for many apps)
            const desktopEntry = DesktopEntries.heuristicLookup(appId)
            if (desktopEntry && desktopEntry.icon) {
                icon = desktopEntry.icon
            }

            // Create launcher item
            items.push({
                name: displayName,
                icon: icon,
                comment: comment,
                action: `focus:${windowId}`,
                categories: ["Niri Windows"],  // Must match plugin name from plugin.json
                // Store additional data for sorting
                _isFocused: window.is_focused || false,
                _workspaceIdx: workspace ? workspace.idx : 999
            })
        }

        // Sort items: focused first, then by workspace index
        items.sort((a, b) => {
            // Focused windows first
            if (a._isFocused && !b._isFocused) return -1
            if (!a._isFocused && b._isFocused) return 1

            // Then by workspace index
            if (a._workspaceIdx !== b._workspaceIdx) {
                return a._workspaceIdx - b._workspaceIdx
            }

            // Finally by name
            return a.name.localeCompare(b.name)
        })

        return items
    }

    // Required function: Execute item action
    function executeItem(item) {
        console.log("NiriWindows: executeItem called with item:", JSON.stringify(item))

        if (!item || !item.action) {
            console.warn("NiriWindows: Invalid item or action")
            return
        }

        console.log("NiriWindows: Executing item:", item.name, "with action:", item.action)

        const actionParts = item.action.split(":")
        const actionType = actionParts[0]
        const actionData = actionParts.slice(1).join(":")

        switch (actionType) {
            case "focus":
                focusWindow(parseInt(actionData))
                break
            default:
                console.warn("NiriWindows: Unknown action type:", actionType)
                showToast("Unknown action: " + actionType)
        }
    }

    // Helper function to focus a window
    function focusWindow(windowId) {
        if (!CompositorService.isNiri) {
            console.warn("NiriWindows: Not running on Niri")
            showToast("This plugin only works on Niri")
            return
        }

        console.log("NiriWindows: Attempting to focus window ID:", windowId, "type:", typeof windowId)

        // Verify the window still exists
        const window = NiriService.windows.find(w => w.id === windowId)
        if (!window) {
            console.warn("NiriWindows: Window ID", windowId, "not found in windows list")
            showToast("Window not found")
            return
        }

        console.log("NiriWindows: Found window:", window.app_id, window.title)

        // Use NiriService's built-in focusWindow method
        const success = NiriService.focusWindow(windowId)

        console.log("NiriWindows: focusWindow returned:", success)

        if (!success) {
            console.warn("NiriWindows: Failed to send focus command")
            showToast("Failed to focus window")
        }
    }

    // Helper function to show toast notification
    function showToast(message) {
        if (typeof ToastService !== "undefined") {
            ToastService.showInfo("Niri Windows", message)
        } else {
            console.log("NiriWindows Toast:", message)
        }
    }

    // Watch for trigger changes
    onTriggerChanged: {
        if (pluginService) {
            pluginService.savePluginData("niriWindows", "trigger", trigger)
        }
    }
}
