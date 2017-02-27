import "../core"
import "../controls"
import QtQuick 2.0

ColumnPage {
    caption: title
    iconName: "comments"
    title: qsTr("خوش آمدید")
    subtitle: qsTr("وارد شوید. در صورت نداشتن حساب کاربری ثبت نام کنید.")

    signal registerClicked
    signal onlineChatClicked
    signal aboutDialogClicked

    contents: Column {
        spacing: units.scale(4)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -parent.height * 0.17

        Button {
            text: qsTr("ورود")
            width: units.gu(24)
//            onClicked: chatClicked()
            onClicked: onlineChatClicked()
        }

        Button {
            text: qsTr("ثبت نام")
            width: units.gu(24)
            onClicked: registerClicked()
        }

        Button {
            text: qsTr("درباره")
            width: units.gu(24)
            onClicked: aboutDialogClicked()
            //onClicked: notificationio.notification = "Testing Notification";
            //onClicked: notificationio.Notify("Testing Notification");
        }
    }
}
