import "../core"
import "../controls"

import QtQuick 2.0
// ================================================= Not Implemented
Dialog {
    id: _news
    title: qsTr("اخبار")

    contents: Item {
        anchors.centerIn: parent

        Icon {
            name: "fa-spinner"
            iconSize: units.gu(12)
            color: theme.textColor
            anchors.centerIn: parent
            onRotationChanged: rotation += 60
            Component.onCompleted: rotation = 1
            Behavior on rotation {NumberAnimation{}}
        }
    }
}
