import "../core"
import "../controls"

import QtQuick 2.0

MessageBox {
    icon: "about"
    caption: qsTr(appName)
    title: qsTr("درباره پروژه") //+ " " + qsTr(appName)
    details: qsTr("نسخه نرم افزار") + " " + appVersion

    data: Item {
/*
        Button {
            id: _acknowledgements
            text: qsTr("وب سایت")
            anchors.topMargin: units.gu(0.5)
//            anchors.top: _check4updates.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                close()
                Qt.openUrlExternally("http://example.com/")
            }
        }
        Button {
            id: _check4updates
            anchors.centerIn: parent
            text: qsTr("گزینه اضافی")
            width: _acknowledgements.width
            anchors.verticalCenterOffset: units.gu(3)

            onClicked: {
                close()
                updates.checkForUpdates(true)
            }
        }
*/
        Label {
            id: _lbl1
            centered: true
            textFormat: Text.RichText
            anchors.topMargin: units.gu(2)
//            anchors.top: _acknowledgements.bottom
/*            text: qsTr("تمامی حقوق برای") + " " + // "&copy; 2013-" + Qt.formatDateTime(new Date(), "yyyy ") +
                  appCompany +
                  " محفوظ است"
*/
            text: qsTr("پروژه")
        }
        Label {
            id: _lbl2
            centered: true
            textFormat: Text.RichText
            anchors.topMargin: units.gu(2)
            anchors.top: _lbl1.bottom
            text: qsTr("تهیه کننده:  ")
        }
        Label {
            id: _lbl3
            centered: true
            textFormat: Text.RichText
            anchors.topMargin: units.gu(2)
            anchors.top: _lbl2.bottom
            text: qsTr("")
        }
        Label {
            id: _lbl4
            centered: true
            textFormat: Text.RichText
            anchors.topMargin: units.gu(4)
            anchors.top: _lbl3.bottom
            text: qsTr("")
        }
    }
}
