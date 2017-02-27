import "."
import "../controls"

import QtQuick 2.0

Flickable {
    id: page
    visible: false
    onVisibleChanged: update()
    Component.onCompleted: update()
    flickableDirection: Flickable.VerticalFlick

    MouseArea {
        anchors.fill: parent
        onClicked: appMenu.close()
    }

    property string title
    property bool flickable

    function update() {
        if (visible) {
            navigationBar.title = title
            navigationBar.currentPage = page
        }
    }

    property list<Item> leftWidgets: [
        Icon {
            name: "chevron-left"
            color: theme.primaryForeground
            opacity: stack.depth > 1 ? 1 : 0

            Behavior on opacity {
                NumberAnimation{}
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stack.pop()
                enabled: parent.opacity > 0
            }
        }
    ]

    property list<Item> rightWidgets: [
        Icon {
            name: "bars"
            color: theme.primaryForeground

            MouseArea {
                anchors.fill: parent
                onClicked: appMenu.toggle(parent)
            }
        }
    ]
}
