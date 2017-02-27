import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    height: units.gu(6)

    property Page currentPage
    property alias title: _title.text

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    RectangularGlow {
        opacity: 0.5
        color: theme.shadow
        anchors.fill: _panel
        glowRadius: units.scale(6)
    }

    Rectangle {
        id: _panel
        anchors.fill: parent
        color: theme.primary

        Rectangle {
            id: _border
            height: units.scale(1)
            color: Qt.darker(parent.color, 1.1)

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    Row {
        id: leftItem
        spacing: units.gu(1)
        children: currentPage.leftWidgets

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
    }

    Row {
        id: rightItem
        spacing: units.gu(2)
        layoutDirection: Qt.RightToLeft
        children: currentPage.rightWidgets

        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
    }

    Label {
        id: _title
        fontSize: "x-large"
        maximumLineCount: 1
        elide: Text.ElideRight
        textFormat: Text.PlainText
        color: theme.primaryForeground
        horizontalAlignment: Text.AlignHCenter

        property int leftMargin: {
            if (rightItem.width > leftItem.width)
                return rightItem.width - units.gu(1)
            else
                return units.gu(1)
        }

        property int rightMargin: {
            if (rightItem.width < leftItem.width)
                return leftItem.width - units.gu(1)
            else
                return units.gu(1)
        }

        anchors {
            left: leftItem.right
            right: rightItem.left
            leftMargin: _title.leftMargin
            rightMargin: _title.rightMargin
            verticalCenter: parent.verticalCenter
        }
    }
}
