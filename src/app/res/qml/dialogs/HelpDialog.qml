import "../core"
import "../controls"

import QtQuick 2.0
Item{}
/* ========================= Not Implemented ----------- 
Dialog {
    id: _help
    title: qsTr("Get Help")

    signal bugClicked
    signal docClicked
    signal supportClicked

    contents: Item {
        id: item
        anchors.centerIn: parent

        Label {
            id: _caption
            text: qsTr("راهنما")
            fontSize: "xx-large"
            color: theme.secondary
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -units.scale(12)
        }

        Label {
            id: _subtitle
            fontSize: "medium"
            color: theme.logoSubtitle
            anchors.top: _caption.bottom
            anchors.margins: units.scale(6)
            centered: true
            text: qsTr("برای پشتیبانی از این قسمت عمل کنید.")
        }

        Icon {
            name: "help"
            width: height
            iconSize: height
            color: theme.textColor
            height: units.scale(96)
            anchors.bottom: _caption.top
            anchors.margins: units.scale(12)
            centered: true
        }

        Column {
            spacing: units.scale(4)

            anchors {
                top: _subtitle.bottom
                bottom: parent.bottom
                margins: units.scale(12)
                horizontalCenter: item.horizontalCenter
            }

            anchors.verticalCenterOffset: -parent.height * 0.17

            Button {
                text: qsTr("گزارش خطا")
                onClicked: bugClicked()
                width: units.gu(24)
            }

            Button {
                width: units.gu(24)
                text: qsTr("کسب اطلاعات بیشتر")
                onClicked: supportClicked()
            }

            Button {
                onClicked: docClicked()
                width: units.gu(24)
                text: qsTr("راهنمای کاربری نرم افزار")
            }
        }
    }
}
*/
