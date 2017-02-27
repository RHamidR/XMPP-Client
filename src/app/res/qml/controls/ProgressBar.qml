import QtQuick 2.0

Frame {
    smooth:  true
    id: background
    radius: units.scale(2)
    width: units.scale(96)
    height: units.scale(24)
    color: theme.textFieldBackground

    property int value: 50
    property string valueText: value + "%"

    Frame {
        id: progressRect
        radius: parent.radius
        color: theme.secondary
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: (parent.width * value) / 100
    }

    Label {
        color: theme.textColor
        anchors.centerIn: parent
        opacity: value >= 55 ? 0 : 1
        font.pixelSize: units.scale(12)
        text: value < 100 ? " " + valueText : valueText
    }

    Label {
        opacity: value / 100
        anchors.centerIn: parent
        font.pixelSize: units.scale(12)
        color: theme.primaryForeground
        text: value < 100 ? " " + valueText : valueText
    }
}
