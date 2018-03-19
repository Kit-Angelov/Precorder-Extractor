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
    id: middlePane
   // anchors.left: leftPane.right
    //anchors.right: rightPane.left
//            Material.elevation: 5
    Layout.fillWidth: true
    Layout.preferredWidth: 770
//            Layout.minimumWidth: 100
//            Layout.maximumWidth: 800
    Layout.fillHeight: true
    Universal.background: "black"
    padding: 0

    ColumnLayout{
        id: middleColumn
        anchors.fill: parent
        spacing: 0

        Pane{
            id: videoSliderPane
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            padding: 0
            leftPadding: 10
            rightPadding: 10
            Universal.background: "black"

            Slider{
                id: videoSlider
                anchors.fill: parent
                from: 0
                to: 1000
                stepSize: 1
                value: VideoSlider.sliderValue

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
                    VideoSlider.changePosition(videoSlider.value)
                }
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

//                      CUSTOM COMBOBOX
                        Pane{
                            id: customComboboxPaneMin
//                            Layout.preferredHeight: 50
//                            Layout.fillHeight: true
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 35
                            property var selectedItem: 0
                            padding: 0

                            Rectangle{
                                id: customComboboxButtonMin
                                width: parent.width
                                height: parent.height
                                Universal.background: "#fdfdfb"

                                Text{
                                    text: listViewPopupMin.model.get(customComboboxPaneMin.selectedItem).key
                                    y: (parent.height -17) / 2
                                    color: "black"
                                    x: 10
                                }

                                Rectangle{
                                    id: custmComboboxImageRecMin
                                    width: 12
                                    height: 9
                                    x: parent.width - 20
                                    y: (parent.height - 9) / 2

                                    Canvas{
                                        id: custmComboboxImageRecCanvasMin
                                        width: 12
                                        height: 9
                                        contextType: "2d"

//                                        Connections{
//                                            target: custmComboboxImageRecCanvasMin
//                                            onPressedChanged: custmComboboxImageRecCanvasMin.requestPaint()
//                                        }
                                        onPaint: {
                                            context.reset();
                                            context.moveTo(0, 0);
                                            context.lineTo(width, 0);
                                            context.lineTo(width/2, height);
                                            context.closePath();
                                            context.fillStyle = custmComboboxImageRecCanvasMin.pressed ? "#2f2f2f" : "#2f2f2f";
                                            context.fill();
                                        }
                                     }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: customComboboxPopupMin.open()
                                }
                            }
                            Popup {
                                id: customComboboxPopupMin
                                x: 0
                                y: 0
                                width: customComboboxButtonMin.width
                                height: customComboboxButtonMin.height * 3
                                padding: 0
                                modal: false
                                focus: true
                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnReleaseOutside

                                Pane{
                                    id: customComboboxPopupPaneMin
                                    anchors.fill: parent
                                    padding: 0
                                    Universal.background: "#fbfbfb"
                                    Universal.theme: Universal.Light

                                    Component {
                                        id: customComboboxPopupContentDeligateMin

                                        Pane{
                                            id: customComboboxPopupPaneMi
                                            height: 35
                                            width: parent.width
                                            padding: 0
                                            Universal.background: {
                                                if (hovered && index != customComboboxPaneMin.selectedItem){
                                                    "lightgrey"
                                                } else if (index == customComboboxPaneMin.selectedItem) {
                                                    "#918aa8"
                                                } else {
                                                    "transparent"
                                                }
                                            }

                                            Text{
                                                text: key
                                                y: (parent.height -15) / 2
                                                color: "black"
                                                x: 15
                                            }

                                            MouseArea{
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                onClicked: {
                                                    customComboboxPaneMin.selectedItem = index
                                                    customComboboxPopupMin.close()
                                                }
                                            }
                                        }
                                    }
                                }
                                ListView {
                                    id: listViewPopupMin
                                    clip: true
                                    flickableDirection: Flickable.VerticalFlick
                                    anchors.fill: parent
                                    model: ListModel {
                                        ListElement {key: "1 Min"; value: 60000}
                                        ListElement {key: "5 Min"; value: 300000}
                                        ListElement {key: "15 Min"; value: 900000}
                                    }
                                    delegate: customComboboxPopupContentDeligateMin
                                    ScrollBar.vertical: ScrollBar {
                                        id: scrollMediaListMin
                                        active: true
                                        focus: true
                                        visible: false
        //                                rightPadding: 12

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

                        RoundButton{
                            id: leftVideoTopControlArrowLeftBut
                            Layout.preferredHeight: 42
                            Layout.preferredWidth: 42
                            anchors.left: customComboboxPaneMin.right
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
                                    PlayerControls.leftMinSeek(listViewPopupMin.model.get(customComboboxPaneMin.selectedItem).value)
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
                                    PlayerControls.rightMinSeek(listViewPopupMin.model.get(customComboboxPaneMin.selectedItem).value)
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

//                      CUSTOM COMBOBOX
                        Pane{
                            id: customComboboxPaneSec
//                            Layout.preferredHeight: 50
//                            Layout.fillHeight: true
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 35
                            property var selectedItem: 0
                            padding: 0

                            Rectangle{
                                id: customComboboxButtonSec
                                width: parent.width
                                height: parent.height
                                Universal.background: "#fdfdfb"

                                Text{
                                    text: listViewPopupSec.model.get(customComboboxPaneSec.selectedItem).key
                                    y: (parent.height -17) / 2
                                    color: "black"
                                    x: 10
                                }

                                Rectangle{
                                    id: custmComboboxImageRecSec
                                    width: 12
                                    height: 9
                                    x: parent.width - 20
                                    y: (parent.height - 9) / 2

                                    Canvas{
                                        id: custmComboboxImageRecCanvasSec
                                        width: 12
                                        height: 9
                                        contextType: "2d"

//                                        Connections{
//                                            target: custmComboboxImageRecCanvasSec
//                                            onPressedChanged: custmComboboxImageRecCanvasSec.requestPaint()
//                                        }
                                        onPaint: {
                                            context.reset();
                                            context.moveTo(0, 0);
                                            context.lineTo(width, 0);
                                            context.lineTo(width/2, height);
                                            context.closePath();
                                            context.fillStyle = custmComboboxImageRecCanvasSec.pressed ? "#2f2f2f" : "#2f2f2f";
                                            context.fill();
                                        }
                                     }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: customComboboxPopupSec.open()
                                }
                            }
                            Popup {
                                id: customComboboxPopupSec
                                x: 0
                                y: 0
                                width: customComboboxButtonSec.width
                                height: customComboboxButtonSec.height * 3
                                padding: 0
                                modal: false
                                focus: true
                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnReleaseOutside

                                Pane{
                                    id: customComboboxPopupPaneSec
                                    anchors.fill: parent
                                    padding: 0
                                    Universal.background: "#fbfbfb"
                                    Universal.theme: Universal.Light

                                    Component {
                                        id: customComboboxPopupContentDeligateSec

                                        Pane{
                                            id: customComboboxPopupPaneSec
                                            height: 35
                                            width: parent.width
                                            padding: 0
                                            Universal.background: {
                                                if (hovered && index != customComboboxPaneSec.selectedItem){
                                                    "lightgrey"
                                                } else if (index == customComboboxPaneSec.selectedItem) {
                                                    "#918aa8"
                                                } else {
                                                    "transparent"
                                                }
                                            }

                                            Text{
                                                text: key
                                                y: (parent.height -15) / 2
                                                color: "black"
                                                x: 15
                                            }

                                            MouseArea{
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                onClicked: {
                                                    customComboboxPaneSec.selectedItem = index
                                                    customComboboxPopupSec.close()
                                                }
                                            }
                                        }
                                    }
                                }
                                ListView {
                                    id: listViewPopupSec
                                    clip: true
                                    flickableDirection: Flickable.VerticalFlick
                                    anchors.fill: parent
                                    model: ListModel {
                                        ListElement {key: "5 Sec"; value: 5000}
                                        ListElement {key: "15 Sec"; value: 15000}
                                        ListElement {key: "30 Sec"; value: 30000}
                                    }
                                    delegate: customComboboxPopupContentDeligateSec
                                    ScrollBar.vertical: ScrollBar {
                                        id: scrollMediaListSec
                                        active: true
                                        focus: true
                                        visible: false
        //                                rightPadding: 12

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

                        RoundButton{
                            id: middleVideoTopControlArrowLeftBut
                            Layout.preferredHeight: 42
                            Layout.preferredWidth: 42
                            anchors.left: customComboboxPaneSec.right
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
                                    PlayerControls.leftSecSeek(listViewPopupSec.model.get(customComboboxPaneSec.selectedItem).value)
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
                                    PlayerControls.rightSecSeek(listViewPopupSec.model.get(customComboboxPaneSec.selectedItem).value)
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
                                color: VideoControls.pauseState === 1 ? "#6b6284" : "#2e2a39"
//                                {
//                                    if (rightLeftVideoTopControlPauseButMouse.pressed ||  (middlePane.videoPauseState && middlePane.videoState)) {
//                                        "#3b3649"
//                                    } else {
//                                        "#2e2a39"
//                                    }
//                                }
                                radius: parent.height / 2
                                border.width: rightLeftVideoTopControlPauseBut.hovered? 2 : 0
                                border.color: "#534c67"
                            }

                            MouseArea{
                                id: rightLeftVideoTopControlPauseButMouse
                                hoverEnabled: true
                                anchors.fill: rightLeftVideoTopControlPauseBut
                                onClicked: VideoControls.pauseVideo()
                            }
                        }

                        Text{
                            id: videoTimer
                            anchors.left: rightLeftVideoTopControlPauseBut.right
                            anchors.leftMargin: 10
                            text: VideoTimer.timerValue
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
                            Universal.theme: Universal.Dark
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
                                    PlayerControls.getStartTimeSegment()
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
                            Universal.theme: Universal.Dark
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
                                    PlayerControls.getEndTimeSegment()
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
                        text: VideoControls.startStopState === 1 ? "STOP" : "PLAY"
                        //text: "PLAY"
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
                        source: VideoControls.startStopState === 1 ? "static/stop.svg" : "static/play-button.svg"
                    }

                    background: Rectangle{
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        color: {
                            if (FocusState.mediaSetState == 1) {
                                playButMouse.pressed? "#1b80e4" : "#176cbf"
                            } else {
                                "gray"
                            }
                        }
                        radius: parent.height / 2
                        border.width: {
                            if (FocusState.mediaSetState == 1) {
                                playBut.hovered? 2 : 0
                            } else {
                                0
                            }
                        }
                        border.color: "#4899ea"
                    }

                    MouseArea{
                        id: playButMouse
                        hoverEnabled: true
                        anchors.fill: playBut
                        onClicked: {
                            if (FocusState.mediaSetState == 1) {
                                VideoControls.playStopVideo()
                            }
                        }
                    }
                }

                Text{
                    id: labelStatus
                    width: 130
                    height: 45
                    anchors.left: playBut.right
                    anchors.leftMargin: 15
                    color: "gray"
                    text: Status.statusText
                }

                Button{
                    id: extractBut
                    width: 133
                    height: 45
                    anchors.right: storeBut.left
                    anchors.rightMargin: 15

                    Text{
                        text: {
                            if (PlayerControls.extractingState == 1){
                                "EXTRACTING..."
                            } else {
                                "EXTRACT"
                            }
                        }
                        y: (parent.height -15) / 2
                        color: "white"
                        x: {
                            if (PlayerControls.extractingState == 1){
                                40
                            } else {
                                50
                            }
                        }
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
                        color: {
                            if (PlayerControls.extractingState == 1){
                                "gray"
                            } else {
                                if (extractButMouse.pressed){
                                    "#3b3649"
                                } else {
                                    "#2e2a39"
                                }
                            }
                        }
                        radius: parent.height / 2
                        border.width: {
                            if (PlayerControls.extractingState == 0 && extractBut.hovered){
                                2
                            } else{
                                0
                            }
                        }
                        border.color: "#534c67"
                    }

                    MouseArea{
                        id: extractButMouse
                        hoverEnabled: true
                        anchors.fill: extractBut
                        onClicked: {
                            if (PlayerControls.extractingState == 0) {
                                 PlayerControls.extract()
                                 labelExtracting.text = "Extracting..."
                                 timerExtracting.start()
                            }
                        }
                    }

                    Timer {
                        id: timerExtracting
                        interval: 10000;
                        running: false
                        repeat: false
                        onTriggered: {
                            labelExtracting.text = "Extracting... ok"
                            timerExtractingOK.start()
                        }
                    }
                    Timer {
                        id: timerExtractingOK
                        interval: 2000;
                        running: false
                        repeat: false
                        onTriggered: {
                            opacityAnimationText.start()
                        }

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
