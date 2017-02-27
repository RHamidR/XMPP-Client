import "../core"
import "../controls"

import QtQuick 2.0
import QtMultimedia 5.0


Dialog {
    id: dialog
    helpButton: true
    title: "فرم ورود"
    onVisibleChanged: _password_edit.text = ""

    signal xmppConnected

    property bool _manual: false
    property int numberOfTries : 0
    property bool connecting: false

    function externalConnection(usernameArg, passwordArg)
    {
        //_user_edit.text = qsTr(usernameArg)
        //_password_edit.text = qsTr(passwordArg)
        _login_button.performActions(usernameArg, passwordArg)
    }

    function connectXmpp() {
        connecting = false
        close()

        if (_manual)
            settings.setUserPass(_user_edit.text, _password_edit.text)
        _manual = false
        _password_edit.text = ""

        _spinnerIcon.hide()
        _warning_label.hide()

        _cancel_button.show()
        _login_button.enabled = true
        _login_button.text = qsTr("ورود")

        xmppConnected()
    }

    function disconnectXmpp() {
        connecting = false
        bridge.stopXmpp()

        _spinnerIcon.hide()
        _warning_label.show()
        _cancel_button.show()

        _user_label.anchors.verticalCenterOffset += units.gu(0.5)
        _login_controls.anchors.verticalCenterOffset -= units.gu(2)

        _login_button.text = qsTr("ورود")

        numberOfTries += 1
    }

    onClosed: {
        if (connecting) {
            disconnectXmpp()
            _login_button.performActions("","")
        }
    }

    Connections {
        target: bridge
        onXmppConnected: connectXmpp()
        onXmppDisconnected: disconnectXmpp()
    }

    SoundEffect {
        id: alertSound
        source: "qrc:/sounds/sounds/alert.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    contents: Column {
        id: column

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: _buttons.top
        anchors.bottomMargin: units.gu(1)

        spacing: units.gu(1)

        Icon {
            id: _logo
            name: "user"
            centered: true
            color: theme.textColor
            iconSize: units.gu(12)

        }

        Label {
            centered: true
            id: _user_label
            fontSize: "large"
            color: theme.secondary
            text: qsTr("ورود به محیط کاربری")
        }

        Item {
            id: spacer
            width: units.gu(1)

            Component.onCompleted: height = calculateHeight()

            Connections {
                target: app
                onHeightChanged: spacer.height = spacer.calculateHeight()
            }

            // MAGIC!! DO NOT TOUCH!!
            function calculateHeight() {
                var constant = dialog.height <= dialog.width ? 3 : 8
                var height = ((_buttons.y - _login_controls.y) / constant) - (3 * _spinnerIcon.height)
                return height
            }
        }

        Icon {
            opacity: 0
            centered: true
            id: _spinnerIcon
            name: "fa-spinner"
            onRotationChanged: rotation += 90
            Component.onCompleted: rotation = 1
            height: opacity > 0 ? units.gu(3.125) : units.gu(1)

            Behavior on height {NumberAnimation{}}
            Behavior on opacity {NumberAnimation{}}
            Behavior on rotation {NumberAnimation{}}

            function show() {
                opacity = 1
            }

            function hide() {
                opacity = 0
            }
        }

        Column {
            id: _login_controls
            spacing: units.gu(0.5)
            width: parent.width - units.gu(3)
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                opacity: 0
                color: "red"
                id: _warning_label
                width: _login_controls.width
                height: opacity > 0 ? units.gu(2) : 0
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("لطفا درستی شماره تلفن و رمز عبور خود را چک کنید")

                Behavior on height {NumberAnimation{}}
                Behavior on opacity {NumberAnimation{}}

                function show() {
                    opacity = 1
                    alertSound.play()
                }

                function hide() {
                    opacity = 0
                }
            }

            LineEdit {
                id: _user_edit
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: units.gu(1.5)
                onTextChanged: settings.setValue("xmpp_nickname", text)
                placeholderText: qsTr("شماره تلفن")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                inputMethodHints: Qt.ImhDialableCharactersOnly
                //TextEdit.focus: true
                //TextInput.focus: true
            }

            LineEdit {
                id: _password_edit
                anchors.left: parent.left
                anchors.right: parent.right
                echoMode: TextInput.Password
                anchors.margins: units.gu(1.5)
                placeholderText: qsTr("رمز عبور")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter

                Keys.onReturnPressed: newMessage(_login_button.performActions("",""))
            }
        }
    }

    Item {
        id: _buttons
        width: parent.width
        height: _cancel_button.height
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: parent.height * (1 / 6) - units.gu(2)

        Button {
            id: _cancel_button
            onClicked: close()
            text: qsTr("لغو")
            anchors.right: center.left
            visible: opacity > 0

            Behavior on opacity {NumberAnimation{}}

            function show() {
                opacity = 1
                _login_button.anchors.left = center.right
                _login_button.anchors.horizontalCenter = undefined
            }

            function hide() {
                opacity = 0
                _login_button.anchors.left = undefined
                _login_button.anchors.horizontalCenter = parent.horizontalCenter
            }
        }

        Item {
            id: center
            width: units.scale(24)
            anchors.centerIn: parent
        }

        Button {
            id: _login_button
            primary: true
            text: qsTr("ورود")
            anchors.left: center.right
            onClicked: performActions("","")
            enabled: _user_edit.length > 0 && _password_edit.length > 0 ? 1 : 0

            function performActions(usernameArg, passwordArg) {
                if (text === qsTr("ورود")) {
                    connecting = true
                    _spinnerIcon.show()
                    _warning_label.hide()
                    _cancel_button.hide()

                    text = qsTr("لغو عملیات")
                    if (usernameArg === "" || passwordArg === "")
                    {
                        _manual = true
                        bridge.startXmpp(_user_edit.text.concat("@" + settings.server), _password_edit.text)
                    }
                    else
                    {
                        _manual = false
                        bridge.startXmpp(usernameArg.concat("@" + settings.server), passwordArg)
                    }
                    //bridge.startXmpp(_user_edit.text.concat("@192.168.43.177"), _password_edit.text)
                }

                else if (text === qsTr("لغو عملیات")) {
                    connecting = false
                    _spinnerIcon.hide()
                    _warning_label.hide()
                    _cancel_button.show()

                    text = qsTr("ورود")
                    bridge.stopXmpp()
                }
            }
        }
    }
}
