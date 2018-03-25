import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import QtQml 2.5
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0

Pane{
    id: topFrame
    Layout.preferredHeight: 40
    Universal.background: "#1f1b28"
    padding: 0
    leftPadding: 18

   // signal closeSignal()
   // signal minimizeSignal()

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
            Layout.preferredWidth: topFrame.width - logoPane.width - closeAppBut.width - maximizedAppBut.width  - underAppBut.width - topFrame.leftPadding - settingsBut.width - logsBut.width
            anchors.left: logoPane.right
            padding: 0
            leftPadding: 12

            Text{
                text: "Precorder Extractor"
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
                   // window.x = window.x + d.x;
                   // window.y = window.y + d.y;
                   WindowControls.dragWindow(d.x, d.y)
                }
                onDoubleClicked: WindowControls.maximizeWindow()
            }
        }

        Button{
            id: logsBut
            width: 40
            height: 40
            Text{
                text: "LOGS"
                color: "#78757c"
                font.pixelSize: 13
                y: (parent.height - 15) / 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            background: Rectangle{
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: logsBut.hovered? "#2e283e" : "#191622"
            }

            MouseArea{
                id: logsButMouse
                hoverEnabled: true
                anchors.fill: logsBut
                onClicked: WindowControls.openLogs()
            }
        }

        Button{
            id: settingsBut
            width: 40
            height: 40
            Image {
                height: 18
                width: 18
                x: (parent.width - 18) / 2
                y: (parent.height - 18) / 2
                fillMode: Image.PreserveAspectFit
                source: "static/settings.svg"
            }

            background: Rectangle{
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: settingsBut.hovered? "#2e283e" : "#191622"
            }

            MouseArea{
                id: settingsButMouse
                hoverEnabled: true
                anchors.fill: settingsBut
                onClicked: WindowControls.openSettings()
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
               // onClicked: topFrame.minimizeSignal()
                onClicked: WindowControls.minimizeWindow()
            }
        }

        Button{
            id: maximizedAppBut
            width: 40
            height: 40
            Image {
                height: 18
                width: 18
                x: (parent.width - 18) / 2
                y: (parent.height - 18) / 2
                fillMode: Image.PreserveAspectFit
                source: WindowControls.maximizeState == 0 ? "static/photo-frame.svg" : "static/minimizeIcon.svg"
            }

            background: Rectangle{
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: maximizedAppBut.hovered? "#2e283e" : "#191622"
            }

            MouseArea{
                id: maximizedAppButMouse
                hoverEnabled: true
                anchors.fill: maximizedAppBut
               // onClicked: topFrame.minimizeSignal()
                onClicked: WindowControls.maximizeWindow()
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
               // onClicked: topFrame.closeSignal()
                onClicked: WindowControls.closeWindow()
            }
        }
    }
}
