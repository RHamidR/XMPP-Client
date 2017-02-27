import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: dialog
    width: 2 * app.width
    height: 2 * app.height
    enabled: overlay.enabled

    x: (app.width / 2) - (width / 2)
    y: (app.height / 2) - (height / 2)

    property alias title: _title.text
    property bool forceFocus: false
    property bool helpButton: false
    default property alias contents: _contents.data

    signal opened
    signal closed
    signal helpClicked

    function open() {
        _dialog.open()
        overlay.open()

        opened()
    }

    function close() {
        _dialog.close()
        overlay.close()

        closed()
    }

    Item {
        id: _dialog
        opacity: 0
        visible: opacity > 0
        enabled: opacity > 0
        anchors.centerIn: parent
        width: _background.width
        height: _background.height
        anchors.verticalCenterOffset: parent.height

        LayoutMirroring.enabled: true
        LayoutMirroring.childrenInherit: true

        function open() {
            opacity = 1
            anchors.verticalCenterOffset = 0
        }

        function close() {
            opacity = 0
            anchors.verticalCenterOffset = app.height
        }

        Behavior on opacity {NumberAnimation{}}
        Behavior on anchors.verticalCenterOffset {NumberAnimation{}}

        RectangularGlow {
            opacity: 0.5
            color: theme.shadow
            glowRadius: units.gu(2)
            anchors.fill: _background
        }

        Rectangle {
            id: _background
            radius: units.gu(1)
            color: theme.dialog
            width: app.width * 0.9 > units.gu(60) ? units.gu(60) : app.width * 0.9
            height: app.height * 0.8 > units.gu(60) ? units.gu(60) : app.height * 0.8

            NiceScrollView {
                anchors.fill: parent
                anchors.margins: units.gu(1)
                anchors.topMargin: _header.height + anchors.margins

                Flickable {
                    anchors.fill: parent
                    flickableDirection: Flickable.VerticalFlick

                    Item {
                        id: _contents
                        anchors.fill: parent
                    }
                }
            }

            Rectangle {
                id: _header
                height: units.gu(7)
                radius: parent.radius
                color: "transparent"

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: -units.scale(1)
                }

                Rectangle {
                    color: parent.color
                    anchors.fill: parent
                    anchors.topMargin: parent.radius

                    Rectangle {
                        height: units.scale(1)
                        color: "transparent"

                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }

                Label {
                    id: _title
                    fontSize: "x-large"
                    elide: Text.ElideRight
                    anchors.centerIn: parent
                }

                Icon {
                    id: _close
                    name: "cancel"
                    color: _title.color
                    visible: !forceFocus
                    enabled: !forceFocus
                    anchors.right: parent.right
                    anchors.margins: units.gu(2)
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: dialog.close()
                    }
                }

                Icon {
                    name: "question"
                    visible: helpButton
                    enabled: helpButton
                    anchors.right: _close.left
                    anchors.margins: units.gu(2)
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        onClicked: helpClicked()
                    }
                }
            }
        }
    }
}
