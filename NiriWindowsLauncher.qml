import QtQuick
import Quickshell
import qs.Services
import qs.Common

QtObject {
    id: root

    property var pluginService: null
    property string trigger: "!"

    signal itemsChanged

    Component.onCompleted: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData("niriWindows", "trigger", "!");
    }

    property Connections niriConnections: Connections {
        target: NiriService
        function onWindowsChanged() {
            root.itemsChanged();
        }
    }

    function getItems(query) {
        if (!CompositorService.isNiri)
            return [];

        const windows = NiriService.windows || [];
        if (windows.length === 0)
            return [];

        const lowerQuery = query ? query.toLowerCase().trim() : "";
        const items = [];

        for (const window of windows) {
            if (!window.app_id)
                continue;
            const appId = window.app_id || "unknown";
            const title = window.title || "";
            const windowId = window.id;
            const workspaceId = window.workspace_id;

            let workspaceName = "";
            const workspace = NiriService.workspaces[workspaceId];
            if (workspace) {
                workspaceName = workspace.name || `Workspace ${workspace.idx}`;
            }

            const displayName = title || appId;
            const comment = title ? `${appId} • ${workspaceName}` : workspaceName;

            if (lowerQuery.length > 0) {
                const searchText = `${appId} ${title} ${workspaceName}`.toLowerCase();
                if (!searchText.includes(lowerQuery))
                    continue;
            }

            let icon = appId;
            const desktopEntry = DesktopEntries.heuristicLookup(appId);
            if (desktopEntry?.icon) {
                icon = desktopEntry.icon;
            }

            items.push({
                name: displayName,
                icon: icon,
                comment: comment,
                action: `focus:${windowId}`,
                categories: ["Niri Windows"],
                _isFocused: window.is_focused || false,
                _workspaceIdx: workspace ? workspace.idx : 999
            });
        }

        items.sort((a, b) => {
            if (a._isFocused && !b._isFocused)
                return -1;
            if (!a._isFocused && b._isFocused)
                return 1;
            if (a._workspaceIdx !== b._workspaceIdx)
                return a._workspaceIdx - b._workspaceIdx;
            return a.name.localeCompare(b.name);
        });

        return items;
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        const actionParts = item.action.split(":");
        const actionType = actionParts[0];
        const actionData = actionParts.slice(1).join(":");

        switch (actionType) {
        case "focus":
            focusWindow(parseInt(actionData));
            break;
        default:
            showToast("Unknown action: " + actionType);
        }
    }

    function focusWindow(windowId) {
        if (!CompositorService.isNiri) {
            showToast("This plugin only works on Niri");
            return;
        }

        const window = NiriService.windows.find(w => w.id === windowId);
        if (!window) {
            showToast("Window not found");
            return;
        }

        const success = NiriService.focusWindow(windowId);
        if (!success) {
            showToast("Failed to focus window");
        }
    }

    function showToast(message) {
        if (typeof ToastService !== "undefined") {
            ToastService.showInfo("Niri Windows", message);
        }
    }

    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData("niriWindows", "trigger", trigger);
    }
}
