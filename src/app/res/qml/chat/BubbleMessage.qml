import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: bubble

    signal clickedPicture(string link)
    signal clickedVideo(string link)
    signal clickedAudio(string link)

    // The receiver of the message
    property string to

    // The sender of the message
    property string from

    // The actual string of the message
    property string message

    // Tells us if the message has been seen by the receiver
    property bool read: false

    // Tells us if the message was sent by the local user or
    // has been sent by a remote user
    property bool isLocal: false

    // Returns the time in a string
    function dateTime() {
        return Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    }

    // Detects and appens hyperlinks and emotes to the input string.
    // For example, it transforms "www.google.com" to "<a href="http://www.google.com">www.google.com</a>"
    function autoFormat(string) {
        var http, www, mailto;

        www = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
        mailto = /(\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b)/gim;
        http = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;

        string = string.replace(mailto, '<a href="mailto:$1">$1</a>');
        string = string.replace(http, '<a href="$1" target="_blank">$1</a>');
        string = string.replace(www, '$1<a href="http://$2" target="_blank">$2</a>');

        return string
    }

    function assignConversation(user) {

        // The message was sent by the local user,
        // however, the receiver of the message is
        // not the current user, so we hide the message.
        if (isLocal && user !== to) {
            height = 0
            visible = false
        }

        // The message was sent by a remote user,
        // however, we hide it because the sender
        // is not the current user
        else if (!isLocal && user !== from) {
            height = 0
            visible = false
        }

        // The message was sent by us to the current
        // user, OR the message was sent by the current
        // user to us.
        else {
            visible = true
            sendMessageRead()
            height = _bg.height + units.scale(21)
        }
    }

    // Calculates the required size for the message to be shown
    // nicely and applies the calculated values
    function drawMessage() {
        _bg.calculateWidth()
        _bg.calculateHeight()
        height = _bg.height + units.scale(21)
        width = childrenRect.width + units.scale(20)
    }

    // The message has been seen by the local user, so we alert the
    // remote user that his/her message has been seen
    function sendMessageRead() {
        if (visible && !read && !isLocal) {
            read = true
            bridge.sendStatus(bridge.getId(from), "seen")
        }
    }

    states: [

        // Displays the message to the right area of the
        // screen and hides the profile picture
        State {
            name: "local"

            AnchorChanges {
                target: triangle
                anchors.right: _bg.right
                anchors.verticalCenter: _bg.verticalCenter
            }

            AnchorChanges {
                target: image
                anchors.right: parent.right
            }

            AnchorChanges {
                target: _bg
                anchors.right: image.left
            }
        },

        // Displays the message to the left area of the screen
        // and shows the profile picture of the remote user
        State {
            name: "remote"

            AnchorChanges {
                target: triangle
                anchors.left: _bg.left
                anchors.verticalCenter: image.verticalCenter
            }

            AnchorChanges {
                target: image
                anchors.left: parent.left
            }

            AnchorChanges {
                target: _bg
                anchors.left: image.right
            }
        }
    ]

    color: "transparent"
    height: _bg.height + units.scale(21)
    width: childrenRect.width + units.scale(20)

    // Tell the remote user that his/her message
    // has been seen when the local user views the message
    onVisibleChanged: sendMessageRead()

    // Draw the message and show a sliding animation
    Component.onCompleted: {
        drawMessage()
        xAni.start()
    }

    Connections {
        target: messageStack

        // Redraw the message when the size
        // of the window changes
        onWidthChanged: drawMessage()
        onHeightChanged: drawMessage()

        // Hide/show the message when the
        // user changes the conversation between
        // one user and another
        onUserChanged: {
            assignConversation(user)
        }
    }

    // Slide the message horizontally upon its generation...
    NumberAnimation {
        id: xAni
        property: "x"
        duration: 200
        target: bubble
        to: isLocal ? parent.width - width : 0
        from: isLocal ? parent.width : -parent.width

        onStopped: {
            anchors.left = isLocal ? undefined : parent.left
            anchors.right = isLocal ? parent.right : undefined
        }
    }

    // Add a shadow to the main rectangle of the message
    RectangularGlow {
        opacity: 0.5
        width: _bg.width
        height: _bg.height
        anchors.centerIn: _bg
        color: theme.borderColor
        glowRadius: units.scale(3)
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
    }

    // Add a shadow to the triangle generated below
    RectangularGlow {
        opacity: 0.5
        width: triangle.width
        height: triangle.height
        color: theme.borderColor
        glowRadius: units.scale(3)
        anchors.centerIn: triangle
        rotation: triangle.rotation
        anchors.verticalCenterOffset: glowRadius
        anchors.horizontalCenterOffset: glowRadius
    }

    // The name says it all...its a triangle that points
    // to the current user (left or right)
    Frame {
        id: triangle
        rotation: 45
        height: width
        width: units.gu(2)
        anchors.leftMargin: -units.gu(1) + units.scale(2)
        anchors.rightMargin: -units.gu(1) + units.scale(2)
    }

    // This image shows the profile picture only when the message is
    // sent by a remote user
    CircularImage {
        id: image
        height: width
        anchors.top: parent.top
        anchors.margins: units.gu(1.5)
        width: isLocal ? 0 : units.gu(7)
        source: isLocal ? "" : "image://profile-pictures/" + bridge.getId(from)
    }

    // This is the actual rectangle that contains the message...finally!
    Frame {
        id: _bg

        // Calculates the required height so that our message will
        // be displayed as nicely as possible
        function calculateHeight() {
            height = text.paintedHeight + units.gu(3)
        }

        // Calculates the required width so that our message will
        // be displayed as nicely as possible
        function calculateWidth() {
            if (text.paintedWidth > (bubble.parent.width * 0.8 - units.gu(14)))
                width = bubble.parent.width * 0.95 - units.gu(10)
            else
                width = text.paintedWidth + units.gu(4)
        }

        // Apply the calculated sizes when the rectangle is created
        Component.onCompleted: {
            calculateWidth()
            calculateHeight()
        }

        color: theme.panel
        radius: units.gu(0.25)

        anchors.top: parent.top
        anchors.bottomMargin: 0
        anchors.margins: units.gu(1.5)

        // This label contains the processed message string as
        // a rich text HTML string
        Label {
            id: text
            anchors.fill: parent
            textFormat: Text.RichText
            anchors.margins: units.gu(1.5)
            font.pixelSize: units.scale(14)
            renderType: Text.NativeRendering
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            onLinkedPictureFile:clickedPicture(theLink)
            onLinkedVideoFile:  clickedVideo(theLink)
            onLinkedAudioFile:  clickedAudio(theLink)

            text: {
                if (isLocal)
                    return autoFormat(message) + "<p><font size=" + units.gu(1.2) +
                            "px color=gray>" + dateTime() + "</font></p>"
                else
                    return autoFormat(message) + "<p><font size=" + units.gu(1.2)
                            + "px color=gray>" + from + " • " + dateTime() + "</font></p>"
            }
        }
    }

    // This rectangle hides the triangle's border that colides with the
    // background rectangle's border
    Rectangle {
        color: _bg.color
        height: triangle.height
        width: triangle.width / 2

        anchors.left: isLocal ? undefined : _bg.left
        anchors.right: isLocal ? _bg.right : undefined
        anchors.verticalCenter: triangle.verticalCenter
    }
}
