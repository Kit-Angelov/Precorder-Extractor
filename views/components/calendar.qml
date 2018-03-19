import QtQuick 2.9
import QtQuick.Controls 1.4

Rectangle {
    id: root
    color: "transparent"

    property date dt: calendar.selectedDate

    Calendar {
        id : calendar

        width : rect.width

        //navigationBarVisible : false
        //frameVisible: false

        weekNumbersVisible: false

        anchors.fill: parent

        anchors {
            left: parent.left;
            right: parent.right;
        }
    }
}
