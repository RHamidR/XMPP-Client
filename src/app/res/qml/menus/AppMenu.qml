import "../core"
import "../controls"

import QtQuick 2.0
import QtQuick.Controls 1.0 as Controls

Menu {
    id: _shareFileMenu

    data: Column {
        anchors.centerIn: parent

        Button {
            id: aboutUs
            flat: true
            iconName: "about"
            text: qsTr("درباره ما")
            fontSize: "medium"
            width: website.width
            onClicked: _about.open()
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            flat: true
            iconName: "cog"
            fontSize: "medium"
            width: website.width
            text: qsTr("سفارشی سازی")
            onClicked: _preferences.open()
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            flat: true
            id: fullscreen
            visible: height > 0
            width: website.width
            iconName: "fullscreen"
            text: enter_full_screen
            height: device.isMobile() ? 0 : aboutUs.height
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                app.appMenu.close()

                if (text === enter_full_screen) {
                    text = exit_full_screen
                    app.hide()
                    app.showFullScreen()
                }

                else {
                    text = enter_full_screen
                    app.hide()
                    app.showNormal()
                }
            }

            Component.onCompleted: {
                if (app.mobileDevice) {
                    height = 0
                    enabled = false
                }
            }

            property string exit_full_screen: qsTr("خروج از تمام صفحه")
            property string enter_full_screen: qsTr("تمام صفحه")
        }

        Button {
            flat: true
            id: website
            iconName: "globe"
            fontSize: "medium"
            text: qsTr("وب سایت ما")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: Qt.openUrlExternally("http://example.org")
        }
    }
}
