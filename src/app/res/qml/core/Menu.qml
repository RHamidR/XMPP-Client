import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Frame {
    id: popover
    color: theme.panel
    radius: units.gu(0.6)
    enabled: opacity > 0
    implicitWidth: maxWidth
    opacity: showing ? 1 : 0
    height: contentHeight + contents.anchors.margins * 2
    width: Math.min(implicitWidth, overlay.width - units.gu(2))

    Behavior on opacity {NumberAnimation{}}

    property Item caller
    property int offset: 0
    property bool showing: false
    property int side: Qt.AlignBottom
    property int padding: units.gu(0.5)
    property int maxWidth: units.gu(25)
    default property alias data: contents.data
    property alias triangleVisible: triangle.visible
    property int contentHeight: contents.childrenRect.height

    signal opened()

    function toggle(widget) {
        if (showing)
            close()

        else
            open(widget)
    }

    function close() {
        showing = false
    }

    function open(widget) {
        caller = widget

        var position = widget.mapToItem(overlay, widget.width / 2, widget.height)
        popover.x = position.x - popover.width / 2

        if (position.y + popover.height + units.gu(2.5) + padding > app.height - navigationBar.height) {
            side = Qt.AlignTop
            popover.y = widget.y - widget.height - popover.height + units.gu(2.2)

            if (position.y - popover.height - units.gu(1.5) - widget.height - padding < units.gu(1.5)) {
                popover.y = units.gu(1.5) + padding
                side = Qt.AlignVCenter
            }
        }

        else {
            side = Qt.AlignBottom
            popover.y = position.y + units.gu(1.5) + padding
        }

        if (popover.x < units.gu(1)) {
            popover.offset = popover.x - units.gu(1)
            popover.x = units.gu(1)
        }

        else if (popover.x + popover.width > popover.parent.width - units.gu(1)) {
            popover.offset = popover.x + popover.width - (popover.parent.width - units.gu(1))
            popover.x = popover.parent.width - units.gu(1) - popover.width
        }

        else {
            popover.offset = 0
        }

        showing = true
        opened()
    }

    Connections {
        target: stack
        onDepthChanged: close()
    }

    Connections {
        target: overlay
        onOpened: close()
    }

    Connections {
        target: parent
        onWidthChanged: showing ? open(caller) : undefined
        onHeightChanged: showing ? open(caller) : undefined
    }

    RectangularGlow {
        opacity: 0.5
        width: parent.width
        height: parent.height
        color: theme.borderColor
        anchors.centerIn: parent
        glowRadius: units.scale(3)
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
    }

    RectangularGlow {
        opacity: 0.5
        width: triangle.width
        height: triangle.height
        color: theme.borderColor
        anchors.centerIn: triangle
        glowRadius: units.scale(3)
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
    }

    Frame {
        rotation: 45
        id: triangle
        height: width
        color: parent.color
        width: units.gu(1.5)
        visible: side != Qt.AlignVCenter

        anchors {
            horizontalCenterOffset: offset
            horizontalCenter: parent.horizontalCenter
            verticalCenterOffset: side == Qt.AlignBottom ? 1 : -1
            verticalCenter: side == Qt.AlignBottom ? parent.top : parent.bottom
        }
    }

    Rectangle {
        color: parent.color
        anchors.fill: parent
        radius: popover.radius
        anchors.margins: units.scale(1)

        Item {
            id: contents
            anchors.fill: parent
            anchors.margins: units.gu(1)
        }
    }
}
