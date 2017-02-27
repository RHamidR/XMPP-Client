import "../core"
import "../controls"
import QtQuick 2.0

ColumnPage {
    caption: title
    title: qsTr("شبکه اجتماعی")
    iconName: "globe"
    subtitle: qsTr("یکی از گزینه ها را انتخاب کنید")

    signal chatHelpClicked
    signal localChatClicked
    signal onlineChatClicked


    contents: Column {
        spacing: units.scale(4)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -parent.height * 0.17

        Button {
            text: qsTr("گزینه اضافی")
            width: units.gu(24)
            onClicked: onlineChatClicked()

        }

        Button {
            text: qsTr("ورود")
            width: units.gu(24)
            onClicked: onlineChatClicked()
        }

        Button {
            text: qsTr("اطلاعات بیشتر")
            width: units.gu(24)
            onClicked: chatHelpClicked()
        }
    }
}
