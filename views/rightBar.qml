import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import QtQml 2.5
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0
import Qt.labs.calendar 1.0
import QtQuick.Controls 1.4 as OldControls

Pane{
                    id: rightPane
        //            Material.elevation: 2
        //            Layout.fillWidth: true
                    Layout.preferredWidth: 255
        //            Layout.minimumWidth: 50
        //            Layout.maximumWidth: 400
                    Layout.fillHeight: true
                    Universal.background: "black"
                    padding: 0
                    property var handleCheck: false

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

                                        RowLayout{
                                            id: middleVideoTopControlRow
                                            anchors.fill: parent
                                            spacing: 0

                                            Text{
                                                id: nameAttributeText
                                                text: "NAME"
                                                color: "#6b6778"
                                                font.pointSize: 9
                                            }

                                            RoundButton{
                                                id: logsBut
                                                Layout.preferredHeight: 20
                                                Layout.preferredWidth: 40
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.rightMargin: 0
                                                anchors.topMargin: -10
                                                highlighted: true
                                                Universal.accent: "#2e2a39"
                                                font.pointSize: 24

                                                Text{
                                                    text: "Logs"
                                                    color: "gray"
                                                    y: (parent.height -15) / 2
                                                    x:9
                                                }

                                                background: Rectangle{
                                                    anchors.fill: parent
                                                    color: logsButMouse.pressed? "#3b3649" : "#2e2a39"
                                                    border.width: logsBut.hovered? 2 : 0
                                                    border.color: "#534c67"
                                                }

                                                MouseArea{
                                                    id: logsButMouse
                                                    hoverEnabled: true
                                                    anchors.fill: logsBut
                                                    onClicked: {
                                                        logsPopup.open()
                                                    }
                                                }
                                            }

                                            Popup {
                                                id: logsPopup
                                                x: -15
                                                y: -17
                                                width: rightPane.width - 3
                                                height: rightPane.height - 3
                                                padding: 0
                                                modal: false
                                                focus: true
                                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnReleaseOutside

                                                Pane{
                                                    id: logsPane
                                                    anchors.fill: parent
                                                    padding: 0
                                                    Universal.background: "#cccccc"
                                                    Universal.theme: Universal.Light

                                                    ColumnLayout{
                                                        id: logsColumn
                                                        anchors.fill: parent
                                                        spacing: 0

                                                        RoundButton{
                                                            id: logsCloseBut
                                                            Layout.preferredHeight: 20
                                                            Layout.preferredWidth: 40
                                                            anchors.right: parent.right
                                                            anchors.top: parent.top
                                                            anchors.rightMargin: 5
                                                            anchors.topMargin: 5
                                                            highlighted: true
                                                            Universal.accent: "#2e2a39"
                                                            font.pointSize: 24

                                                            Text{
                                                                text: "Close"
                                                                color: "gray"
                                                                y: (parent.height -15) / 2
                                                                x:6
                                                            }

                                                            background: Rectangle{
                                                                anchors.fill: parent
                                                                color: logsCloseButMouse.pressed? "#3b3649" : "#2e2a39"
                                                                border.width: logsCloseBut.hovered? 2 : 0
                                                                border.color: "#534c67"
                                                            }

                                                            MouseArea{
                                                                id: logsCloseButMouse
                                                                hoverEnabled: true
                                                                anchors.fill: logsCloseBut
                                                                onClicked: {
                                                                    logsPopup.close()
                                                                }
                                                            }
                                                        }

                                                        Pane{
                                                            id: logsTextPane
                                                            Layout.fillWidth: true
                                                            Layout.fillHeight: true
                                                            padding: 0
                                                            Universal.background: "transparent"

                                                            ScrollView{
                                                                id: scrollViewLogs
                                                                anchors.fill: parent

                                                                TextArea{
                                                                    id: logsArea
                                                                    Layout.fillWidth: true
                                                                    height: logsTextPane.height
                                                                    wrapMode: "WrapAtWordBoundaryOrAnywhere"
                                                                    color: "#333333"
                                                                    padding: 15
                                                                    font.pointSize: 9
                                                                    background: Rectangle{
                                                                        color: "transparent"
                                                                        border.width: 0
                                                                    }
                                                                    text: Logs.logs
                                                                }

                                                                ScrollBar.vertical: ScrollBar {
                                                                    id: scrollLogsAttribute
                                                                    parent: scrollViewLogs
                                                                    x: scrollViewLogs.mirrored ? 0 : scrollViewLogs.width - width
                                                                    y: scrollViewLogs.topPadding
                                                                    height: logsArea.height <= logsTextPane.height ? 0 : scrollViewLogs.availableHeight
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
                                            }
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
                                            text: SelectedEPG.epgTitle
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
//                                        CUSTOM COMBOBOX
                                        Pane{
                                            id: customComboboxPane
//                                            Layout.preferredHeight: 50
//                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 35
                                            property var selectedItem: 0
                                            padding: 0

                                            Rectangle{
                                                id: customComboboxButton
                                                width: parent.width
                                                height: parent.height
                                                Universal.background: "#fdfdfb"

                                                Text{
                                                    text: listViewPopup.model[customComboboxPane.selectedItem].name
                                                    y: (parent.height -15) / 2
                                                    color: "black"
                                                    x: 15
                                                }

                                                Rectangle{
                                                    id: custmComboboxImageRec
                                                    width: 12
                                                    height: 9
                                                    x: parent.width - 20
                                                    y: (parent.height - 9) / 2

                                                    Canvas{
                                                        id: custmComboboxImageRecCanvas
                                                        width: 12
                                                        height: 9
                                                        contextType: "2d"

//                                                        Connections{
//                                                            target: custmComboboxImageRecCanvas
//                                                            onPressedChanged: custmComboboxImageRecCanvas.requestPaint()
//                                                        }
                                                        onPaint: {
                                                            context.reset();
                                                            context.moveTo(0, 0);
                                                            context.lineTo(width, 0);
                                                            context.lineTo(width/2, height);
                                                            context.closePath();
                                                            context.fillStyle = custmComboboxImageRecCanvas.pressed ? "#2f2f2f" : "#2f2f2f";
                                                            context.fill();
                                                        }
                                                     }
                                                }

                                                MouseArea{
                                                    anchors.fill: parent
                                                    onClicked: customComboboxPopup.open()
                                                }
                                            }
                                            Popup {
                                                id: customComboboxPopup
                                                x: 0
                                                y: 0
                                                width: customComboboxButton.width
                                                height: (customComboboxButton.height + 5) * listViewPopup.model.length
                                                padding: 0
                                                modal: false
                                                focus: true
                                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnReleaseOutside

                                                Pane{
                                                    id: customComboboxPopupPane
                                                    anchors.fill: parent
                                                    padding: 0
                                                    Universal.background: "#e6e6e6"
                                                    Universal.theme: Universal.Light

                                                    Component {
                                                        id: customComboboxPopupContentDeligate

                                                        Pane{
                                                            id: customComboboxPopupPane
                                                            height: 40
                                                            width: parent.width
                                                            padding: 0
                                                            Universal.background: {
                                                                if (hovered && index != customComboboxPane.selectedItem){
                                                                    "lightgrey"
                                                                } else if (index == customComboboxPane.selectedItem) {
                                                                    "#918aa8"
                                                                } else {
                                                                    "transparent"
                                                                }
                                                            }

                                                            Text{
                                                                text: name
                                                                y: (parent.height -15) / 2
                                                                color: "black"
                                                                x: 15
                                                            }

                                                            MouseArea{
                                                                anchors.fill: parent
                                                                hoverEnabled: true
                                                                onClicked: {
                                                                    customComboboxPane.selectedItem = index
                                                                    customComboboxPopup.close()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                ListView {
                                                    id: listViewPopup
                                                    clip: true
                                                    flickableDirection: Flickable.VerticalFlick
                                                    anchors.fill: parent
                                                    model: ListChannels.channels
                                                    delegate: customComboboxPopupContentDeligate
                                                    ScrollBar.vertical: ScrollBar {
                                                        id: scrollMediaList
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
                                            Universal.background: "#fdfdfb"

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
                                                        color: "transparent"
                                                        border.width: 0
                                                    }
                                                    text: SelectedEPG.epgDesk

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
                                        RowLayout{
                                            id: datePaneRow
                                            spacing: 0

                                            TextField{
                                                id: dateInput
                                                Layout.fillWidth: true
                                                inputMask: "00.00.0000"
                                                color: "#333333"
                                                padding: 15
                                                font.pointSize: 10
                                                background: Rectangle{
                                                    color: "#fdfdfb"
                                                    border.width: 0
                                                }
                                                property var handleCheck: false
                                                text: calendar.dateEPG
                                                onTextChanged: {
                                                    if (endTimeInput.text.length == 8 && startTimeInput.text.length == 8 && dateInput.text.length == 10) {
                                                        rightPane.handleCheck = true
                                                        } else {
                                                                rightPane.handleCheck = false
                                                        }
                                                }
                                            }
                                            RoundButton{
                                                id: calendarBut
                                                Layout.preferredHeight: dateInput.height
                                                Layout.preferredWidth: dateInput.height
                                                highlighted: true

                                                background: Rectangle{
                                                    anchors.fill: parent
                                                    color: calendarBut.hovered? "#d6d1e0" : "#fdfdfb"
                                                }

                                                Image {
                                                    height: 20
                                                    width: 20
                                                    x: (parent.width - 20) / 2
                                                    y: (parent.height - 20) / 2
                                                    fillMode: Image.PreserveAspectFit
                                                    source: "static/calendar.svg"
                                                }
                                                MouseArea{
                                                    id: calendarRectMouse
                                                    hoverEnabled: true
                                                    anchors.fill: calendarBut
                                                    onClicked: {
                                                        popupCalendar.open()
                                                    }
                                                }
                                            }

                                            Popup {
                                                id: popupCalendar
                                                x: 0
                                                y: 0
                                                width: datePane.width - datePane.leftPadding - datePane.rightPadding
                                                height: datePane.width
                                                padding: 0
                                                modal: false
                                                focus: true
                                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnReleaseOutside

                                                Pane{
                                                    id: calendarPane
                                                    anchors.fill: parent
                                                    padding: 0
                                                    Universal.background: "#fbfbfb"
                                                    Universal.theme: Universal.Light

                                                    OldControls.Calendar{
                                                        id: calendar
                                                        anchors.fill: parent
                                                        property var curDate: SelectedEPG.epgDate
                                                        property var dateEPG: curDate
                                                        onClicked: {
                                                            popupCalendar.close()
                                                            curDate = Qt.formatDate(selectedDate, "dd.MM.yyyy")
                                                        }
                                                    }
                                                }
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
                                                    inputMask: "00:00:00"
                                                    color: "#333333"
                                                    padding: 15
                                                    font.pointSize: 10
                                                    background: Rectangle{
                                                        color: "#fdfdfb"
                                                        border.width: 0
                                                    }
                                                    property var handleCheck: false
                                                    text: SelectedEPG.epgStartTime
                                                    onTextChanged: {
                                                        if (endTimeInput.text.length == 8 && startTimeInput.text.length == 8 && dateInput.text.length == 10) {
                                                            rightPane.handleCheck = true
                                                            } else {
                                                            rightPane.handleCheck = false
                                                            }
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
                                                    inputMask: "00:00:00"
                                                    color: "#333333"
                                                    padding: 15
                                                    font.pointSize: 10
                                                    background: Rectangle{
                                                        color: "#fdfdfb"
                                                        border.width: 0
                                                    }
                                                    text: SelectedEPG.epgEndTime
                                                    onTextChanged: {
                                                        if (endTimeInput.text.length == 8 && startTimeInput.text.length == 8 && dateInput.text.length == 10) {
                                                            rightPane.handleCheck = true
                                                        } else {
                                                            rightPane.handleCheck = false
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                Pane{
                                    id: selectCustomEPGPane
                                    Layout.preferredHeight: 38
                                    Layout.fillWidth: true
                                    padding: 0
                                    topPadding: 0
                                    bottomPadding: 8
                                    leftPadding: 70
                                    rightPadding: 70

                                    Button{
                                        id: selectCustomEPGBut
                                        width: parent.width
                                        height: 30
                                        anchors.left: parent.left

                                        Text{
                                            text: "Apply"
                                            y: (parent.height - 15) / 2
                                            color: "white"
                                            x: parent.width / 2 - (width / 2)
                                        }

                                        background: Rectangle{
                                            implicitWidth: parent.width
                                            implicitHeight: parent.height
                                            color: {
                                                if (rightPane.handleCheck){
                                                    playButMouse.pressed? "#1b80e4" : "#176cbf"
                                                } else {
                                                    "gray"
                                                }
                                            }
                                            radius: parent.height / 2
                                            border.width: {
                                                if (rightPane.handleCheck){
                                                    selectCustomEPGBut.hovered? 2 : 0
                                                } else {
                                                    0
                                                }
                                            }
                                            border.color: "#4899ea"
                                        }

                                        MouseArea{
                                            id: playButMouse
                                            hoverEnabled: true
                                            anchors.fill: selectCustomEPGBut
                                            onClicked: {
                                                if (rightPane.handleCheck){
                                                         CustomEpgControls.dateTimeEdit(dateInput.text, startTimeInput.text, endTimeInput.text, listViewPopup.model[customComboboxPane.selectedItem].address)
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
                            bottomPadding: 32
                            leftPadding: 18
                            rightPadding: 24


                            Component {
                                id: timesAddingDeligate

                                RowLayout{
                                    id: elemTimesAddingRow
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Text{
                                        font.pointSize: 12
                                        color: "#6b6778"
                                        text: index + 1
                                    }
                                    Rectangle{
                                        id: elemLeftTimesAddingRectangle
                                        color: "transparent"
                                        width: 72
                                        Layout.preferredHeight: 32
                                        TextField{
                                            id: timesAddingTextFieldStart
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            text: startTime
                                        }
                                    }
                                    Rectangle{
                                        id: elemRightTimesAddingRectangle
                                        color: "transparent"
                                        width: 72
                                        Layout.preferredHeight: 32
                                        anchors.left: elemLeftTimesAddingRectangle.right
                                        anchors.leftMargin: 10
                                        TextField{
                                            id: timesAddingTextFieldEnd
                                            width: parent.width
                                            color: "#333333"
                                            padding: 15
                                            font.pointSize: 9
                                            background: Rectangle{
                                                color: "#fdfdfb"
                                                border.width: 0
                                            }
                                            text: endTime
                                        }
                                    }
                                    RoundButton{
                                        id: elemTimesAddingBut
                                        anchors.left: elemRightTimesAddingRectangle.right
                                        anchors.leftMargin: 5
                                        highlighted: true
                                        Universal.accent: "gray"
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
                                            source: stateDL == 1 ? "static/add-plus-button.svg" : "static/cancel.svg"
                                        }
                                        background: Rectangle{
                                            anchors.fill: parent
                                            color: {
                                                if (stateDL == 2){
                                                    "#1b80e4"
                                                } else if(stateDL == 1){
                                                    "gray"
                                                } else if(stateDL == 0 && elemTimesAddingButMouse.pressed) {
                                                    "#666666"
                                                } else {
                                                    "gray"
                                                }
                                            }
                                            radius: parent.height / 2
                                            border.width: {
                                                if (stateDL == 0 && elemTimesAddingBut.hovered){
                                                    2
                                                } else {
                                                    0
                                                }
                                            }
                                            border.color: "#666666"
                                        }

                                        MouseArea{
                                            id: elemTimesAddingButMouse
                                            hoverEnabled: true
                                            anchors.fill: elemTimesAddingBut
                                            onClicked:{
                                                if (stateDL == 0 || stateDL == 2){
                                                    PlayerControls.deleteTimeSegment(index)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            ListView {
                                id: listViewTimesAdding
                                clip: true
                                flickableDirection: Flickable.VerticalFlick
                                anchors.fill: parent
                                model: ListSegmentPostiton.segment_list
                                delegate: timesAddingDeligate
                                spacing: 7
                                ScrollBar.vertical: ScrollBar {
                                    id: scrollMediaListTimesAdding
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
                }

