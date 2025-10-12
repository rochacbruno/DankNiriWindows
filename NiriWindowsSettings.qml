import QtQuick
import QtQuick.Controls
import qs.Widgets

FocusScope {
    id: root

    property var pluginService: null

    implicitHeight: settingsColumn.implicitHeight
    height: implicitHeight

    Column {
        id: settingsColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Text {
            text: "Niri Windows Plugin Settings"
            font.pixelSize: 18
            font.weight: Font.Bold
            color: "#FFFFFF"
        }

        Text {
            text: "List and switch to open Niri windows from the launcher. This plugin integrates with the Niri window manager to provide quick window switching."
            font.pixelSize: 14
            color: "#CCFFFFFF"
            wrapMode: Text.WordWrap
            width: parent.width - 32
        }

        Rectangle {
            width: parent.width - 32
            height: 1
            color: "#30FFFFFF"
        }

        Column {
            spacing: 12
            width: parent.width - 32

            Text {
                text: "Trigger Configuration"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: "#FFFFFF"
            }

            Text {
                text: noTriggerToggle.checked ? "Window list is always active. Simply type an application name or window title in the launcher." : "Set a trigger prefix to activate the window switcher. Type the trigger followed by a search term."
                font.pixelSize: 12
                color: "#CCFFFFFF"
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Row {
                spacing: 12

                CheckBox {
                    id: noTriggerToggle
                    text: "No trigger (always active)"
                    checked: loadSettings("noTrigger", false)

                    contentItem: Text {
                        text: noTriggerToggle.text
                        font.pixelSize: 14
                        color: "#FFFFFF"
                        leftPadding: noTriggerToggle.indicator.width + 8
                        verticalAlignment: Text.AlignVCenter
                    }

                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 4
                        border.color: noTriggerToggle.checked ? "#4CAF50" : "#60FFFFFF"
                        border.width: 2
                        color: noTriggerToggle.checked ? "#4CAF50" : "transparent"

                        Rectangle {
                            width: 12
                            height: 12
                            anchors.centerIn: parent
                            radius: 2
                            color: "#FFFFFF"
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
                spacing: 12
                anchors.left: parent.left
                anchors.right: parent.right
                visible: !noTriggerToggle.checked

                Text {
                    text: "Trigger:"
                    font.pixelSize: 14
                    color: "#FFFFFF"
                    anchors.verticalCenter: parent.verticalCenter
                }

                DankTextField {
                    id: triggerField
                    width: 100
                    height: 40
                    text: loadSettings("trigger", "!")
                    placeholderText: "!"
                    backgroundColor: "#30FFFFFF"
                    textColor: "#FFFFFF"

                    onTextEdited: {
                        const newTrigger = text.trim()
                        saveSettings("trigger", newTrigger || "!")
                        saveSettings("noTrigger", newTrigger === "")
                    }
                }

                Text {
                    text: "Examples: !, @, win, etc."
                    font.pixelSize: 12
                    color: "#AAFFFFFF"
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
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#FFFFFF"
            }

            Column {
                spacing: 4
                leftPadding: 16

                Text {
                    text: "• Lists all open windows from Niri WM"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: "• Shows window title and workspace location"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: "• Search by application name or window title"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: "• Focused windows appear first in the list"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: "• Click or press Enter to switch to a window"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
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
                text: "Usage:"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#FFFFFF"
            }

            Column {
                spacing: 4
                leftPadding: 16
                bottomPadding: 24

                Text {
                    text: "1. Open Launcher (Ctrl+Space or click launcher button)"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: noTriggerToggle.checked ? "2. Type to search windows (e.g., 'firefox' or 'code')" : "2. Type your trigger followed by a search term (e.g., '!firefox' or '!code')"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: "3. All matching windows will appear in the list"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
                }

                Text {
                    text: "4. Select a window and press Enter to switch to it"
                    font.pixelSize: 12
                    color: "#CCFFFFFF"
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
                text: "Note:"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: "#FFFFFF"
            }

            Text {
                text: "This plugin only works when running DMS on the Niri window manager. It will not show any items on other window managers."
                font.pixelSize: 12
                color: "#CCFFFFFF"
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
