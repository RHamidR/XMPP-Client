import "../core"
import "../controls"

import QtQuick 2.0

Menu {
    id: _avatarMenu

    height: (_sharePicture.height * 2) + (_grid.spacing * 4)
    width:  (_sharePicture.width * 4) + (_grid.spacing * 7)

    signal sharingGaleryImage()
    signal sharingGaleryVideo()
    signal sharingGaleryAudio()
    signal sharingMyLocation()
    signal sharingRecordedImage()
    signal sharingRecordedVideo()
    signal sharingRecordedAudio()
    signal sharingMyPaint()

    data: NiceScrollView {
        anchors.fill: parent
        anchors.centerIn: parent

        Grid {
            id: _grid
            anchors.fill: parent
            columns: (parent.width / _sharePicture.width) / 2
            spacing: 5
            //cellWidth: units.scale(56)
            //cellHeight: units.scale(56)

            Rectangle {
                id:     _sharePicture
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "picture-o"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingGaleryImage()
                    }
                }
            }



            Rectangle {
                id:     _shareVideo
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "video-o"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingGaleryVideo()
                    }
                }
            }



            Rectangle {
                id:     _shareVoice
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "voice-o"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingGaleryAudio()
                    }
                }
            }



            Rectangle {
                id:     _shareLocation
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "location-shot"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingMyLocation()
                    }
                }
            }



            Rectangle {
                id:     _sharePictureRec
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "picture-shot"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingRecordedImage()
                    }
                }
            }



            Rectangle {
                id:     _shareVideoRec
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "video-shot"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingRecordedVideo()
                    }
                }
            }



            Rectangle {
                id:     _shareVoiceShot
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "voice-shot"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingRecordedAudio()
                    }
                }
            }


            Rectangle {
                id:     _shareHandWrite
                width: height
                color: "transparent"
                height: units.scale(52)

                Button {
                    height: width
                    width: units.scale(48)
                    anchors.centerIn: parent
                    iconName: "pencil-square-o"
                    onClicked: {
                        _avatarMenu.toggle(0)
                        sharingMyPaint()
                    }
                }
            }
        }
    }
}
