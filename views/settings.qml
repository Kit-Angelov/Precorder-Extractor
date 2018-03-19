import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import QtQml 2.5
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0

Pane {
    Layout.preferredWidth: 300
    Layout.preferredHeight: 200
    Universal.background: "#25212f"

    ColumnLayout{
        id: searchColumn
        anchors.fill: parent
        spacing: 0

        Text{
            id: titleText
            text: "Enter the server address and port"
            color: "#6b6778"
            font.pointSize: 9
        }

        Text{
            id: exampleText
            text: "Example: http://82.240.161.221 | 1780"
            color: "#6b6778"
            font.pointSize: 9
        }

        Pane{
            id: textInputsPane
            Layout.preferredWidth: 300

            RowLayout{
                id: leftVideoTopControlRow
                anchors.fill: parent
                spacing: 0

                TextField{
                    id: hostInput
                    Layout.fillWidth: true
                    color: "#ece9f4"
                    padding: 15
                    font.pointSize: 10
                    background: Rectangle{
                        color: "#1b1725"
                        border.width: 0
                    }
                }

                TextField{
                    id: portInput
                    Layout.fillWidth: true
                    color: "#ece9f4"
                    padding: 15
                    font.pointSize: 10
                    background: Rectangle{
                        color: "#1b1725"
                        border.width: 0
                    }
                }
            }
        }
    }
}