import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import QtQml 2.5
import QtMultimedia 5.8
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0


ApplicationWindow {
    id: window
    title: "Precorder Extractor"
    flags: Qt.FramelessWindowHint
    visible: true
    width: 1295
    height: 690
    minimumHeight: 500
    minimumWidth: 1000
    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }
    Universal.theme: Universal.Dark
    Universal.accent: "#25212f"
    Universal.background: "transparent"

    property var firstStart : ""
    property var firstEnd : ""
    property var secondStart : ""
    property var secondEnd : ""
    property var thirdStart : ""
    property var thirdEnd : ""

    function addingStartTime(){
        var videoPositionStart = video.position
        var timeStart = timePosition(videoPositionStart)
        if (timesAddingTextFieldFirstStart.text.length > 0 && timesAddingTextFieldSecondStart.text.length > 0 && (timesAddingTextFieldThirdEnd.timePositionEnd > videoPositionStart || timesAddingTextFieldThirdEnd.timePositionEnd == 0)){
            timesAddingTextFieldThirdStart.text = timeStart
            timesAddingTextFieldThirdStart.timePositionStart = videoPositionStart
        } else if (timesAddingTextFieldFirstStart.text.length > 0 && (timesAddingTextFieldSecondEnd.timePositionEnd > videoPositionStart || timesAddingTextFieldSecondEnd.timePositionEnd == 0)) {
            timesAddingTextFieldSecondStart.text = timeStart
            timesAddingTextFieldSecondStart.timePositionStart = videoPositionStart
        } else if (timesAddingTextFieldFirstEnd.timePositionEnd > videoPositionStart || timesAddingTextFieldFirstEnd.timePositionEnd == 0) {
            timesAddingTextFieldFirstStart.text = timeStart
            timesAddingTextFieldFirstStart.timePositionStart = videoPositionStart
        }
    }
    function addingEndTime(){
        var videoPositionEnd = video.position
        var timeEnd = timePosition(videoPositionEnd)
        if (timesAddingTextFieldFirstEnd.text.length > 0 && timesAddingTextFieldSecondEnd.text.length > 0 && timesAddingTextFieldThirdStart.timePositionStart < videoPositionEnd) {
            timesAddingTextFieldThirdEnd.text = timeEnd
            timesAddingTextFieldThirdEnd.timePositionEnd = videoPositionEnd
        } else if (timesAddingTextFieldFirstEnd.text.length > 0 && timesAddingTextFieldSecondStart.timePositionStart < videoPositionEnd) {
            timesAddingTextFieldSecondEnd.text = timeEnd
            timesAddingTextFieldSecondEnd.timePositionEnd = videoPositionEnd
        } else if (timesAddingTextFieldFirstStart.timePositionStart < videoPositionEnd) {
            timesAddingTextFieldFirstEnd.text = timeEnd
            timesAddingTextFieldFirstEnd.timePositionEnd = videoPositionEnd
        }
    }

    function timePosition(videoPosition){
        var hours;
        var minutes;
        var seconds;
        var absHours = Math.floor(videoPosition / 3600000)
        var absMinutes = Math.floor(videoPosition / 60000)
        var absSeconds = Math.floor(videoPosition / 1000)
        hours = absHours
        if (absMinutes < 60){
            minutes = absMinutes
        } else {
            minutes = absMinutes % 60
        }
        if (absSeconds < 60){
            seconds = absSeconds
        } else {
            seconds = absSeconds % 60
        }
        if (hours < 10) {
            hours = "0" +  hours
        }
        if (minutes < 10) {
            minutes = "0" + minutes
        }
        if (seconds < 10) {
            seconds = "0" + seconds
        }
        return hours + ":" + minutes + ":" + seconds
    }
    SystemTrayIcon{
        visible: true
        iconSource: "static/circle.png"

        onActivated: {
            window.show()
//            window.raise()
            window.requestActivate()
        }
        menu: Menu {
            MenuItem{
                text: qsTr("Open")
                onTriggered: {
                    window.show()
//                    window.raise()
                    window.requestActivate()
                }
            }

            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }

    Pane{
        id:topRightPaneFrame
        height: 5
        width: 5
        anchors.top: parent.top
        anchors.right: parent.right
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: topRightArea
            anchors.fill: parent
            cursorShape: Qt.SizeBDiagCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseXChanged: {
                var dX = mouse.x - clickPosX
                window.setWidth(window.width + dX)
            }
            onMouseYChanged: {
                var dY = mouse.y - clickPosY
                window.y = window.y + dY;
                window.setHeight(window.height - dY)
            }
        }
    }
    Pane{
        id:topLeftPaneFrame
        width: 5
        height: 5
        anchors.top: parent.top
        anchors.left: parent.left
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: topLeftArea
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseXChanged: {
                var dX = mouse.x - clickPosX
                window.x = window.x + dX;
                window.setWidth(window.width - dX)
            }
            onMouseYChanged: {
                var dY = mouse.y - clickPosY
                window.y = window.y + dY;
                window.setHeight(window.height - dY)
            }
        }
    }
    Pane{
        id:botRightPaneFrame
        width: 5
        height: 5
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: botRightArea
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseXChanged: {
                var dX = mouse.x - clickPosX
                window.setWidth(window.width + dX)
            }
            onMouseYChanged: {
                var dY = mouse.y - clickPosY
                window.setHeight(window.height + dY)
            }
        }
    }
    Pane{
        id:botLeftPaneFrame
        width: 5
        height: 5
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: botleftArea
            anchors.fill: parent
            cursorShape: Qt.SizeBDiagCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseXChanged: {
                var dX = mouse.x - clickPosX
                window.x = window.x + dX;
                window.setWidth(window.width - dX)
            }
            onMouseYChanged: {
                var dY = mouse.y - clickPosY
                window.setHeight(window.height + dY)
            }
        }
    }
    Pane{
        id:topPaneFrame
        anchors.top: parent.top
        anchors.left: topLeftPaneFrame.right
        anchors.right: topRightPaneFrame.left
        height: 5
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: topArea
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseYChanged: {
                var dY = mouse.y - clickPosY
                window.y = window.y + dY;
                window.setHeight(window.height - dY)
                smooth: true
            }
        }
    }
    Pane{
        id:botPaneFrame
        anchors.bottom: parent.bottom
        anchors.left: botLeftPaneFrame.right
        anchors.right: botRightPaneFrame.left
        height: 5
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: botArea
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseYChanged: {
                var dY = mouse.y - clickPosY
                window.setHeight(window.height + dY)
                smooth: true
            }
        }
    }
    Pane{
        id:leftPaneFrame
        anchors.bottom: botLeftPaneFrame.top
        anchors.left: parent.left
        anchors.top: topLeftPaneFrame.bottom
        width: 5
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: leftArea
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseXChanged: {
                var dX = mouse.x - clickPosX
                window.x = window.x + dX;
                window.setWidth(window.width - dX)
            }
        }
    }
    Pane{
        id:rightPaneFrame
        anchors.bottom: botRightPaneFrame.top
        anchors.right: parent.right
        anchors.top: topRightPaneFrame.bottom
        width: 5
        Universal.background: "transparent"
        padding: 0

        MouseArea{
            id: rightArea
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            property var clickPosX: "1"
            property var clickPosY: "1"
            onPressed: {
                clickPosX: mouseX
                clickPosY: mouseY
            }
            onMouseXChanged: {
                var dX = mouse.x - clickPosX
                window.setWidth(window.width + dX)
            }
        }
    }

    Pane{
        id: mainPaneFrame
        anchors.top: topPaneFrame.bottom
        anchors.bottom: botPaneFrame.top
        anchors.left: leftPaneFrame.right
        anchors.right: rightPaneFrame.left
        Universal.background: "black"
        padding: 0

        ColumnLayout{
            spacing: 0
            anchors.fill: parent

            Pane{
                id: topFrame
                Layout.preferredWidth: parent.width
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
                            text: "Precorder Extractor"
                            color: "#fdfdfd"
                            font.pointSize: 11
                            topPadding: 11
                        }

                        MouseArea{
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
                                window.x = window.x + d.x;
                                window.y = window.y + d.y;
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
                            onClicked: window.showMinimized()
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
                            onClicked: window.hide()
                        }
                    }
                }
            }

            RowLayout{
                spacing: 0
                Pane{
                    id: middlePane
                    anchors.left: leftPane.right
                    anchors.right: rightPane.left
        //            Material.elevation: 5
                    Layout.fillWidth: true
                    Layout.preferredWidth: 770
        //            Layout.minimumWidth: 100
        //            Layout.maximumWidth: 800
                    Layout.fillHeight: true
                    padding: 0

                    ColumnLayout{
                        id: middleColumn
                        anchors.fill: parent
                        spacing: 0

                        Pane{
                            id: videoPane
                            Layout.fillWidth: true
                            Layout.preferredHeight: 450
                            Layout.fillHeight: true
                            Universal.background: "black"
                            padding: 0

                            Video{
                                  id: video
                                  anchors.fill: parent
                    //              source: "https://www.youtube.com/watch?v=p3ZCmT7PJNQ"
                                  source: "https://www.rmp-streaming.com/media/bbb-360p.mp4"
                                //  source: "static/qwer.mp4"
                                  fillMode: VideoOutput.PreserveAspectFit
                                  notifyInterval: 20
                                  MouseArea {
                                          anchors.fill: parent
                                          onClicked: {
                                              video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
                                          }
                                      }
                                  focus: true
                                  Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
                            }
                        }

                        Pane{
                            id: videoSliderPane
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            padding: 0
                            leftPadding: 10
                            rightPadding: 10

                            Slider{
                                id: videoSlider
                                anchors.fill: parent
                                from: 0
                                to: video.duration
                                stepSize: 0.1
                                value: {
                                    if (video.playbackState == MediaPlayer.PlayingState || video.playbackState == MediaPlayer.PausedState){
                                        video.position
                                    } else {
                                        0
                                    }
                                }

                                handle: Rectangle{
                                    id: sliderHandle
                                    x: videoSlider.leftPadding + videoSlider.visualPosition * (videoSlider.availableWidth - width)
                                    y: videoSlider.topPadding + videoSlider.availableHeight / 2 - height / 2
                                    color: "#fbfbfd"
                                    border.width: 0
                                    implicitWidth: 2
                                    implicitHeight: 24
                                }
                                background: Rectangle{
                                    x: videoSlider.leftPadding
                                    y: videoSlider.topPadding + videoSlider.availableHeight / 2 - height / 2
        //                            implicitWidth: videoSlider.availableWidth
                                    implicitHeight: 6
                                    width: videoSlider.availableWidth
                                    height: implicitHeight
                                    color: "#2a2927"
                                    radius: 3

                                    Rectangle {
                                        width: videoSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: "#246bd5"
                                        radius: 2
                                    }
                                }
                                Keys.onLeftPressed: video.seek(video.position - 5000)
                                Keys.onRightPressed: video.seek(video.position + 5000)

                                onMoved: {
                                    video.pause()
                                    video.seek(value)
                                }
//                                function videoSeek(){
//                                    if (video.status != MediaPlayer.Loading) {
//                                        video.seek(value)
//                                    }
//                                }
//                                onPositionChanged:  {
//                                    if (drag.active) {
//                                        updatePosition()
//                                    }
//                                }
                            }
                        }

                        Pane{
                            id: videoTopControlsPane
                            Layout.fillWidth: true
                            Layout.preferredHeight: 65
                            padding: 0
                            leftPadding: 33
                            rightPadding: 33
                            Universal.background: "#120f1a"

                            RowLayout{
                                id: videoTopControlsRow
                                anchors.fill: parent
                                spacing: 0

                                Pane{
                                    id: leftVideoTopControlPane
                                    padding: 0
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 223
                                    Layout.fillWidth: true

                                    RowLayout{
                                        id: leftVideoTopControlRow
                                        anchors.fill: parent
                                        spacing: 0

                                        ComboBox{
                                            id: leftVideoTopControlCombobox
                                            Layout.preferredWidth: 80
                                            Universal.theme: Universal.Light
                                            padding: 2
                                            font.pointSize: 9
                                            textRole: "key"
                                            model: ListModel {
                                                ListElement {key: "1 Min"; value: 60000}
                                                ListElement {key: "5 Min"; value: 300000}
                                                ListElement {key: "15 Min"; value: 900000}
                                            }
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            popup.background: Rectangle{
                                                color: "#fdfdfb"
                                            }
                                            popup.font.pointSize: 9
                                        }

                                        RoundButton{
                                            id: leftVideoTopControlArrowLeftBut
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            anchors.left: leftVideoTopControlCombobox.right
                                            anchors.leftMargin: 18
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 24

                                            Image {
                                                height: 15
                                                x: (parent.width - 15) / 2
                                                y: (parent.height - 15) / 2
                                                fillMode: Image.PreserveAspectFit
                                                source: "static/double-angle-pointing-to-right (2).svg"
                                            }
                                            background: Rectangle{
                                                anchors.fill: parent
                                                color: leftVideoTopControlArrowLeftButMouse.pressed? "#3b3649" : "#2e2a39"
                                                radius: parent.height / 2
                                                border.width: leftVideoTopControlArrowLeftBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: leftVideoTopControlArrowLeftButMouse
                                                hoverEnabled: true
                                                anchors.fill: leftVideoTopControlArrowLeftBut
                                                onClicked: {
                                                    video.seek(video.position - leftVideoTopControlCombobox.model.get(leftVideoTopControlCombobox.currentIndex).value)
                                                }
                                            }
                                        }

                                        RoundButton{
                                            id: leftVideoTopControlArrowRightBut
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            anchors.left: leftVideoTopControlArrowLeftBut.right
                                            anchors.leftMargin: 10
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 24

                                            Image {
                                                height: 15
                                                width: 15
                                                x: (parent.width - 15) / 2
                                                y: (parent.height - 15) / 2
                                                fillMode: Image.PreserveAspectFit
                                                source: "static/double-angle-pointing-to-right.svg"
                                            }
                                            background: Rectangle{
                                                anchors.fill: parent
                                                color: leftVideoTopControlArrowRightButMouse.pressed? "#3b3649" : "#2e2a39"
                                                radius: parent.height / 2
                                                border.width: leftVideoTopControlArrowRightBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: leftVideoTopControlArrowRightButMouse
                                                hoverEnabled: true
                                                anchors.fill: leftVideoTopControlArrowRightBut
                                                onClicked: {
                                                    video.seek(video.position + leftVideoTopControlCombobox.model.get(leftVideoTopControlCombobox.currentIndex).value)
                                                }
                                            }
                                        }

                                        Rectangle{
                                            id: borderVerticalLeftImmitation
                                            Layout.preferredHeight: parent.height - 3
                                            width: 4
                                            color: "#090611"
                                            radius: 2
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                        }
                                    }
                                }

                                Pane{
                                    id: middleVideoTopControlPane
                                    padding: 0
                                    leftPadding: 20
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 247
                                    Layout.fillWidth: true

                                    RowLayout{
                                        id: middleVideoTopControlRow
                                        anchors.fill: parent
                                        spacing: 0

                                        ComboBox{
                                            id: middleVideoTopControlCombobox
                                            Layout.preferredWidth: 80
                                            Universal.theme: Universal.Light
                                            padding: 2
                                            font.pointSize: 9
                                            textRole: "key"
                                            model: ListModel {
                                                ListElement {key: "5 Sec"; value: 5000}
                                                ListElement {key: "15 Sec"; value: 15000}
                                                ListElement {key: "30 Sec"; value: 30000}
                                            }
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            popup.background: Rectangle{
                                                color: "#fdfdfb"
                                            }
                                            popup.font.pointSize: 9
                                        }

                                        RoundButton{
                                            id: middleVideoTopControlArrowLeftBut
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            anchors.left: middleVideoTopControlCombobox.right
                                            anchors.leftMargin: 18
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 24

                                            Image {
                                                height: 15
                                                width: 15
                                                x: (parent.width - 15) / 2
                                                y: (parent.height - 15) / 2
                                                fillMode: Image.PreserveAspectFit
                                                source: "static/left-angle-bracket.svg"
                                            }

                                            background: Rectangle{
                                                anchors.fill: parent
                                                color: middleVideoTopControlArrowLeftButMouse.pressed? "#3b3649" : "#2e2a39"
                                                radius: parent.height / 2
                                                border.width: middleVideoTopControlArrowLeftBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: middleVideoTopControlArrowLeftButMouse
                                                hoverEnabled: true
                                                anchors.fill: middleVideoTopControlArrowLeftBut
                                                onClicked: {
                                                    video.seek(video.position - middleVideoTopControlCombobox.model.get(middleVideoTopControlCombobox.currentIndex).value)
                                                }
                                            }
                                        }

                                        RoundButton{
                                            id: middleVideoTopControlArrowRightBut
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            anchors.left: middleVideoTopControlArrowLeftBut.right
                                            anchors.leftMargin: 10
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 24

                                            Image {
                                                height: 15
                                                width: 15
                                                x: (parent.width - 15) / 2
                                                y: (parent.height - 15) / 2
                                                fillMode: Image.PreserveAspectFit
                                                source: "static/left-angle-bracket (2).svg"

                                            }
                                            background: Rectangle{
                                                anchors.fill: parent
                                                color: middleVideoTopControlArrowRightButMouse.pressed? "#3b3649" : "#2e2a39"
                                                radius: parent.height / 2
                                                border.width: middleVideoTopControlArrowRightBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: middleVideoTopControlArrowRightButMouse
                                                hoverEnabled: true
                                                anchors.fill: middleVideoTopControlArrowRightBut
                                                onClicked: {
                                                    video.seek(video.position + middleVideoTopControlCombobox.model.get(middleVideoTopControlCombobox.currentIndex).value)
                                                }
                                            }

                                        }

                                        Rectangle{
                                            id: borderVerticalMiddleImmitation
                                            Layout.preferredHeight: parent.height - 3
                                            width: 4
                                            color: "#090611"
                                            radius: 2
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                        }
                                    }
                                }

                                Pane{
                                    id: rightLeftVideoTopControlPane
                                    padding: 0
                                    leftPadding: 20
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 160
                                    Layout.fillWidth: true

                                    RowLayout{
                                        id: rightLeftVideoTopControlRow
                                        anchors.fill: parent
                                        spacing: 0

                                        RoundButton{
                                            id: rightLeftVideoTopControlPauseBut
                                            anchors.left: parent.left
                                            anchors.leftMargin: -4
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 18

                                            Image {
                                                height: 15
                                                width: 15
                                                x: (parent.width - 15) / 2
                                                y: (parent.height - 15) / 2
                                                fillMode: Image.PreserveAspectFit
                                                source: "static/pause-button.svg"
                                            }
                                            background: Rectangle{
                                                anchors.fill: parent
//                                                color: rightLeftVideoTopControlPauseButMouse.pressed ? "#3b3649" : "#2e2a39"
                                                color: {
                                                    if (rightLeftVideoTopControlPauseButMouse.pressed ||  video.playbackState == MediaPlayer.PausedState) {
                                                        "#3b3649"
                                                    } else {
                                                        "#2e2a39"
                                                    }
                                                }
                                                radius: parent.height / 2
                                                border.width: rightLeftVideoTopControlPauseBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: rightLeftVideoTopControlPauseButMouse
                                                hoverEnabled: true
                                                anchors.fill: rightLeftVideoTopControlPauseBut
                                                onClicked: {
                                                    if (video.playbackState == MediaPlayer.PlayingState) {
                                                        video.pause()
                                                    } else if (video.playbackState == MediaPlayer.PausedState){
                                                        video.play()
                                                    }
                                                }
                                            }
                                        }

                                        Text{
                                            id: videoTimer
                                            anchors.left: rightLeftVideoTopControlPauseBut.right
                                            anchors.leftMargin: 10
                                            text: timePosition(video.position)
                                            font.pointSize: 12
                                            color: "#fdfdfb"
                                        }
                                        Rectangle{
                                            id: borderVerticalRightImmitation
                                            Layout.preferredHeight: parent.height - 3
                                            width: 4
                                            color: "#090611"
                                            radius: 2
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                        }
                                    }
                                }

                                Pane{
                                    id: rightRightVideoTopControlPane
                                    padding: 0
                                    leftPadding: 20
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 110
                                    Layout.fillWidth: true

                                    RowLayout{
                                        id: rightRightVideoTopControlRow
                                        anchors.fill: parent
                                        spacing: 0

                                        RoundButton{
                                            id: rightRightVideoTopControlLeftBrackBut
                                            anchors.left: parent.left
                                            anchors.leftMargin: -4
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 12
                                            padding: 0
                                            leftPadding: 0
                                            topPadding: -2
                                            text: "\u005b"

                                            background: Rectangle{
                                                anchors.fill: parent
                                                color: rightRightVideoTopControlLeftBrackButMouse.pressed? "#3b3649" : "#2e2a39"
                                                radius: parent.height / 2
                                                border.width: rightRightVideoTopControlLeftBrackBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: rightRightVideoTopControlLeftBrackButMouse
                                                hoverEnabled: true
                                                anchors.fill: rightRightVideoTopControlLeftBrackBut
                                                onClicked:{
                                                    addingStartTime()
                                                }
                                            }
                                        }
                                        RoundButton{
                                            id: rightRightVideoTopControlRightBrackBut
                                            anchors.left: rightRightVideoTopControlLeftBrackBut.right
                                            anchors.leftMargin: 5
                                            Layout.preferredHeight: 42
                                            Layout.preferredWidth: 42
                                            highlighted: true
                                            Universal.accent: "#2e2a39"
                                            font.pointSize: 12
                                            padding: 0
                                            leftPadding: 3
                                            topPadding: -2
                                            text: "\u005d"

                                            background: Rectangle{
                                                anchors.fill: parent
                                                color: rightRightVideoTopControlRightBrackButMouse.pressed? "#3b3649" : "#2e2a39"
                                                radius: parent.height / 2
                                                border.width: rightRightVideoTopControlRightBrackBut.hovered? 2 : 0
                                                border.color: "#534c67"
                                            }

                                            MouseArea{
                                                id: rightRightVideoTopControlRightBrackButMouse
                                                hoverEnabled: true
                                                anchors.fill: rightRightVideoTopControlRightBrackBut
                                                onClicked: {
                                                    addingEndTime()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Pane{
                            id: videoBotControlsPane
                            Layout.fillWidth: true
                            Layout.preferredHeight: 70
                            topPadding: 0
                            leftPadding: 33
                            rightPadding: 33
                            Universal.background: "#120f1a"

                            RowLayout{
                                id: videoBotControlsRow
                                anchors.fill: parent
                                spacing: 0

                                Button{
                                    id: playBut
                                    width: 110
                                    height: 45
                                    anchors.left: parent.left

                                    Text{
                                        text: video.playbackState == MediaPlayer.PlayingState || video.playbackState == MediaPlayer.PausedState ? "STOP" : "PLAY"
                                        y: (parent.height -15) / 2
                                        color: "white"
                                        x: 50
                                    }

                                    Image {
                                        height: 15
                                        width: 15
                                        x: 20
                                        y: (parent.height - 15) / 2
                                        fillMode: Image.PreserveAspectFit
                                        source:  video.playbackState == MediaPlayer.PlayingState || video.playbackState == MediaPlayer.PausedState ? "static/stop.svg" : "static/play-button.svg"

                                    }

                                    background: Rectangle{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height
                                        color: playButMouse.pressed? "#1b80e4" : "#176cbf"
                                        radius: parent.height / 2
                                        border.width: playBut.hovered? 2 : 0
                                        border.color: "#4899ea"
                                    }

                                    MouseArea{
                                        id: playButMouse
                                        hoverEnabled: true
                                        anchors.fill: playBut
                                        onClicked: {
                                            video.playbackState == MediaPlayer.PlayingState || video.playbackState == MediaPlayer.PausedState ? video.stop() : video.play()
                                        }
                                    }
                                }

                                Button{
                                    id: extractBut
                                    width: 133
                                    height: 45
                                    anchors.right: storeBut.left
                                    anchors.rightMargin: 15

                                    Text{
                                        text: "EXTRACT"
                                        y: (parent.height -15) / 2
                                        color: "white"
                                        x: 50
                                    }

                                    Image {
                                        height: 15
                                        width: 15
                                        x: 20
                                        y: (parent.height - 15) / 2
                                        fillMode: Image.PreserveAspectFit
                                        source: "static/downloading-down-arrow.svg"

                                    }
                                    background: Rectangle{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height
                                        color: extractButMouse.pressed? "#3b3649" : "#2e2a39"
                                        radius: parent.height / 2
                                        border.width: extractBut.hovered? 2 : 0
                                        border.color: "#534c67"
                                    }

                                    MouseArea{
                                        id: extractButMouse
                                        hoverEnabled: true
                                        anchors.fill: extractBut
                                    }

                                }
                                Button{
                                    id: storeBut
                                    width: 120
                                    height: 45
                                    anchors.right: parent.right
                                    highlighted: true
                                    Text{
                                        text: "STORE"
                                        y: (parent.height -15) / 2
                                        color: "white"
                                        x: 50
                                    }

                                    Image {
                                        height: 15
                                        width: 15
                                        x: 20
                                        y: (parent.height - 15) / 2
                                        fillMode: Image.PreserveAspectFit
                                        source: "static/up-arrow-upload-button.svg"

                                    }

                                    background: Rectangle{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height
                                        color: storeButMouse.pressed? "#3b3649" : "#2e2a39"
                                        radius: parent.height / 2
                                        border.width: storeBut.hovered? 2 : 0
                                        border.color: "#534c67"
                                    }

                                    MouseArea{
                                        id: storeButMouse
                                        hoverEnabled: true
                                        anchors.fill: storeBut
                                    }

                                }
                            }
                        }
                    }
                }
                Pane{
                    id: leftPane
                    anchors.left: parent.left
        //            Material.elevation: 5
        //            Layout.fillWidth: true
                    Layout.preferredWidth: 255
        //            Layout.minimumWidth: 50
        //            Layout.maximumWidth: 400
                    Layout.fillHeight: true
                    padding: 0

                    ColumnLayout{
                        id: leftColumn
                        anchors.fill: parent
                        spacing: 0
                        Pane{
                            id: searchChannelPane
                            Layout.fillWidth: true
                            Layout.preferredHeight: 176
                            Universal.background: "#25212f"
                            padding: 0

                            ColumnLayout{
                                id: searchChannelColumn
                                anchors.fill: parent
                                spacing: 0

                                Pane{
                                    id: searchPane
                                    Layout.preferredHeight: searchChannelPane.height / 2
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 20
                                    bottomPadding: 0
                                    leftPadding: 18
                                    rightPadding: 24

                                    ColumnLayout{
                                        id: searchColumn
                                        anchors.fill: parent
                                        spacing: 0

                                        Text{
                                            id: searchText
                                            text: "SEARCH"
                                            color: "#6b6778"
                                            font.pointSize: 9
                                        }
                                        TextField{
                                            id: searchInput
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
                                Pane{
                                    id: channelPane
                                    Layout.preferredHeight: searchChannelPane.height / 2
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 12
                                    bottomPadding: 8
                                    leftPadding: 18
                                    rightPadding: 24

                                    ColumnLayout{
                                        id: channelColumn
                                        anchors.fill: parent
                                        spacing: 0

                                        Text{
                                            id: channelText
                                            text: "CHANNEL"
                                            color: "#6b6778"
                                            font.pointSize: 9
                                        }
                                        ComboBox{
                                            id: channelCombobox
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 35
                                            padding: 2
                                            font.pointSize: 10
                                            model: ListChannels.channels
                                            textRole: "name"
                                            background: Rectangle{
                                                color: "#1b1725"
                                                border.width: 0
                                            }
                                            popup.background: Rectangle{
                                                color: "#2b263a"
                                            }

                                            indicator: Canvas{
                                                id: comboBoxChannelCanvas
                                                width: 12
                                                height: 9
                                                x: channelCombobox.width - width - channelCombobox.rightPadding
                                                y: channelCombobox.topPadding + (channelCombobox.availableHeight - height) / 2
                                                contextType: "2d"

                                                Connections{
                                                    target: channelCombobox
                                                    onPressedChanged: comboBoxChannelCanvas.requestPaint()
                                                }
                                                onPaint: {
                                                    context.reset();
                                                    context.moveTo(0, 0);
                                                    context.lineTo(width, 0);
                                                    context.lineTo(width/2, height);
                                                    context.closePath();
                                                    context.fillStyle = channelCombobox.pressed ? "#a69fbc" : "#a69fbc";
                                                    context.fill();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Pane{
                            id: wraplistMediaPane
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredHeight: 438
                            Universal.background: "#1b1725"
                            padding: 0

                            ColumnLayout{
                                id: wraplistMediaColumn
                                anchors.fill: parent
                                spacing: 0

                                Pane{
                                    id: listMediaPane
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Component {
                                        id: mediaContentDeligate

                                        Pane{
                                            id: itemMediaPane
                                            width: parent.width
                                            height: 70
                                            leftPadding: 18
                                            rightPadding: 40
                                            topPadding: 10
                                            bottomPadding: 0

                                            Rectangle{
                                                id: itemMediaRectangle
                                                width: parent.width
                                                height: 58

                                                Pane{
                                                    id: itemMediaContentPane
                                                    padding: 0
                                                    leftPadding: 3
                                                    height: parent.height
                                                    width: parent.width

                                                    RowLayout{
                                                        width: parent.width
                                                        spacing: 12

                                                        Rectangle{
                                                            id: wrapItemMediaContentImage
                                                            width: 45
                                                            height: 45
                                                            radius: width / 2
                                                            anchors.top: parent.top

                                                            Image {
                                                                id: itemMediaContentImage
                                                                fillMode: Image.PreserveAspectFit
                                                                width: 45; height: 45
                                                                anchors.fill: parent
                                                                source: "static/brand.gif"
                                                                visible: false
                                                            }
                                                            OpacityMask{
                                                                anchors.fill: itemMediaContentImage
                                                                source: itemMediaContentImage
                                                                maskSource: wrapItemMediaContentImage
                                                            }
                                                        }
                                                        Pane{
                                                            Layout.fillHeight: true
                                                            Layout.fillWidth: true
                                                            padding: 0

                                                            ColumnLayout{
                                                                anchors.fill: parent
                                                                spacing: 0

                                                                Text{
                                                                    text: name
                                                                    font.pointSize: 9
                                                                    color: "#ece9f4"
                                                                    topPadding: -4
                                                                }

                                                                Text{
                                                                    text: id
                                                                    font.pointSize: 8
                                                                    color: "#ece9f4"
                                                                }

                                                                Text{
                                                                    text: epgPid
                                                                    font.pointSize: 8
                                                                    color: "#ece9f4"
                                                                }
                                                            }
                                                        }

                                                    }
                                                }

                                                Rectangle{
                                                    id: borderImmitation
                                                    width: parent.width
                                                    height: 4
                                                    color: "#15111f"
                                                    radius: 2
                                                    anchors.bottom: parent.bottom
                                                }
                                            }
                                        }
                                    }
                                }
                                ListView {
                                    id: listViewMediaElems
                                    clip: true
                                    flickableDirection: Flickable.VerticalFlick
                                    anchors.fill: parent
                                    model: ListChannels.channels
                                    delegate: mediaContentDeligate
                                    ScrollBar.vertical: ScrollBar {
                                        id: scrollMediaList
                                        active: true
                                        focus: true
                                        rightPadding: 12

                                        contentItem: Rectangle{
                                            implicitWidth: 8
                                            implicitHeight: 100
                                            radius: width / 2
                                            color: "#2a2634"
                                        }

                                        background: Rectangle{
                                            color: "transparent"
                                        }
                                    }
                                }
                            }
                        }

                        Button{
                            id: bottomListBut
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Universal.background: "#2a2634"
                            padding: 0

                            Image {
                                height: 15
                                width: 15
                                x: (parent.width - 15) / 2
                                y: (parent.height - 15) / 2
                                fillMode: Image.PreserveAspectFit
                                source: "static/caret-down.svg"

                            }

                            background: Rectangle{
                                implicitWidth: parent.width
                                implicitHeight: parent.height
                                width: parent.width
                                height: parent.height
                                color: bottomListBut.hovered? "#2f2a3c" : "#25212f"
                            }

                            MouseArea{
                                id: listDown
                                hoverEnabled: true
                                anchors.fill: bottomListBut
        //                        cursorShape: "PointingHandCursor"
                                SmoothedAnimation{
                                    target: listViewMediaElems
                                    running: listDown.pressed
                                    to: listViewMediaElems.contentHeight //- listViewMediaElems.height
                                    velocity: 1000
                                }
                                onReleased: {
                                    if (!listViewMediaElems.atYEnd)
                                        listViewMediaElems.flick(0, -1000)
                                }
                            }
                        }
                    }
                }
                Pane{
                    id: rightPane
        //            Material.elevation: 2
        //            Layout.fillWidth: true
                    Layout.preferredWidth: 255
        //            Layout.minimumWidth: 50
        //            Layout.maximumWidth: 400
                    Layout.fillHeight: true
                    padding: 0

                    ColumnLayout{
                        id: rightColumn
                        anchors.fill: parent
                        spacing: 0
                        Pane{
                            id: mediaInfoPane
                            Layout.fillWidth: true
                            Layout.preferredHeight: 475
                            Layout.fillHeight: true
                            Universal.background: "#3f3a4e"
                            padding: 0

                            ColumnLayout{
                                id: mediaAttributeColumn
                                anchors.fill: parent
                                spacing: 0

                                Pane{
                                    id: nameAttrubutePane
                                    Layout.preferredHeight: 88
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 20
                                    bottomPadding: 0
                                    leftPadding: 18
                                    rightPadding: 24

                                    ColumnLayout{
                                        id: nameAttrubuteColumn
                                        anchors.fill: parent
                                        spacing: 0

                                        Text{
                                            id: nameAttributeText
                                            text: "NAME"
                                            color: "#6b6778"
                                            font.pointSize: 9
                                        }
                                        TextField{
                                            id: nameAttributeCombobox
                                            Layout.fillWidth: true
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 10
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                        }
                                    }
                                }
                                Pane{
                                    id: channelAttributePane
                                    Layout.preferredHeight: 88
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 12
                                    bottomPadding: 8
                                    leftPadding: 18
                                    rightPadding: 24

                                    ColumnLayout{
                                        id: channelAttributeColumn
                                        anchors.fill: parent
                                        spacing: 0

                                        Text{
                                            id: channelAttributeText
                                            text: "CHANNEL"
                                            color: "#6b6778"
                                            font.pointSize: 9
                                        }
                                        ComboBox{
                                            id: channelAttriCombobox
                                            Universal.theme: Universal.Light
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 35
                                            padding: 2
                                            font.pointSize: 10
                                            model: ["France 4", "CNN", "CCTV 1"]
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }

                                            popup.background: Rectangle{
                                                color: "lightgrey"
                                            }
                                            indicator: Canvas{
                                                id: channelAttriComboboxCanvas
                                                width: 12
                                                height: 9
                                                x: channelAttriCombobox.width - width - channelAttriCombobox.rightPadding
                                                y: channelAttriCombobox.topPadding + (channelAttriCombobox.availableHeight - height) / 2
                                                contextType: "2d"

                                                Connections{
                                                    target: channelAttriCombobox
                                                    onPressedChanged: channelAttriComboboxCanvas.requestPaint()
                                                }
                                                onPaint: {
                                                    context.reset();
                                                    context.moveTo(0, 0);
                                                    context.lineTo(width, 0);
                                                    context.lineTo(width/2, height);
                                                    context.closePath();
                                                    context.fillStyle = channelAttriCombobox.pressed ? "#2f2f2f" : "#2f2f2f";
                                                    context.fill();
                                                }
                                            }
                                        }
                                    }
                                }
                                Pane{
                                    id: descriptionAttrubutePane
                                    Layout.preferredHeight: 150
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 20
                                    bottomPadding: 7
                                    leftPadding: 18
                                    rightPadding: 24

                                    ColumnLayout{
                                        id: descriptionAttrubuteColumn
                                        anchors.fill: parent
                                        spacing: 0

                                        Text{
                                            id: descriptionAttributeText
                                            text: "DESCRIPTION"
                                            color: "#6b6778"
                                            font.pointSize: 9
                                            bottomPadding: 10
                                            topPadding: -13
                                        }

                                        Pane{
                                            id: wrapDescriptionText
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            padding: 0

                                            ScrollView{
                                                id: scrollViewDescription
                                                anchors.fill: parent

                                                TextArea{
                                                    id: descriptionAttributeArea
                                                    Layout.fillWidth: true
                                                    height: wrapDescriptionText.height
                                                    wrapMode: "WrapAtWordBoundaryOrAnywhere"
                                                    color: "#333333"
                                                    padding: 15
                                                    font.pointSize: 9
                                                    background: Rectangle{
                                                        color: "#fdfdfb"
                                                        border.width: 0
                                                    }

                                                }

                                                ScrollBar.vertical: ScrollBar {
                                                    id: scrollDescriptionAttribute
                                                    parent: scrollViewDescription
                                                    x: scrollViewDescription.mirrored ? 0 : scrollViewDescription.width - width
                                                    y: scrollViewDescription.topPadding
                                                    height: descriptionAttributeArea.height <= wrapDescriptionText.height ? 0 : scrollViewDescription.availableHeight
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
                                }
                                Pane{
                                    id: datePane
                                    Layout.preferredHeight: 88
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 12
                                    bottomPadding: 0
                                    leftPadding: 18
                                    rightPadding: 24
                                    ColumnLayout{
                                        id: dateColumn
                                        anchors.fill: parent
                                        spacing: 0

                                        Text{
                                            id: dateText
                                            text: "DATE:"
                                            color: "#6b6778"
                                            font.pointSize: 9
                                        }
                                        TextField{
                                            id: dateInput
                                            Layout.fillWidth: true
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                        }
                                    }
                                }

                                Pane{
                                    id: timesPane
                                    Layout.preferredHeight: 88
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 12
                                    bottomPadding: 8
                                    leftPadding: 18
                                    rightPadding: 24
                                    RowLayout{
                                        id: timesRow
                                        anchors.fill: parent
                                        spacing: 10

                                        Pane{
                                            id: startTimePane
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: (timesPane.width - 52) / 2
                                            padding: 0

                                            ColumnLayout{
                                                id: strartTimesColumn
                                                anchors.fill: parent
                                                spacing: 0

                                                Text{
                                                    id: startTimeText
                                                    text: "START:"
                                                    color: "#6b6778"
                                                    font.pointSize: 9
                                                }
                                                TextField{
                                                    id: startTimeInput
                                                    Layout.fillWidth: true
                                                    color: "#333333"
                                                    padding: 15
                                                    font.pointSize: 9
                                                    background: Rectangle{
                                                        color: "#fdfdfb"
                                                        border.width: 0
                                                    }
                                                }
                                            }
                                        }

                                        Pane{
                                            id: endTimePane
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: (timesPane.width - 54) / 2
                                            padding: 0

                                            ColumnLayout{
                                                id: endtimesColumn
                                                anchors.fill: parent
                                                spacing: 0

                                                Text{
                                                    id: endTimeText
                                                    text: "END:"
                                                    color: "#6b6778"
                                                    font.pointSize: 9
                                                }
                                                TextField{
                                                    id: endTimeInput
                                                    Layout.fillWidth: true
                                                    color: "#333333"
                                                    padding: 15
                                                    font.pointSize: 9
                                                    background: Rectangle{
                                                        color: "#fdfdfb"
                                                        border.width: 0
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        }
                        Pane{
                            id: timesAddingPane
                            Layout.fillWidth: true
        //                    Layout.fillHeight: true
                            Layout.preferredHeight: 169
                            Universal.background: "#2b263a"
                            topPadding: 15
                            bottomPadding: 42
                            leftPadding: 18
                            rightPadding: 24

                            ColumnLayout{
                                id: timesAddingColumn
                                anchors.fill: parent
                                Universal.background: "gray"
                                spacing: 7

                                RowLayout{
                                    id: elemFirstTimesAddingRow
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Text{
                                        font.pointSize: 12
                                        color: "#6b6778"
                                        text: "1"
                                    }
                                    Rectangle{
                                        id: elemFirstLeftTimesAddingRectangle
                                        color: "transparent"
                                        width: 76
                                        Layout.preferredHeight: 32
                                        TextField{
                                            id: timesAddingTextFieldFirstStart
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            property var timePositionStart: 0
                                            text: firstStart
                                        }
                                    }
                                    Rectangle{
                                        id: elemFirstRightTimesAddingRectangle
                                        color: "transparent"
                                        width: 76
                                        Layout.preferredHeight: 32
                                        anchors.left: elemFirstLeftTimesAddingRectangle.right
                                        anchors.leftMargin: 10
                                        TextField{
                                            id: timesAddingTextFieldFirstEnd
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            property var timePositionEnd: 0
                                            text: firstEnd
                                        }
                                    }
                                    RoundButton{
                                        id: elemFirstTimesAddingBut
                                        anchors.left: elemFirstRightTimesAddingRectangle.right
                                        anchors.leftMargin: 5
                                        highlighted: true
                                        Universal.accent: "#176cbf"
                                        font.pointSize: 20
                                        topPadding: -3
                                        bottomPadding: 0
                                        Layout.preferredHeight: 32
                                        Layout.preferredWidth: 32

                                        Image {
                                            height: 13
                                            width: 13
                                            x: (parent.width - 13) / 2
                                            y: (parent.height - 13) / 2
                                            fillMode: Image.PreserveAspectFit
                                            source: "static/add-plus-button.svg"
                                        }
                                        background: Rectangle{
                                            anchors.fill: parent
                                            color: elemFirstTimesAddingButMouse.pressed? "#1b80e4" : "#176cbf"
                                            radius: parent.height / 2
                                            border.width: elemFirstTimesAddingBut.hovered? 2 : 0
                                            border.color: "#4899ea"
                                        }

                                        MouseArea{
                                            id: elemFirstTimesAddingButMouse
                                            hoverEnabled: true
                                            anchors.fill: elemFirstTimesAddingBut
                                        }
                                    }
                                }
                                RowLayout{
                                    id: elemSecondTimesAddingRow
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Text{
                                        font.pointSize: 12
                                        color: "#6b6778"
                                        text: "2"
                                    }
                                    Rectangle{
                                        id: elemSecondLeftTimesAddingRectangle
                                        color: "transparent"
                                        width: 76
                                        Layout.preferredHeight: 32
                                        TextField{
                                            id: timesAddingTextFieldSecondStart
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            property var timePositionStart: 0
                                            text: secondStart
                                        }
                                    }
                                    Rectangle{
                                        id: elemSecondRightTimesAddingRectangle
                                        color: "transparent"
                                        width: 76
                                        Layout.preferredHeight: 32
                                        anchors.left: elemSecondLeftTimesAddingRectangle.right
                                        anchors.leftMargin: 10
                                        TextField{
                                            id: timesAddingTextFieldSecondEnd
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            property var timePositionEnd: 0
                                            text: secondEnd
                                        }
                                    }
                                    RoundButton{
                                        id: elemSecondTimesAddingBut
                                        anchors.left: elemSecondRightTimesAddingRectangle.right
                                        anchors.leftMargin: 5
                                        highlighted: true
                                        Universal.accent: "#176cbf"
                                        font.pointSize: 20
                                        topPadding: -3
                                        bottomPadding: 0
                                        Layout.preferredHeight: 32
                                        Layout.preferredWidth: 32

                                        Image {
                                            height: 13
                                            width: 13
                                            x: (parent.width - 13) / 2
                                            y: (parent.height - 13) / 2
                                            fillMode: Image.PreserveAspectFit
                                            source: "static/add-plus-button.svg"
                                        }
                                        background: Rectangle{
                                            anchors.fill: parent
                                            color: elemSecondTimesAddingButMouse.pressed? "#1b80e4" : "#176cbf"
                                            radius: parent.height / 2
                                            border.width: elemSecondTimesAddingBut.hovered? 2 : 0
                                            border.color: "#4899ea"
                                        }

                                        MouseArea{
                                            id: elemSecondTimesAddingButMouse
                                            hoverEnabled: true
                                            anchors.fill: elemSecondTimesAddingBut
                                        }
                                    }
                                }
                                RowLayout{
                                    id: elemThirdTimesAddingRow
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Text{
                                        font.pointSize: 12
                                        color: "#6b6778"
                                        text: "3"
                                    }
                                    Rectangle{
                                        id: elemThirdLeftTimesAddingRectangle
                                        color: "transparent"
                                        width: 76
                                        Layout.preferredHeight: 32
                                        TextField{
                                            id: timesAddingTextFieldThirdStart
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            property var timePositionStart: 0
                                            text: thirdStart
                                        }
                                    }
                                    Rectangle{
                                        id: elemThirdRightTimesAddingRectangle
                                        color: "transparent"
                                        width: 76
                                        Layout.preferredHeight: 32
                                        anchors.left: elemThirdLeftTimesAddingRectangle.right
                                        anchors.leftMargin: 10
                                        TextField{
                                            id: timesAddingTextFieldThirdEnd
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            property var timePositionEnd: 0
                                            text: thirdEnd
                                        }
                                    }
                                    RoundButton{
                                        id: elemThirdTimesAddingBut
                                        anchors.left: elemThirdRightTimesAddingRectangle.right
                                        anchors.leftMargin: 5
                                        highlighted: true
                                        Universal.accent: "#176cbf"
                                        font.pointSize: 20
                                        Layout.preferredHeight: 32
                                        Layout.preferredWidth: 32

                                        Image {
                                            height: 13
                                            width: 13
                                            x: (parent.width - 13) / 2
                                            y: (parent.height - 13) / 2
                                            fillMode: Image.PreserveAspectFit
                                            source: "static/add-plus-button.svg"
                                        }
                                        background: Rectangle{
                                            anchors.fill: parent
                                            color: elemThirdTimesAddingButMouse.pressed? "#1b80e4" : "#176cbf"
                                            radius: parent.height / 2
                                            border.width: elemThirdTimesAddingBut.hovered? 2 : 0
                                            border.color: "#4899ea"
                                        }

                                        MouseArea{
                                            id: elemThirdTimesAddingButMouse
                                            hoverEnabled: true
                                            anchors.fill: elemThirdTimesAddingBut
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
