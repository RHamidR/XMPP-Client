import "../core"
import "../controls"

import QtQuick 2.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.0 as Controls

Page {
    id: page
    interactive: false

    function setTitle(string) {
        title = string
        navigationBar.title = string
    }

    function addUser(nickname, id) {
        if (!loginSound.playing) {
            loginSound.play()
        }
    }

    function removeUser(nickname) {
        if (!logoutSound.playing) {
            logoutSound.play()
        }
    }

    onVisibleChanged: {
        if (!visible) {
            _sidebar.clear()
            _messageStack.clear()
            _sidebar.autoAdjustWidth()
        }

        else {
            setTitle(qsTr("مکالمه"))
        }
    }

    rightWidgets: [
        Icon {
            name: "download"
            color: theme.primaryForeground
            opacity: _sidebar.sidebarFitsScreen()
                     && downloadMenu.activeDownloads > 0 ? 1 : 0

            Behavior on opacity {
                NumberAnimation{}
            }

            MouseArea {
                anchors.fill: parent
                enabled: parent.opacity > 0
                onClicked: app.downloadMenu.toggle(parent)
            }
        }
    ]

    Connections {
        target: bridge
        onDelUser: removeUser(nick)
        onNewUser: addUser(nick, id)
    }

    SoundEffect {
        id: loginSound
        source: "qrc:/sounds/sounds/login.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    SoundEffect {
        id: logoutSound
        source: "qrc:/sounds/sounds/logout.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    MouseArea {
        id: _swipeArea
        anchors.fill: parent
        enabled: !_sidebar.sidebarFitsScreen()

        property point origin
        property bool ready: false
        signal move(int x, int y)
        signal swipe(string direction)

        onPressed: {
            drag.axis = Drag.XAndYAxis
            origin = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            switch (drag.axis) {
            case Drag.XAndYAxis:
                if (Math.abs(mouse.x - origin.x) > 16) {
                    drag.axis = Drag.XAxis
                }
                else if (Math.abs(mouse.y - origin.y) > 16) {
                    drag.axis = Drag.YAxis
                }
                break
            case Drag.XAxis:
                move(mouse.x - origin.x, 0)
                break
            case Drag.YAxis:
                move(0, mouse.y - origin.y)
                break
            }
        }

        onReleased: {
            switch (drag.axis) {
            case Drag.XAndYAxis:
                canceled(mouse)
                break
            case Drag.XAxis:
                swipe(mouse.x - origin.x < 0 ? "left" : "right")
                break
            case Drag.YAxis:
                swipe(mouse.y - origin.y < 0 ? "up" : "down")
                break
            }
        }
    }

    Item {
        id: _mainView
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        function setAnchors() {
            anchors.left =  _sidebar.sidebarFitsScreen() ?
                        _sidebar.right : parent.left
            anchors.leftMargin = _sidebar.sidebarFitsScreen() ?
                        units.scale(-1) : 0
        }

        Component.onCompleted: setAnchors()

        Connections {
            target: app
            onWidthChanged: _mainView.setAnchors()
        }

        Column {
            enabled: opacity > 0
            spacing: units.gu(1.2)
            anchors.centerIn: parent
            opacity: _messageStack.opacity > 0 ? 0 : 1
            anchors.verticalCenterOffset: -_comments_icon.height / 3

            Behavior on opacity {NumberAnimation{}}

            Icon {
                id: _comments_icon
                centered: true
                name: "comments"
                iconSize: units.gu(16)
            }

            Label {
                centered: true
                fontSize: "large"
                color: theme.secondary
                text: {
                    if (_sidebar.connectedUsers > 0)
                        return qsTr("مکالمه کنید")
                    else
                        return qsTr("با یکی از دوستان خود مکالمه کنید")
                }
            }

            Label {
                centered: true
                fontSize: "small"
                color: theme.logoSubtitle
                text: {
                    if (_sidebar.connectedUsers > 0)
                        return qsTr("یکی از دوستان خود را برای مکالمه انتخاب کنید")
                    else
                        return qsTr("هیچکدام از دوستانتان انتخاب نشده اند")
                }
            }
        }

        MessageStack {
            id: _messageStack
            anchors.fill: parent
            onUserButtonClicked: _sidebar.show()
        }
    }

    Rectangle {
        color: "black"
        anchors.fill: parent
        opacity: _sidebar.width > 0 && !_sidebar.sidebarFitsScreen() ?
                     0.75 : 0.0

        Behavior on opacity {NumberAnimation{}}
    }

    UserSidebar {
        id: _sidebar

        onSelected: _messageStack.setPeer(name, uuid)
        onHideMessageStack: {
            if (page.visible)
                page.setTitle(qsTr("مکالمه"))
        }

        Connections {
            target: _swipeArea
            onSwipe: {
                if (direction == "right") {
                    _sidebar.show()
                    _userIcon.toggled = true
                } else {
                    _sidebar.hide()
                }
            }
        }

        Connections {
            target: app
            onWidthChanged: {
                if (_sidebar.userCount >= 1
                        && _sidebar.sidebarFitsScreen()
                        && _sidebar.width <= 0)
                    _sidebar.show()
            }
        }
    }
}
