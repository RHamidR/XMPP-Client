import "../core"
import "../controls"

import QtQuick 2.0

// ========================================= Not Completed

Dialog {
    id: message

    property alias icon: _icon.name
    property alias caption: _title.text
    property alias details: _subtitle.text
    default property alias data: _contents.data

    contents: Item {
        anchors.fill: parent
        anchors.margins: units.gu(1.2)

        Icon {
            id: _icon
            color: theme.textColor
            iconSize: units.gu(12)
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -height * 1.1
        }

        Label {
            id: _title
            fontSize: "medium"
            color: theme.secondary
            anchors.top: _icon.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: units.gu(1.5)
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Label {
            id: _subtitle
            fontSize: "small"
            color: theme.logoSubtitle
            anchors.left: parent.left
            anchors.top: _title.bottom
            anchors.right: parent.right
            anchors.topMargin: units.gu(0.5)
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Item {
            id: _contents
            anchors.top: _subtitle.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: units.gu(2)
            anchors.margins: units.scale(16)
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
