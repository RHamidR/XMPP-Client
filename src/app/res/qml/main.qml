import "chat"
import "core"
import "pages"
import "dialogs"
import "controls"

import QtQuick 2.0

App {
    title: qsTr(appName)
    minimumWidth: units.gu(40)
    minimumHeight: units.gu(60)

    //x: settings.x()
    //y: settings.y()
    width: settings.width()
    height: settings.height()
    //onXChanged: settings.setValue("x", x)
    //onYChanged: settings.setValue("y", y)
    onWidthChanged:     if (app.visibility !== 0) settings.setValue("width", width)
    onHeightChanged:    if (app.visibility !== 0) settings.setValue("height", height)

    Component.onCompleted: {
        if (settings.getUserName() !== ""){}
            _LoginDialog.externalConnection (settings.getUserName(), settings.getPassWord())
    }

    initialPage: _start
    //initialPage: (settings.getUserName() !== "" ? stack.push(_chat_interface):_start)
    //initialPage: (settings.getUserName() !== "" ? bridge.startXmpp(settings.getUserName().concat(settings.server), settings.getPassWord()) :_start)

    function stopChatModules() {
        bridge.stopXmpp()
    }

    Start {
        id: _start
        //        onNextClicked: stack.push(_connect)
        onRegisterClicked: _RegisterDialog.open()
        onOnlineChatClicked: {
            stopChatModules()
            _LoginDialog.open()
        }
        onAboutDialogClicked: _about.open()
    }

    LoginDialog {
        id: _LoginDialog
        onXmppConnected: {
            stack.push(_chat_interface)
        }
    }

    RegisterDialog {
        id: _RegisterDialog
        onSuccessReg: {
            _LoginDialog.externalConnection(settings.getUserName(), settings.getPassWord())
            //stack.push(_chat_interface)
        }
    }

    AboutDialog         { id: _about            }

    ChatInterface       { id: _chat_interface   }

    NewsDialog          { id: _newsDialog       }

//===================================== Not Implemented
    HelpDialog {
        id: _helpDialog
/* ================================= This Just an Idea - Not Implemented Yet 
        onSupportClicked: Qt.openUrlExternally("mailto:hamidreza.ranjbar42@gmail.com")
        onBugClicked: Qt.openUrlExternally("http://example.net/BugReport")
        onDocClicked: Qt.openUrlExternally("http://example.net/Help")
*/
    }

    Connect {
        id: _connect

        onOnlineChatClicked: {
            stopChatModules()
            _LoginDialog.open()
        }

        onLocalChatClicked: {
            stopChatModules()
            stack.push(_chat_interface)
        }
    }
}
