import "../controls"

import QtQuick 2.2
import QtGraphicalEffects 1.0

Frame {
    id: _sidebar

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom

    color: theme.background

    Component.onCompleted: show()

    property alias userCount: _users.count

    Behavior on width {NumberAnimation{}}

    signal hideMessageStack
    signal selected(string name, string uuid)

    property alias connectedUsers: _usersModel.count

    function sidebarFitsScreen() {
        return app.width >= units.scale(240) && app.width > app.height
    }

    function show() {
        if (_users.count <= 0)
            width = app.width
        else if (sidebarFitsScreen())
            width = units.scale(240)
        else
            width = app.width * 0.75
        avatarMenu.close()
    }

    function hide() {
        width = 0
        avatarMenu.close()
        //if (_users.count <= 0) hideMessageStack()
    }

    Connections {
        target: app
        onWidthChanged: {
            var m_width
            if (_users.count <= 0)
                m_width = app.width
            else if (sidebarFitsScreen())
                m_width = units.scale(240)
            else
                m_width = app.width * 0.75

            if (width > 0)
                width = m_width
        }
    }

    Connections {
        target: bridge
        onNewUser: addUser(nick, id)
        onError: errorHappened(message)
        onPresenceReceived: friendReqCompleted()
    }

    ListModel {
        id: _usersModel
    }

    function clear() {
        _usersModel.clear()
        search_edit.text = ""
    }
    function friendReqCompleted(){
        if (_addIcon.state != "fixed")
            _addIcon.state = "fixed"

    }

    function errorHappened(message) {
        friendReqCompleted()
        //alert(message)
    }

    function addUser(name, user_id) {
        _usersModel.append({"name": name, "user_id": user_id})
        autoAdjustWidth()
    }

    function autoAdjustWidth() {
        //if (_usersModel.count >= 1)
            show()
    }

    Item {
        id: _panel
        anchors.fill: parent

        Frame {
            z: 2
            id: searchItem
            height: units.gu(5.6)
            color: theme.background

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Icon {
                id: _search
                name:  "search"
                iconSize: units.gu(2)
                anchors.left: parent.left
                anchors.margins: units.gu(2)
                opacity: _sidebar.width > 0 ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter
            }
            Button {
                id: _add
                width: _search.width * 2
                anchors.right: parent.right
                anchors.margins: units.gu(1)
                opacity: _sidebar.width > 0 ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter


                    Icon {
                        id: _addIcon
                        name: "plus"
                        anchors.centerIn: parent
                        iconSize: units.gu(2)

                        Behavior on rotation {NumberAnimation{}}
                        states: [
                            State { name: "fixed"
                                    PropertyChanges { target: _addIcon; rotation: 0; name: "plus"}},
                            State { name: "waiting"
                                    PropertyChanges { target: _addIcon; onRotationChanged: rotation += 90; rotation: 1; name: "fa-spinner"}}
                        ]
                        function wait() {   _addIcon.state = "waiting"  }

                        function stop() {   _addIcon.state = "fixed"    }
                    }
                    function addTheFriend(){
                        if (search_edit.text.length>0){
                            _addIcon.wait()
                            bridge.addContact(search_edit.text.concat("@" + settings.server))
                        }
                    }
                    onClicked: _add.addTheFriend()
            }

            LineEdit {
                id: search_edit
                anchors.left: _search.right
                anchors.right: _add.left
                visible: _sidebar.width > 0
                anchors.leftMargin: units.gu(2)
                anchors.rightMargin: units.gu(1)
                placeholderText: qsTr("جستجوی دوستان..")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Label {
            fontSize: "medium"
            text: qsTr("شما هیچ دوستی ندارید")
            anchors.centerIn: parent
            opacity: _usersModel.count <= 0 && _sidebar.width > 0 ? 1 : 0
            Behavior on opacity {NumberAnimation{}}
        }

        NiceScrollView {
            z: 1
            clip: true
            id: scrollview
            anchors.fill: parent
            anchors.topMargin: searchItem.height - units.scale(1)

            ListView {
                z: 1
                id: _users
                model: _usersModel
                anchors.fill: parent

                Connections {
                    target: search_edit
                    onTextChanged: {
                        _users.update()
                        _users.positionViewAtBeginning()
                    }
                }

                delegate: UserItem {
                    id: _item
                    username: name
                    uuid: user_id
                    onSelectedChanged: {
                        if (!sidebarFitsScreen())
                            _sidebar.hide()
                    }

                    Component.onCompleted: {
                        _users.cacheBuffer += _item.height
                        console.log("index: " + (index+1) + " | Friends: " + bridge.getFriendsCount())
                        if ( (index+1) === bridge.getFriendsCount())
                        {
                            console.log ("Chat Interface Loaded Completely")
                            var offlineMessagesCount = bridge.readOfflineMessages()
                            if (offlineMessagesCount > 0){
                                notification.show("شما " + offlineMessagesCount + " عدد پیام جدید دارید.")
                                notificationio.notify ("شما " + offlineMessagesCount + " عدد پیام جدید دارید.")
                            }
                        }
                    }
                }
            }
        }
    }
}
