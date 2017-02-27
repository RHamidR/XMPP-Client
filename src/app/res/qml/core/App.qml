import "."
import "../chat"
import "../menus"
import "../dialogs"
import "../controls"

import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0 as Controls

Window {
    id: _app
    color: theme.background

    property alias app:     _app
    property alias units:   _units
    property alias theme:   _theme
    property alias stack:   _stack
    property alias global:  _global
    property alias overlay: _overlay
    property alias appMenu: _app_menu
    property alias navigationBar:   _navBar
    property alias avatarMenu:      _avatarMenu
    //property alias startMenu:   _startMenu
    property alias downloadMenu:    _downloadMenu
    property alias notification:    _notification
    property bool  mobileDevice: device.isMobile()

    property Page initialPage

    QtObject {
        id: _global
        property string font: "Roboto"
        property var regular_loader: FontLoader { source: "qrc:/fonts/fonts/regular.ttf" }
        property var awesome_loader: FontLoader { source: "qrc:/fonts/fonts/font_awesome.ttf" }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            appMenu.close()
            avatarMenu.close()
        }
    }

    Image {
        cache: false
        opacity: 0.75
        fillMode: Image.Tile
        anchors.fill: parent
        source: "qrc:/textures/textures/background.png"
    }

    Controls.StackView {
        id: _stack
        anchors.fill: parent
        initialItem: initialPage
        anchors.topMargin: _navBar.height
    }

    Theme               { id: _theme        }
    Units               { id: _units        }
    NavigationBar       { id: _navBar       }
    Overlay             { id: _overlay      }
    Preferences         { id: _preferences  }
//    StartMenu       { id: _startMenu}
    AvatarMenu          { id: _avatarMenu   }
    AppMenu             { id: _app_menu     }
    Notification        { id: _notification }
    DownloadMenu        { id: _downloadMenu }
}
