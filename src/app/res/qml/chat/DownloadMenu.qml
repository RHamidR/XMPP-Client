import "../core"
import "../controls"

import QtQuick 2.0
import QtQuick.Controls 1.0 as Controls

Menu {
    id: downloadMenu

    property int activeDownloads: 0

    // This function is used when the user exits the Chat room
    function exit() {
        close()
        activeDownloads = 0
        downloadsModel.clear()
    }

    function openUrl(url) {
        Qt.openUrlExternally(url)
    }

    // Calulate the width and height of the popover
    height: column.height + units.gu(2.2)
    width: noDownloadsLabel.paintedWidth + units.scale(42)

    Behavior on width {NumberAnimation{duration: 200}}

    // Create the column with the downloads
    data: Column {
        id: column
        spacing: units.scale(6)
        anchors.centerIn: parent
        width: parent.width
        height: downloadsScrollView.height + titleRectangle.height + spacing

        // Create a rectangle with the title of the popover and a clear button
        Rectangle {
            id: titleRectangle
            width: parent.width
            color: "transparent"
            height: units.scale(42)
            anchors.horizontalCenter: parent.horizontalCenter

            // Create the title
            Label {
                id: downloadsLabel
                text: qsTr("Downloads")
                anchors.left: parent.left
                anchors.margins: units.scale(12)
                anchors.verticalCenter: parent.verticalCenter
            }

            // Create the button
            Button {
                text: qsTr("Clear")
                height: units.scale(24)
                width: units.scale(58)
                anchors.right: parent.right
                anchors.margins: units.scale(12)
                enabled: downloadsModel.count > 0
                anchors.verticalCenter: parent.verticalCenter
                onClicked: downloadsModel.clearFinishedDownloads()
            }

            // Create a separator
            Rectangle {
                height: units.scale(1)
                color: theme.borderColor
                anchors.bottom: parent.bottom
                width: parent.width - units.scale(24)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        // Create a scroll view with all active downloads
        Controls.ScrollView {
            id: downloadsScrollView
            anchors.left: parent.left
            anchors.right: parent.right

            height: {
                if (downloadsModel.count > 0)
                    return downloadsListView.contentHeight > app.height * 0.4 ?
                                app.height * 0.4 : downloadsListView.contentHeight
                else
                    return noDownloadsLabel.height
            }

            // Create a label telling the user that there are no downloads
            Rectangle {
                color: "transparent"
                id: noDownloadsLabel
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                opacity: downloadsModel.count > 0 ? 0 : 1
                height: downloadsModel.count > 0 ? 0 : units.scale(56)

                // Add the paintetWidth property
                property alias paintedWidth: nDLabel.paintedWidth

                // Generate the UI effects
                Behavior on height {NumberAnimation{ duration: 200 }}
                Behavior on opacity {NumberAnimation{ duration: 200 }}

                // Generate the actual label
                Label {
                    id: nDLabel
                    fontSize: "large"
                    width: paintedWidth
                    anchors.centerIn: parent
                    color: theme.chatNotification
                    text: qsTr("There are no downloads")
                }
            }

            // Create a list view that will display every download
            ListView {
                id: downloadsListView
                anchors.horizontalCenter: parent.horizontalCenter

                // Create a new download when the bridge emits the newDownload() signal
//                Connections {
//                    target: bridge
//                    onNewDownload: {
//                        downloadsModel.append({"file": file, "size": size, "sender": name})
//                    }
//                }

                // Create the list model with all the downloads, this list is used to draw the download rectangles
                model: ListModel {
                    id: downloadsModel

                    // Code to clear all finished downloads and show a notification
                    signal clearDownloads
                    function clearFinishedDownloads() {
                        // Create a int with all the downloads prior to cleaning them
                        var previousCount = count

                        // Clear all finished downloads
                        clearDownloads()

                        // Tell the user that there are no current downloads
                        if (previousCount == 0)
                            notification.show("There are no downloads")

                        // Show a notification informing the user that there are no finished downloads
                        else if (previousCount - count == 0)
                            notification.show("There are no finished downloads")

                        // Tell the user how many downloads we cleared
                        else
                            notification.show(qsTr("Cleared %1 finished downloads").arg(previousCount - count))
                    }
                }

                // Create the rectangle that holds the download information
                delegate: Rectangle {
                    id: downloadItem

                    // Set the size of the rectangle
                    width: parent.width - units.scale(2)
                    height: downloadIcon.height + fNameLabel.paintedHeight +
                            progressBar.height + progressLabel.paintedHeight

                    // Make the rectangle a bit rounded
                    radius: units.scale(3)

                    // Make the download item hoverable
                    color: downloadMouseArea.containsMouse ? theme.buttonBackgroundHover : "transparent"

                    // Define the width of the progress bar
                    property int controlWidth: (width - units.scale(12)) * 0.75 - units.scale(4)

                    // Tell the user that the download started
                    Component.onCompleted: {
                        activeDownloads += 1

                        if (downloadMenu.visible) {
                            downloadMenu.close()
                            downloadMenu.open(app.isMobile() ? lDownloadButton : rDownloadButton)
                        }

                        notification.show(qsTr("Download of %1 started").arg(file))
                    }

                    // Calculates the correct unit to display a size in bytes
                    function getUnits(bytes) {
                        if (bytes === 0)
                            return '0 Bytes';

                        var k = 1000;
                        var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
                        var i = Math.floor(Math.log(bytes) / Math.log(k));

                        return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
                    }

                    property bool finished: false

                    // Update the progress of the download
                    Connections {
                        target: bridge

                        // Finish the download and hide the progress bar
                        onDownloadComplete: {
                            if (name == sender && file == file) {
                                finished = true
                                activeDownloads -= 1
                                progressBar.height = 0
                                progressBar.visible = false
                                downloadMouseArea.enabled = true
                                progressLabel.text = downloadItem.getUnits(size) + " - " + sender

                                if (downloadMenu.visible) {
                                    downloadMenu.open(app.isMobile() ? lDownloadButton : rDownloadButton)
                                }

                                // Tell the user that the download has finished
                                notification.show(qsTr("Download of %1 finished!").arg(file))
                            }
                        }

                        // Update the value of the progress bar
                        onUpdateProgress: {
                            if (name == sender && file == file)
                                progressBar.value = progress
                        }
                    }

                    // Remove the rectangle if the user clicks "clear"
                    Connections {
                        target: downloadsModel
                        onClearDownloads: finished ? downloadsModel.remove(index) : undefined
                    }

                    // Create a row with the icon and the download information
                    Row {
                        anchors.fill: parent
                        spacing: units.scale(6)
                        anchors.margins: units.scale(8)
                        anchors.horizontalCenter: parent.horizontalCenter

                        // Create an icon of the file
                        Image {
                            width: height
                            id: downloadIcon
                            height: units.scale(48)
                            source: "qrc:/faces/system/package.png"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // Create the progress bar with information
                        Column {
                            spacing: parent.spacing
                            anchors.verticalCenter: parent.verticalCenter

                            // Create a label with the name of the file
                            Label {
                                text: file
                                id: fNameLabel
                                scale: getScale()
                                width: parent.width
                                transformOrigin: Item.TopLeft
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                                // Resize the label so that it fits inside the rectangle.
                                // However, we need to make sure that the text stays visible,
                                // so if the scaler than 0.65, we will use word wrapping
                                function getScale() {
                                    var c_scale = 1

                                    if (paintedWidth > width) {
                                        c_scale = width / paintedWidth

                                        if (c_scale < 0.65)
                                            c_scale = 0.65
                                    }

                                    return c_scale
                                }
                            }

                            // Create a progress bar showing the progress of the download
                            ProgressBar {
                                id: progressBar
                                implicitWidth: downloadItem.controlWidth

                                valueText: {
                                    if (!size > 0)
                                        return  qsTr("Downloading...")
                                    else
                                        return value + "%"
                                }
                            }

                            // Create a label with the progress of the file
                            Label {
                                id: progressLabel
                                width: progressBar.width
                                font.pixelSize: units.scale(9)
                                color: theme.borderColorDisabled
                                //implicitWidth: downloadItem.controlWidth
                                scale: paintedWidth > width ? (width / paintedWidth) : 1
                                transformOrigin: Item.TopLeft
                                text: {
                                    if (size > 0)
                                        return downloadItem.getUnits((size * progressBar.value) / 100) +
                                                " of " + downloadItem.getUnits(size) + " - " + sender
                                    else
                                        return "Unknown size - " + sender
                                }
                            }
                        }
                    }

                    // Create a mouse area that will help the user open the downloaded file
                    MouseArea {
                        enabled: false
                        anchors.fill: parent
                        id: downloadMouseArea

                        // Enable the hover feature only in desktop devices
                        hoverEnabled: !app.isMobile

                        // Open the file
                        onClicked: openUrl("file:///" + bridge.getDownloadPath() + file)
                    }
                }
            }
        }
    }
}
