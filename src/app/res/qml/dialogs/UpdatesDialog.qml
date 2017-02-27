import QtQuick 2.0
import "../controls"
//  ========================================= Not Implemented
MessageBox {
    id: _updates
    icon: "refresh"
    title: qsTr("Check for updates")

    property bool updates_available
    property bool notify_updates

    Connections {
        target: bridge

        onUpdateAvailable: {
            updates_available = newUpdate

            if (updates_available) {
                updatesAvailable(version)
                return
            }

            if (notify_updates)
                latestVersion()
        }
    }
/*
    Component.onCompleted: {
        if (settings.notifyUpdates())
            checkForUpdates(false)
    }

    function checkForUpdates(notify) {
        notify_updates = notify
        bridge.checkForUpdates()
    }

    function updatesAvailable(new_version) {
        _updates.caption = qsTr("A new version of Messenger (" + new_version + ") is available to download")
        _updates.details = qsTr("Would you like to download it?")

        _updates.open()
    }

    function latestVersion() {
        _updates.caption = qsTr("There are no updates available")
        _updates.details = qsTr("You are running the latest version of Messenger")

        _updates.open()
    }
*/
    data: Item {
        property int da_button_width: {
            return _yes_button.width > _no_button.width ?
                        _yes_button.width : _no_button.width
        }

        Button {
            id: _yes_button
            anchors.centerIn: parent
            anchors.verticalCenterOffset: _updates.updates_available ? units.gu(3) : units.gu(6)
            onClicked: _updates.updates_available ? bridge.downloadUpdates() : _updates.close()
            text: _updates.updates_available ? qsTr("Yes, download the new version") : qsTr("Close")

            Component.onCompleted: {
                width = parent.da_button_width
            }
        }

        Button {
            id: _no_button
            visible: updates_available
            y: _yes_button.y + height + units.gu(1)
            text: qsTr("No (and don't remind me again)")
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                _updates.close()
                settings.setValue("notifyUpdates", false)
            }

            Component.onCompleted: {
                width = parent.da_button_width
            }
        }
    }
}
