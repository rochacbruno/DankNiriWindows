import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Widgets

FocusScope {
    id: root

    property var pluginService: null

    implicitHeight: settingsColumn.implicitHeight
    height: implicitHeight

    Column {
        id: settingsColumn
        anchors.fill: parent
        anchors.margins: Theme.spacingL
        spacing: Theme.spacingL

        Text {
            text: "Niri Windows Plugin Settings"
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.surfaceText
        }

        Text {
            text: "List and switch to open Niri windows from the launcher. This plugin integrates with the Niri window manager to provide quick window switching."
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.surfaceText
            wrapMode: Text.WordWrap
            width: parent.width - 32
        }

        Rectangle {
            width: parent.width - 32
            height: 1
            color: Theme.outlineVariant
        }

        Column {
            spacing: Theme.spacingM
            width: parent.width - 32

            Text {
                text: "Trigger Configuration"
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Text {
                text: noTriggerToggle.checked ? "Window list is always active. Simply type an application name or window title in the launcher." : "Set a trigger prefix to activate the window switcher. Type the trigger followed by a search term."
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Row {
                spacing: Theme.spacingM

                CheckBox {
                    id: noTriggerToggle
                    text: "No trigger (always active)"
                    checked: loadSettings("noTrigger", false)

                    contentItem: Text {
                        text: noTriggerToggle.text
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceText
                        leftPadding: noTriggerToggle.indicator.width + 8
                        verticalAlignment: Text.AlignVCenter
                    }

                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: Theme.cornerRadiusSmall
                        border.color: Theme.primary
                        border.width: 2
                        color: "transparent"

                        Rectangle {
                            width: 12
                            height: 12
                            anchors.centerIn: parent
                            color: Theme.secondary
                            visible: noTriggerToggle.checked
                        }
                    }

                    onCheckedChanged: {
                        saveSettings("noTrigger", checked)
                        if (checked) {
                            saveSettings("trigger", "")
                        } else {
                            const currentTrigger = triggerField.text || "!"
                            saveSettings("trigger", currentTrigger)
                        }
                    }
                }
            }

            Row {
                spacing: Theme.spacingM
                anchors.left: parent.left
                anchors.right: parent.right
                visible: !noTriggerToggle.checked

                Text {
                    text: "Trigger:"
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }

                DankTextField {
                    id: triggerField
                    width: 100
                    height: 40
                    text: loadSettings("trigger", "!")
                    placeholderText: "!"
                    backgroundColor: "#30FFFFFF"
                    textColor: Theme.surfaceText

                    onTextEdited: {
                        const newTrigger = text.trim()
                        saveSettings("trigger", newTrigger || "!")
                        saveSettings("noTrigger", newTrigger === "")
                    }
                }

                Text {
                    text: "Examples: !, @, win, etc."
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            width: parent.width - 32
            height: 1
            color: "#30FFFFFF"
        }

        Column {
            spacing: 8
            width: parent.width - 32

            Text {
                text: "Features:"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Column {
                spacing: 4
                leftPadding: 16

                Text {
                    text: "• Lists all open windows from Niri WM"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: "• Shows window title and workspace location"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: "• Search by application name or window title"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: "• Focused windows appear first in the list"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: "• Click or press Enter to switch to a window"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }
            }
        }

        Rectangle {
            width: parent.width - 32
            height: 1
            color: Theme.outlineVariant
        }

        Column {
            spacing: 8
            width: parent.width - 32

            Text {
                text: "Usage:"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Column {
                spacing: Theme.spacingXS
                leftPadding: 16
                bottomPadding: 24

                Text {
                    text: "1. Open Launcher (Ctrl+Space or click launcher button)"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: noTriggerToggle.checked ? "2. Type to search windows (e.g., 'firefox' or 'code')" : "2. Type your trigger followed by a search term (e.g., '!firefox' or '!code')"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: "3. All matching windows will appear in the list"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }

                Text {
                    text: "4. Select a window and press Enter to switch to it"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.surfaceText
                }
            }
        }

        Rectangle {
            width: parent.width - 32
            height: 1
            color: Theme.outlineVariant
        }

        Column {
            spacing: 8
            width: parent.width - 32

            Text {
                text: "Note:"
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            Text {
                text: "This plugin only works when running DMS on the Niri window manager. It will not show any items on other window managers."
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                wrapMode: Text.WordWrap
                width: parent.width
                bottomPadding: 24
            }
        }
    }

    function saveSettings(key, value) {
        if (pluginService) {
            pluginService.savePluginData("niriWindows", key, value)
        }
    }

    function loadSettings(key, defaultValue) {
        if (pluginService) {
            return pluginService.loadPluginData("niriWindows", key, defaultValue)
        }
        return defaultValue
    }
}
