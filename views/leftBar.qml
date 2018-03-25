import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Universal 2.2
import QtQml 2.5
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0

Pane{
    Universal.background: "black"
    id: leftPane
    Layout.preferredWidth: 255
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
                            onTextChanged: {
                                ListEpg.search(searchInput.text)
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
//                      CUSTOM COMBOBOX
                        Pane{
                            id: customComboboxPaneChannel
//                            Layout.preferredHeight: 50
                            Layout.fillWidth: true
                            Layout.preferredHeight: 35
                            property var selectedItem: 0
                            padding: 0

                            Rectangle{
                                id: customComboboxButtonChannel
                                width: parent.width
                                height: parent.height
                                color: "#1b1725"

                                Text{
                                    text: listViewPopupChannel.model[customComboboxPaneChannel.selectedItem].name
                                    y: (parent.height -17) / 2
                                    color: "white"
                                    x: 15
                                }

                                Rectangle{
                                    id: custmComboboxImageRecChannel
                                    width: 12
                                    height: 9
                                    x: parent.width - 20
                                    y: (parent.height - 9) / 2
                                    color: "#1b1725"

                                    Canvas{
                                        id: custmComboboxImageRecCanvasChannel
                                        width: 12
                                        height: 9
                                        contextType: "2d"

//                                        Connections{
//                                            target: custmComboboxImageRecCanvasChannel
//                                            onPressedChanged: custmComboboxImageRecCanvasChannel.requestPaint()
//                                        }
                                        onPaint: {
                                            context.reset();
                                            context.moveTo(0, 0);
                                            context.lineTo(width, 0);
                                            context.lineTo(width/2, height);
                                            context.closePath();
                                            context.fillStyle = custmComboboxImageRecCanvasChannel.pressed ? "#a69fbc" : "#a69fbc";
                                            context.fill();
                                        }
                                     }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: customComboboxPopupChannel.open()
                                }
                            }
                            Popup {
                                id: customComboboxPopupChannel
                                x: 0
                                y: 0
                                width: customComboboxButtonChannel.width
                                height: (customComboboxButtonChannel.height + 5) * listViewPopupChannel.model.length
                                padding: 0
                                modal: false
                                focus: true
                                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent | Popup.CloseOnReleaseOutside

                                Pane{
                                    id: customComboboxPopupPaneChannel
                                    anchors.fill: parent
                                    padding: 0
                                    Universal.background: "#2b263a"
                                    Universal.theme: Universal.Light

                                    Component {
                                        id: customComboboxPopupContentDeligateChannel

                                        Pane{
                                            id: customComboboxPopupPaneChannel
                                            height: 40
                                            width: parent.width
                                            padding: 0
                                            Universal.background: {
                                                if (hovered && index != customComboboxPaneChannel.selectedItem){
                                                    "#39324d"
                                                } else if (index == customComboboxPaneChannel.selectedItem) {
                                                    "#918aa8"
                                                } else {
                                                    "transparent"
                                                }
                                            }

                                            Text{
                                                text: name
                                                y: (parent.height -15) / 2
                                                color: "white"
                                                x: 15
                                            }

                                            MouseArea{
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                onClicked: {
                                                    customComboboxPaneChannel.selectedItem = index
                                                    ListEpg.chooseChannel(listViewPopupChannel.model[index].address)
                                                    customComboboxPopupChannel.close()
                                                }
                                            }
                                        }
                                    }
                                }
                                ListView {
                                    id: listViewPopupChannel
                                    clip: true
                                    flickableDirection: Flickable.VerticalFlick
                                    anchors.fill: parent
                                    model: ListChannels.channels
                                    delegate: customComboboxPopupContentDeligateChannel
                                    ScrollBar.vertical: ScrollBar {
                                        id: scrollMediaListChannel
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
            }
        }
        Pane{
            id: wraplistMediaPane
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 438
            Universal.background: "#1b1725"
            padding: 0

            property var choosedIndex;
            property var focusState: FocusState.focusState;

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
                            padding: 0

                            Pane{
                                id: itemMediaHoveredPane
                                width: parent.width
                                height: 66
                                leftPadding: 18
                                rightPadding: 40
                                topPadding: 10
                                bottomPadding: 0
                                anchors.top: parent.top
                                Universal.background: colorItemMediaPane()

                                function colorItemMediaPane(){
                                    if (listElemMouse.pressed){
                                        return "#39314e"
                                    }else if (listElemMouse.containsMouse){
                                        return "#2e273f"
                                    } else if (wraplistMediaPane.choosedIndex == index && wraplistMediaPane.focusState == 0) {
                                        return "#39314e"
                                    } else {
                                        return "#1b1725"
                                    }
                                }

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
                                                    source: image
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
                                                        text: {
                                                            if (title.length > 23) {
                                                                return title.substring(0, 23) + "..."
                                                            } else {
                                                                return title
                                                            }
                                                        }
                                                        font.pointSize: 9
                                                        color: "#ece9f4"
                                                        topPadding: -4
                                                    }

                                                    Text{
                                                        text: date
                                                        font.pointSize: 8
                                                        color: "#ece9f4"
                                                    }

                                                    Text{
                                                        text: startTime + "-" + endTime
                                                        font.pointSize: 8
                                                        color: "#ece9f4"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                }
                            Pane{
                                id: itemMediaBorderPane
                                width: parent.width
                                leftPadding: 18
                                rightPadding: 40
                                topPadding: 0
                                bottomPadding: 0

                                Rectangle{
                                    id: borderImmitation
                                    width: parent.width
                                    height: 4
                                    color: "#15111f"
                                    radius: 2
                                    anchors.bottom: parent.bottom
                                }
                            }
                            MouseArea{
                                id: listElemMouse
                                hoverEnabled: true
                                anchors.fill: parent
                                onClicked: {
                                    wraplistMediaPane.choosedIndex = index
                                    PlayerControls.chooseEPG(startTime, endTime, date, recorder, id, title, index)
                                    ListChannels.chooseChannel(customComboboxPaneChannel.selectedItem)
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
                    model: ListEpg.epg_list
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
