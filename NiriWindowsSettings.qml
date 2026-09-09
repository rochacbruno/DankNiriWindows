import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "niriWindows"

    StyledText {
        width: parent.width
        text: "Niri Windows Plugin"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "List and switch to open Niri windows from the launcher. This plugin integrates with the Niri window manager to provide quick window switching."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    ToggleSetting {
        id: noTriggerToggle
        settingKey: "noTrigger"
        label: "Always Active"
        description: value
            ? "Show Niri windows in regular launcher searches. Repeat the configured trigger to show only windows on the current workspace."
            : "Only show Niri windows after the configured trigger. Repeat the trigger to show only windows on the current workspace."
        defaultValue: false
    }

    Column {
        id: triggerSetting

        property string value: "!"
        property string savedValue: "!"
        property bool isInitialized: false

        width: parent.width
        spacing: Theme.spacingS

        function loadValue() {
            if (!root.pluginService)
                return;

            const loadedValue = root.loadValue("trigger", "!");
            if (triggerInput.activeFocus && isInitialized)
                return;

            value = loadedValue;
            savedValue = loadedValue;
            triggerInput.text = loadedValue;
            isInitialized = true;
        }

        function commit() {
            if (!isInitialized || triggerInput.text === savedValue)
                return;

            savedValue = triggerInput.text;
            root.saveValue("trigger", savedValue);
        }

        Component.onCompleted: Qt.callLater(loadValue)

        StyledText {
            text: "Trigger"
            font.pixelSize: Theme.fontSizeMedium
            font.weight: Font.Medium
            color: Theme.surfaceText
        }

        StyledText {
            width: parent.width
            text: {
                const currentTrigger = triggerSetting.value || "!";
                const repeatedTrigger = currentTrigger + currentTrigger;
                return noTriggerToggle.value
                    ? `Current-workspace shortcut: '${repeatedTrigger}'. The trigger is not required for regular window searches.`
                    : `Use '${currentTrigger}' for all workspaces and '${repeatedTrigger}' for the current workspace.`;
            }
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.surfaceVariantText
            wrapMode: Text.WordWrap
        }

        DankTextField {
            id: triggerInput
            width: parent.width
            placeholderText: "!"

            onTextChanged: {
                if (triggerSetting.isInitialized)
                    triggerSetting.value = text;
            }

            onEditingFinished: triggerSetting.commit()
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Features"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM

        Repeater {
            model: ["Lists all open windows from Niri WM", "Shows window title and workspace location", "Search by application name or window title", "Filter results to the current workspace", "Focused windows appear first in the list", "Click or press Enter to switch to a window"]

            StyledText {
                required property string modelData
                text: "• " + modelData
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Usage"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    Column {
        width: parent.width
        spacing: Theme.spacingXS
        leftPadding: Theme.spacingM

        Repeater {
            model: [
                "1. Open Launcher (Ctrl+Space or click launcher button)",
                noTriggerToggle.value
                    ? `2. Type normally to search all workspaces, or use '${(triggerSetting.value || "!") + (triggerSetting.value || "!")}' for the current workspace`
                    : `2. Use '${triggerSetting.value || "!"}' for all workspaces, or repeat it for the current workspace`,
                "3. Add a search term to filter by application name, title, or workspace",
                "4. Select a window and press Enter to switch to it"
            ]

            StyledText {
                required property string modelData
                text: modelData
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Note"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.Medium
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "This plugin only works when running DMS on the Niri window manager. It will not show any items on other window managers."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        bottomPadding: Theme.spacingL
    }
}
