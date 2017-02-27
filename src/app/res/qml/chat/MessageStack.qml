import "../core"
import "../controls"

import QtQuick 2.0
import QtMultimedia 5.0

Item {
    opacity: 0
    id: messageStack

    property string peer
    property string uuid

    property bool peer_disconnected: false

    signal userButtonClicked
    signal userChanged(string user)

    Behavior on opacity {NumberAnimation{}}

    function drawMessage(from, to,  message, isLocal) {
        if (message) {
            if (!peer_disconnected) {
                _status.opacity = 0
                receiveSound.play()
            }

            _bubble_model.append({"_from": from,
                                     "_to": to,
                                     "_message": message,
                                     "_isLocal": isLocal})

            _bubble_view.positionViewAtEnd()
        }
    }

    function clear() {
        _bubble_model.clear()
    }

    function setPeer(nickname, id) {
        peer = nickname
        uuid = id
        opacity = 1
        userChanged(nickname)
        peer_disconnected = false
        _bubble_view.positionViewAtEnd()
    }

    onVisibleChanged: {
        if (!visible)
            _status.text = ""
    }

    Connections {
        target: bridge
        onDelUser: {
            if (id === uuid) {
                peer_disconnected = true
                _status.text = peer + " " + qsTr("دیگر در دسترس نیست")
            }
        }

        onDrawMessage: {
            drawMessage(from, "local user", message, false)
        }
    }

    SoundEffect {
        id: sendSound
        source: "qrc:/sounds/sounds/send.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    SoundEffect {
        id: receiveSound
        source: "qrc:/sounds/sounds/receive.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }

    SoundEffect {
        id: alertSound
        source: "qrc:/sounds/sounds/alert.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }
// ##################################################################################### Not Worked
    Item {
        visible: false
        MediaPlayer {
            id: mediaplayer
        }

        VideoOutput {
            anchors.fill: parent
            source: mediaplayer
        }

        MouseArea {
            id: playArea
            anchors.fill: parent
            onPressed: mediaplayer.play();
        }
    }

    SoundEffect {
        id: messageAudio

        source: "qrc:/sharing/sharing/audio.wav"
        volume: settings.soundsEnabled() ? 1 : 0
    }
//###################################################################################### Not Worked
    NiceScrollView {
        anchors {
            fill: parent
            bottomMargin: _chat_controls.height * 1.2 + _status.height
        }

        ListView {
            id: _bubble_view
            anchors.fill: parent
            anchors.topMargin: units.gu(1)

            model: ListModel {
                id: _bubble_model
            }

            delegate: BubbleMessage {
                to: _to
                from: _from
                message: _message
                isLocal: _isLocal
                id: _bubble_message

                onClickedPicture:
                {
                    notification.show("تست نمایش تصویر ارسالی کلیک شده - " + link)
                }
                onClickedVideo:
                {
                    notification.show("تست پخش ویدئو ارسالی کلیک شده - " + link)
                    mediaplayer.source = link
                    //mediaplayer.parent.visible = true
                    mediaplayer.play()
                }
                onClickedAudio:
                {
                    notification.show("تست پخش صدای ارسالی کلیک شده - " + link)
                    messageAudio.source(link)
                    messageAudio.play()
                    //bridge.playAudio(link)
                }

                state: {
                    if (isLocal)
                        return "local"
                    else
                        return "remote"
                }

                Component.onCompleted: {
                    assignConversation(peer)
                }
            }
        }
    }

    Label {
        id: _status
        centered: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: _chat_controls.height * 1.25

        Behavior on opacity {NumberAnimation{}}

        Timer {
            id: _timer
            interval: 500
            onTriggered: !peer_disconnected ? _status.opacity = 0 : undefined
        }

        function show() {
            _status.opacity = 1
            _timer.restart()
        }

        Connections {
            target: bridge
            onStatusChanged: {
                if (status == "composing" && from == uuid) {
                    _status.text = peer + " " + qsTr("is typing") + "..."
                    _status.show()
                }

                if (status == "seen" && from == uuid) {
                    _status.text = qsTr("Seen at") + Qt.formatDateTime(new Date(), " hh:mm:ss AP")
                    _status.opacity = 1
                }
            }
        }
    }

    //ShareFileControls{
    ChatControls {
        id: _chat_controls

        onShareFileClicked: avatarMenu.toggle(_chat_controls)//bridge.shareFiles(uuid)

        Connections {
            target: avatarMenu
            onSharingGaleryImage:{

                // It could be ###    var link = OpenFileDialog
                var link = ":/../../../../sharing/sharing/picture.jpg"
                var messageText = "<a href=\"picture:"+ ((link.charAt(0)===":") ? link.substring(1) : link) + "\">"+
                                    "<img src=\"" + link + "\" style=\"width:200%; height:200%\" /></a>" +
                                    "<br /> این تست ارسال عکس میباشد. <br/> درحال توسعه نرم افزار هستیم <br /> لطفا شکیبا باشید."
                bridge.sendMessage(uuid, messageText)
                drawMessage("local user", peer, messageText, true)
            }
            onSharingGaleryVideo:{
                var link = ":/../../../../sharing/sharing/video.mp4"
                var messageText = "<a href=\"video:"+ ((link.charAt(0)===":") ? link.substring(1) : link) + "\">" +
                "<img src=\":/../../../../sharing/sharing/video.jpg\"   style=\"width:200%; height:200%\" /></a>"

                bridge.sendMessage(uuid, messageText)
                drawMessage("local user", peer, messageText, true)
            }
            onSharingGaleryAudio:{
                var link = "qrc:/sharing/sharing/audio.wav"
                var messageText = "<a href=\"audio:"+ ((link.charAt(0)===":") ? link.substring(1) : link) + "\">" +
                "<img src=\":/../../../../sharing/sharing/audio.jpg\"  style=\"width:200%; height:200%\" /></a>"

                bridge.sendMessage(uuid, messageText)
                drawMessage("local user", peer, messageText, true)
            }
            onSharingMyLocation:    notification.show("بزودی ارسال موقعیت مکانی برقرار می شود")
            onSharingRecordedImage: notification.show("بزودی ارسال تصویر با دوربین برقرار میشود")
            onSharingRecordedVideo: notification.show("بزودی ارسال ویدئو با دوربین برقرار میشود")
            onSharingRecordedAudio: notification.show("بزودی ارسال صدای میکروفن برقرار میشود")
            onSharingMyPaint:       notification.show("بزودی امکان ارسال دستنوشته برقرار میشود")
        }

        //onUserIsWriting: bridge.sendStatus(uuid, "درحال نوشتن..")
        onUserButtonClicked: messageStack.userButtonClicked()

        onNewMessage: {
            if (message) {
                bridge.sendMessage(uuid, message)
                drawMessage("local user", peer, message, true)
            } else {
                alertSound.play()
            }
        }

    }
}
