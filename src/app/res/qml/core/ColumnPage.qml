import "../controls"
import QtQuick 2.0
import QtGraphicalEffects 1.0

Page {
    property string iconName
    property alias source: _image.source
    property alias caption: _caption.text
    property alias subtitle: _subtitle.text
    default property alias contents: _contents.data

    function canShowRectangle() {
        return !(app.width < 1.25 * _bg.width)
    }

    RectangularGlow {
        opacity: 0.2
        width: _bg.width
        height: _bg.height
        anchors.centerIn: _bg
        color: theme.borderColor
        glowRadius: units.scale(3)
        visible: canShowRectangle()
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
    }

    Frame {
        id: _bg
        height: 1.125 * width
        anchors.centerIn: parent
        anchors.margins: units.scale(24)
        width: _image.width + units.gu(32)
        color: canShowRectangle() ? theme.dialog : "transparent"
        border.color: canShowRectangle() ? theme.borderColor : "transparent"

        Label {
            id: _caption
            fontSize: "xx-large"
            color: theme.secondary
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -units.scale(12)
        }

        Label {
            id: _subtitle
            fontSize: "medium"
            color: theme.logoSubtitle
            anchors.top: _caption.bottom
            anchors.margins: units.scale(6)
            centered: true
        }

        Image {
            id: _image
            width: height
            height: units.scale(128)
            anchors.bottom: _caption.top
            anchors.margins: units.scale(12)
            sourceSize: Qt.size(height, width)
            anchors.horizontalCenter: parent.horizontalCenter

            Icon {
                name: iconName
                visible: iconName
                anchors.fill: parent
                color: theme.iconColor
                iconSize: _image.height
            }
        }

        Item {
            id: _contents

            anchors {
                left: parent.left
                right: parent.right
                top: _subtitle.bottom
                bottom: parent.bottom
                margins: units.scale(12)
            }
        }
    }
}
