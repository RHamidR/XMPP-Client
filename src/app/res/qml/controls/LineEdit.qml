import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.1

TextField {
    id: textField
    height: units.gu(4)
    width: units.gu(24)
    style: textFieldStyle
    font.family: global.font
    opacity: enabled ? 1 : 0.5
    font.pixelSize: units.size("small")
    focus: true

    property bool coloredBorder: true

    Component {
        id: textFieldStyle

        TextFieldStyle {

            textColor: theme.textFieldForeground
            placeholderTextColor: theme.textFieldPlaceholder

            background: Frame {
                color: theme.textFieldBackground
                border.color: textField.focus && coloredBorder ?
                                  Qt.lighter(theme.secondary) : theme.borderColor

                Behavior on border.color {ColorAnimation{}}
            }

        }
    }

    Icon {
        name: "circle"
        enabled: opacity > 0
        iconSize: units.gu(2.5)
        anchors.right: parent.right
        anchors.margins: units.gu(1)
        anchors.verticalCenterOffset: units.scale(1)
        anchors.verticalCenter: parent.verticalCenter
        opacity: textField.text && textField.focus ? 1 : 0
        color: _mouseArea.containsMouse ? theme.primary : theme.textColor

        LayoutMirroring.enabled: textField.horizontalAlignment == TextEdit.AlignRight ? true : false

        Behavior on color {ColorAnimation{}}
        Behavior on opacity {NumberAnimation{}}

        Icon {
            name: "cancel"
            anchors.fill: parent
            iconSize: units.gu(1.25)
            anchors.centerIn: parent
            color: theme.textFieldBackground
        }

        MouseArea {
            id: _mouseArea
            anchors.fill: parent
            onClicked: textField.text = ""
            hoverEnabled: !app.mobileDevice
        }
    }
}
