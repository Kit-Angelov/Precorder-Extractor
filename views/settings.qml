import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import QtQml 2.5
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
import QtQuick.Dialogs 1.3

Pane {
    id: settingsTextPane
    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: 0
    Universal.background: "#25212f"

    ColumnLayout{
        id: searchColumn
        anchors.fill: parent
        spacing: 0

        Pane{
            id: topFrame
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            Universal.background: "#1f1b28"
            padding: 0
            leftPadding: 18

            RowLayout{
                spacing: 0

                Pane{
                    id: logoPane
                    Layout.preferredHeight: topFrame.height
                    Layout.preferredWidth: 22
                    padding: 0
                    topPadding: (height - logo.height) / 2

                    Rectangle{
                        id:logo
                        color: "#2f65d7"
                        width: 22
                        height: 22
                        radius: height / 2
                        anchors.left: parent.left
                    }
                }

                Pane{
                    id: appNamePane
                    Layout.preferredHeight: topFrame.height
                    Layout.preferredWidth: topFrame.width - logoPane.width - closeAppBut.width - underAppBut.width - topFrame.leftPadding
                    anchors.left: logoPane.right
                    padding: 0
                    leftPadding: 12

                    Text{
                        text: "Settings"
                        color: "#fdfdfd"
                        font.pointSize: 11
                        topPadding: 11
                    }

                    MouseArea{
                        id: mouseFrame
                        height: parent.height
                        anchors{
                            top: parent.top
                            left:parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        property var clickPos: "1, 1"
                        onPressed: {
                            clickPos = Qt.point(mouse.x, mouse.y)
                        }
                        onPositionChanged: {
                            var d = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                           AppSettings.dragWindow(d.x, d.y)
                        }
                    }
                }

                Button{
                    id: underAppBut
                    width: 40
                    height: 40
                    Image {
                        height: 14
                        width: 14
                        x: (parent.width - 14) / 2
                        y: (parent.height - 14) / 2 + 6
                        fillMode: Image.PreserveAspectFit
                        source: "static/underline.svg"
                    }

                    background: Rectangle{
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        color: underAppBut.hovered? "#2e283e" : "#191622"
                    }

                    MouseArea{
                        id: underAppButMouse
                        hoverEnabled: true
                        anchors.fill: underAppBut
                        onClicked: AppSettings.minimizeWindow()
                    }
                }

                Button{
                    id: closeAppBut
                    width: 40
                    height: 40
                    Image {
                        height: 14
                        width: 14
                        x: (parent.width - 14) / 2
                        y: (parent.height - 14) / 2
                        fillMode: Image.PreserveAspectFit
                        source: "static/close.svg"
                    }

                    background: Rectangle{
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        color: closeAppBut.hovered? "#2e283e" : "#191622"
                    }

                    MouseArea{
                        id: closeAppButMouse
                        hoverEnabled: true
                        anchors.fill: closeAppBut
                        onClicked: AppSettings.closeWindow()
                    }
                }
            }
        }

        Pane{
            id: contentSettings
            Layout.fillWidth: true
            Layout.fillHeight: true
            padding: 20

            ColumnLayout{
                anchors.fill: parent
                spacing: 10

                Text{
                    id: titleText
                    text: "Enter the server address and port"
                    color: "#fbfbfd"
                    font.pointSize: 9
                }

                Text{
                    id: exampleText
                    text: "Example: 82.240.161.221 | 1780"
                    color: "#6b6778"
                    font.pointSize: 9
                }

                Pane{
                    id: textInputsPane
                    Layout.fillWidth: true
                    padding: 0

                    RowLayout{
                        id: leftVideoTopControlRow
                        anchors.fill: parent
                        spacing: 10

                        TextField{
                            id: hostInput
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 35
                            color: "#ece9f4"
                            padding: 15
                            font.pointSize: 10
                            background: Rectangle{
                                color: "#1b1725"
                                border.width: 0
                            }
                            text: AppSettings.currentHost
                            onTextChanged:{
                                applyBut.butState = true
                            }
                        }

                        TextField{
                            id: portInput
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 35
                            color: "#ece9f4"
                            padding: 15
                            font.pointSize: 10
                            background: Rectangle{
                                color: "#1b1725"
                                border.width: 0
                            }
                            text: AppSettings.currentPort
                            onTextChanged:{
                                applyBut.butState = true
                            }
                        }

                        Button{
                            id: applyBut
                            width: 50
                            height: portInput.height
                            Universal.theme: Universal.Dark
                            property var butState: false
                            Text {
                                text: "Apply"
                                color: applyBut.butState ? "#fbfbfd" : "gray"
                                font.pixelSize: 15
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            background: Rectangle{
                                implicitWidth: parent.width
                                implicitHeight: parent.height
                                color: {
                                    if (applyBut.butState){
                                        applyBut.hovered? "#2e283e" : "#191622"
                                    } else {
                                        "#191622"
                                    }
                                }
                            }

                            MouseArea{
                                id: applyButMouse
                                hoverEnabled: true
                                anchors.fill: applyBut
                                onClicked:{
                                    if (applyBut.butState){
                                        AppSettings.changeHostAndPort(hostInput.text, portInput.text)
                                        applyBut.butState = false
                                    }
                                }
                            }
                        }

                    }
                }
                Text{
                    id: titleSavePathText
                    text: "Select the path to extract"
                    color: "#fbfbfd"
                    font.pointSize: 9
                }

                Pane{
                    id: textInputsSavePathPane
                    Layout.fillWidth: true
                    padding: 0

                    RowLayout{
                        id: savePathInputRow
                        anchors.fill: parent
                        spacing: 10

                        TextField{
                            id: savePathInput
                            Layout.preferredWidth: 285
                            Layout.preferredHeight: 35
                            color: "#ece9f4"
                            padding: 15
                            font.pointSize: 10
                            background: Rectangle{
                                color: "#1b1725"
                                border.width: 0
                            }
                            readOnly: true
                            text: AppSettings.currentFolder
                        }

                        FolderDialog {
                            id: folderDialog
                            title: "Please choose a directory"
                            onAccepted: {
                                AppSettings.changeSavePath(folderDialog.folder)
                                Qt.quit()
                            }
                            onRejected: {
                                Qt.quit()
                            }
                        }

                        Button{
                            id: chooseSavePathBut
                            width: 50
                            height: portInput.height
                            Universal.theme: Universal.Dark
                            text: "Choose"

                            background: Rectangle{
                                implicitWidth: parent.width
                                implicitHeight: parent.height
                                color: chooseSavePathBut.hovered? "#2e283e" : "#191622"
                            }

                            MouseArea{
                                id: chooseSavePathButMouse
                                hoverEnabled: true
                                anchors.fill: chooseSavePathBut
                                onClicked:{
                                    folderDialog.visible = true
                                }
                            }
                        }

                    }
                }
                Text{
                    id: titleStorePathText
                    text: "Select the path to store"
                    color: "#fbfbfd"
                    font.pointSize: 9
                }

                Pane{
                    id: textInputsStorePathPane
                    Layout.fillWidth: true
                    padding: 0

                    RowLayout{
                        id: storePathInputRow
                        anchors.fill: parent
                        spacing: 10

                        TextField{
                            id: storePathInput
                            Layout.preferredWidth: 285
                            Layout.preferredHeight: 35
                            color: "#ece9f4"
                            padding: 15
                            font.pointSize: 10
                            background: Rectangle{
                                color: "#1b1725"
                                border.width: 0
                            }
                            readOnly: true
                            text: AppSettings.currentStoreFolder
                        }

                        FolderDialog {
                            id: folderStoreDialog
                            title: "Please choose a directory"
                            onAccepted: {
                                AppSettings.changeStorePath(folderStoreDialog.folder)
                                Qt.quit()
                            }
                            onRejected: {
                                Qt.quit()
                            }
                        }

                        Button{
                            id: chooseStorePathBut
                            width: 50
                            height: portInput.height
                            Universal.theme: Universal.Dark
                            text: "Choose"

                            background: Rectangle{
                                implicitWidth: parent.width
                                implicitHeight: parent.height
                                color: chooseStorePathBut.hovered? "#2e283e" : "#191622"
                            }

                            MouseArea{
                                id: chooseStorePathButMouse
                                hoverEnabled: true
                                anchors.fill: chooseStorePathBut
                                onClicked:{
                                    folderStoreDialog.visible = true
                                }
                            }
                        }

                    }
                }
            }
        }
    }
}