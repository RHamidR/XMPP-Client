import "../core"
import "../controls"

import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.0 as Controls
// ======================================================== Not Completed
Dialog {
    id: dialog
    title: qsTr("سفارشی سازی")

    property bool showOnInit: settings.firstLaunch()

    onVisibleChanged: updateValues()
    Component.onCompleted: {
        if (settings.firstLaunch()) {
//            dialog.open()
            closeButton.text = qsTr("اعمال")
        } else {
            closeButton.text = qsTr("بستن")
            textBox.text = settings.value("nickname", "ناشناس")
        }
    }

    onClosed: {
        if (settings.firstLaunch()){
//            dialog.open()
        }
    }

    contents: Column {
        id: column
        width: parent.width
        spacing: units.scale(8)
        anchors.centerIn: parent

        Label {
            fontSize: "medium"
            color: theme.secondary
            text: qsTr("پروفایل کاربر")
            anchors.left: parent.left
            anchors.margins: units.gu(1)

            Behavior on color {ColorAnimation{}}
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(1)
            height: avatarImage.height * 1.2


            CircularImage {
                height: width
                id: avatarImage
                width: units.scale(48)
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/faces/faces/generic-user.png"// + settings.value("face", randomFace)

                ListView {
                    id: list
                    model: facesList
                }

                Frame {
                    radius: width / 2
                    color: "transparent"
                    anchors.fill: parent
                    anchors.margins: -units.scale(1)

                    Rectangle {
                        id: _bg_hover
                        color: "black"
                        radius: width / 2
                        anchors.fill: parent
                        anchors.margins: parent.border.width
                        opacity: showOnInit   ||
                                 _mouseArea.containsMouse ||
                                 avatarMenu.showing ? 0.5 : 0

                        Behavior on opacity {NumberAnimation{}}
                    }

                    Label {
                        centered: true
                        color: "white"
                        text: qsTr("ویرایش")
                        anchors.bottom: parent.bottom
                        opacity: _bg_hover.opacity > 0 ? 1 : 0
                        Behavior on opacity {NumberAnimation{}}
                        anchors.bottomMargin: parent.height / 8
                    }
                }

                MouseArea {
                    id: _mouseArea
                    anchors.fill: parent
                    hoverEnabled: !app.mobileDevice
                    onClicked: {
                        showOnInit = false
                        notification.show("بزودی")
                    }
                }
            }

            LineEdit {
                id: textBox
                anchors.margins: units.gu(1)
                anchors.right: avatarImage.left
                anchors.left: colorRectangle.right
                anchors.verticalCenter: avatarImage.verticalCenter
                //onTextChanged: settings.setValue("nickname", text)
                placeholderText: qsTr("نام خود را وارد کنید") + "..."
                horizontalAlignment: Text.AlignHCenter
            }

            Frame {
                id: colorRectangle
                height: textBox.height
                color: theme.primary
                anchors.left: parent.left
                opacity: customColor.selected ? 1 : 0
                width: customColor.selected ?  height : 0
                anchors.verticalCenter: avatarImage.verticalCenter

                Behavior on width {NumberAnimation{}}
                Behavior on opacity {NumberAnimation{}}

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: colorDialog.open()
                    enabled: customColor.selected
                }
            }
        }

        Rectangle {
            width: height
            color: "transparent"
            height: units.scale(4)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            fontSize: "medium"
            color: theme.secondary
            anchors.left: parent.left
            text: qsTr("سایر تنظیمات")
            anchors.margins: units.gu(1)

            Behavior on color {ColorAnimation{}}
        }

        Row {
            spacing: units.scale(8)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: units.gu(1)

            Rectangle {
                height: width
                width: units.gu(1)
                color: "transparent"
            }

            Column {
                spacing: units.scale(8)

                CheckBox {
                    width: height
                    id: soundsEnabled
                    selected: settings.soundsEnabled()
                    text: qsTr("افکت صدا")
                    onSelectedChanged: settings.setValue("soundsEnabled", selected)
                }

                CheckBox {
                    width: height
                    id: customColor
                    selected: settings.customColor()
                    text: qsTr("استفاده از رنگ پروفایل برای پوسته")
                    onSelectedChanged: {
                        settings.setValue("customColor", selected)
                        theme.setColors()
                    }
                }

                CheckBox {
                    width: height
                    id: notifyUpdates
                    selected: settings.notifyUpdates()
                    text: qsTr("اعلان وجود بروزرسانی نرم افزار")
                    onSelectedChanged: settings.setValue("notifyUpdates", selected)
                }
            }
        }

        Rectangle {
            width: height
            color: "transparent"
            height: units.scale(8)
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            primary: true
            id: closeButton
            width: units.gu(22)
            radius: units.gu(0.5)
            anchors.horizontalCenter: parent.horizontalCenter

            enabled: true/*{
                if (textBox.text.length < 3)
                    return false
                else
                    return true
            }*/

            onClicked: {
                if (settings.firstLaunch()) {
                    settings.setValue("firstLaunch", false)
                    notification.show(qsTr("در حال تکمیل این بخش هستیم"))
                }

                dialog.close()
            }
        }
    }

    ColorDialog {
        id: colorDialog
        color: theme.primary
        title: qsTr("رنگ پروفایل را انتخاب کنید")
        onRejected: color = theme.primary
        onAccepted : {
            theme.primary = color
            settings.setValue("primaryColor", theme.primary)
            theme.setColors()
        }
    }
}
