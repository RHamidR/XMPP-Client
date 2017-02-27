import "../core"
import "../controls"

import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    height: units.gu(4)


    // This signal is emitted when the user
    // clicks on the "Share File" button
    signal shareFileClicked

    // This signal is emitted when the user
    // clicks on the "Send" button or presses
    // ENTER in the message line edit
    signal newMessage(var message)

    // This signal is emitted when the user
    // beggins writing and the text is not
    // the same as the one 3 seconds ago
    signal userIsWriting

    // This signal is emited when the user icon
    // is clciked
    signal userButtonClicked

    // Clear the textbox when a message is sent
    onNewMessage: _message_textbox.text = ""

/*
    Item {
        id: _sfMenu
        anchors{
            right: parent.right
            left: parent.left
            top:    parent.top
            bottom: _bg.top
        }


        // Create the button to show/hide users
        Button {
            id:     _sPic_button
            width:  12
            height: 12
            iconName: "picture-o"
            left:   parent.left
            top:    parent.top

        }
    }
*/

    // Draw the message controls on the bottom of the window
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    // Add a shadow under the message controls to give them some
    // depth.
    RectangularGlow {
        opacity: 0.5
        anchors.fill: _bg
        color: theme.shadow
        glowRadius: units.scale(6)
    }

    // Create the background item
    Item {
        id: _bg
        height: units.gu(4)
        anchors.fill:   parent

        // Create the button to show/hide users
        Button {
            id: _user_button
            iconName: "user"
            onClicked: userButtonClicked()
            width: _sidebar.sidebarFitsScreen() ? 0 : units.gu(4)

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        // Create the button to share files
        Button {
            id: _share_file
            iconName: "clip"
            onClicked: shareFileClicked()
            //onClicked: shareFileMenu.toggle(_share_file)

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: _user_button.right
                leftMargin: -units.scale(1)
            }
        }

        // Create the message textbox
        LineEdit {
            id: _message_textbox
            coloredBorder: false
            placeholderText: qsTr("پیامتان را بنویسید")
            Keys.onReturnPressed: newMessage(_message_textbox.text)

            property string old_text

            anchors {
                top: parent.top
                right: _send.left
                bottom: parent.bottom
                left: _share_file.right
                leftMargin: -units.scale(1)
                rightMargin: -units.scale(1)
            }

            Timer {
                id: oldTextTimer
                interval: 2000
                onTriggered: parent.old_text = parent.text
            }

            onTextChanged: {
                if (text != "" && text != old_text) {
                    oldTextTimer.restart()
                    userIsWriting();
                }
            }
        }

        // Create the send button
        Button {
            id: _send
            iconName: "send"
            onClicked: newMessage(_message_textbox.text)
            text: _sidebar.sidebarFitsScreen() ? qsTr("بفرست") : ""

            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
        }
    }
}
