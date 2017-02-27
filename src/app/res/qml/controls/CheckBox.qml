import QtQuick 2.0

Rectangle {
    property bool selected
    property alias text: _label.text
    property int margin: _label.text !== "" ? units.gu(2) : 0

    height: _label.height
    color: theme.background
    width: _label.width + _dotRect.width + _label.anchors.leftMargin

    Frame {
        id: _dotRect
        width: height
        height: units.gu(2)
        radius: units.gu(0.25)
        color: theme.background
        border.color: _mouseArea.containsMouse ? theme.secondary : theme.borderColor

        Behavior on border.color {ColorAnimation{}}

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }

        Icon {
            name: "check"
            color: theme.secondary
            anchors.centerIn: parent
            opacity: selected ? 1 : 0
            iconSize: parent.height * 1.25
            anchors.verticalCenterOffset: -units.gu(0.25)
            anchors.horizontalCenterOffset: units.gu(0.25)
        }

        MouseArea {
            id: _mouseArea
            anchors.fill: parent
            onClicked: selected = !selected
            hoverEnabled: !app.mobileDevice
        }
    }

    Label {
        id: _label

        anchors {
            verticalCenter: parent.verticalCenter
            left: _dotRect.right
            leftMargin: units.gu(0.8)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: selected = !selected
        }
    }
}
