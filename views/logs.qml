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
    id: logsTextPane
    Layout.fillWidth: true
    Layout.fillHeight: true
    padding: 0
    Universal.background: "#25212f"
    property var flag: false

    ColumnLayout{
        id: middleColumn
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
                    Layout.preferredWidth: topFrame.width - logoPane.width - closeAppBut.width - maximizedAppBut.width  - underAppBut.width - topFrame.leftPadding
                    anchors.left: logoPane.right
                    padding: 0
                    leftPadding: 12

                    Text{
                        text: "Logs"
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
                           AppLogs.dragWindow(d.x, d.y)
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
                        onClicked: AppLogs.minimizeWindow()
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
                        source: AppLogs.maximizeState == 0 ? "static/photo-frame.svg" : "static/minimizeIcon.svg"
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
                        onClicked: AppLogs.maximizeWindow()
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
                        onClicked: AppLogs.closeWindow()
                    }
                }
            }
        }

        Pane{
            id: menu
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Universal.background: "transparent"
            padding: 0

            Button{
                id: appLogsBut
                anchors.left: parent.left
                height: 30
                width: 50
                highlighted: true
                Universal.theme: Universal.Dark
                Universal.accent: "#2e2a39"
                font.pointSize: 12
                padding: 0
                leftPadding: 0
                text: "App"

                background: Rectangle{
                    anchors.fill: parent
                    color: {
                        if (vlcLogsButMouse.pressed || logsTextPane.flag == false){
                            "#3b3649"
                        } else {
                            "#2e2a39"
                        }
                    }
                    border.width: appLogsBut.hovered? 2 : 0
                    border.color: "#534c67"
                }

                MouseArea{
                    id: appLogsButMouse
                    hoverEnabled: true
                    anchors.fill: appLogsBut
                    onClicked:{
                        logsTextPane.flag = false
                    }
                }
            }

            Button{
                id: vlcLogsBut
                anchors.left: appLogsBut.right
                height: 30
                width: 50
                highlighted: true
                Universal.theme: Universal.Dark
                Universal.accent: "#2e2a39"
                font.pointSize: 12
                padding: 0
                leftPadding: 0
                text: "Vlc"

                background: Rectangle{
                    anchors.fill: parent
                    color: {
                        if (vlcLogsButMouse.pressed || logsTextPane.flag){
                            "#3b3649"
                        } else {
                            "#2e2a39"
                        }
                    }
                    border.width: vlcLogsBut.hovered? 2 : 0
                    border.color: "#534c67"
                }

                MouseArea{
                    id: vlcLogsButMouse
                    hoverEnabled: true
                    anchors.fill: vlcLogsBut
                    onClicked:{
                        logsTextPane.flag = true
                    }
                }
            }

            Button{
                id: clearLogsBut
                anchors.right: parent.right
                height: 30
                width: 50
                highlighted: true
                Universal.theme: Universal.Dark
                Universal.accent: "#2e2a39"
                font.pointSize: 12
                padding: 0
                leftPadding: 0
                text: "Clear"

                background: Rectangle{
                    anchors.fill: parent
                    color: clearLogsButMouse.pressed? "#3b3649" : "#2e2a39"
                    border.width: clearLogsBut.hovered? 2 : 0
                    border.color: "#534c67"
                }

                MouseArea{
                    id: clearLogsButMouse
                    hoverEnabled: true
                    anchors.fill: clearLogsBut
                    onClicked:{
                        AppLogs.clearLogs()
                    }
                }
            }
        }

        ScrollView{
        id: scrollViewAppLogs
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: logsTextPane.flag ? false : true

            TextArea{
                id: appLogsArea
                Layout.fillWidth: true
                height: logsTextPane.height
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                color: "#fbfbfd"
                padding: 15
                font.pointSize: 9
                background: Rectangle{
                    color: "transparent"
                    border.width: 0
                }
                Connections {
                    target: AppLogs

                    onAppLogSignal:{
                        appLogsArea.append(appLogs)
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                id: scrollAppLogsAttribute
                parent: scrollViewAppLogs
                x: scrollViewAppLogs.mirrored ? 0 : scrollViewAppLogs.width - width
                y: scrollViewAppLogs.topPadding
                height: appLogsArea.height <= logsTextPane.height ? 0 : scrollViewAppLogs.availableHeight
                rightPadding: 5
                contentItem: Rectangle{
                    implicitWidth: 8
                    radius: width / 2
                    color: "#3e3a49"
                }

                background: Rectangle{
                    color: "transparent"
                }
            }
        }
        ScrollView{
        id: scrollViewVlcLogs
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: logsTextPane.flag ? true : false

            TextArea{
                id: vlcLogsArea
                Layout.fillWidth: true
                height: logsTextPane.height
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                color: "#fbfbfd"
                padding: 15
                font.pointSize: 9
                background: Rectangle{
                    color: "transparent"
                    border.width: 0
                }

                Connections {
                    target: AppLogs

                    onVlcLogSignal:{
                        vlcLogsArea.append(vlcLogs)
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                id: scrollVlcLogsAttribute
                parent: scrollViewVlcLogs
                x: scrollViewVlcLogs.mirrored ? 0 : scrollViewVlcLogs.width - width
                y: scrollViewVlcLogs.topPadding
                height: vlcLogsArea.height <= logsTextPane.height ? 0 : scrollViewVlcLogs.availableHeight
                rightPadding: 5
                contentItem: Rectangle{
                    implicitWidth: 8
                    radius: width / 2
                    color: "#3e3a49"
                }

                background: Rectangle{
                    color: "transparent"
                }
            }
        }
    }
}