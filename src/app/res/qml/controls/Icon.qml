// This file is based on the QML Air widget collection by Michael Spencer
// https://github.com/sonrisesoftware/quartz-ui

import QtQuick 2.0

Label {
    smooth: true
    text: icons[name]
    font.pixelSize: iconSize
    font.family: "FontAwesome"
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    property string name: ""
    property var iconSize: units.gu(3)

    property var icons: {
        "": "" ,
                "about": "",
                "bars":"",
                "bell-o": "",
                "bell": "",
                "bitcoin": "",
                "bookmark-o": "",
                "bug": "",
                "calendar": "",
                "calendar-empty": "",
                "cancel": "",
                "check": "",
                "check-circle": "",
                "check-square-o": "",
                "check-square-o": "",
                "chevron-left": "",
                "chevron-right": "",
                "chevron-down": "",
                "circle": "",
                "clip": "",
                "clock": "",
                "clock-o": "",
                "code": "",
                "code-fork": "",
                "cog": "",
                "comment": "",
                "comments": "",
                "confirm": "",
                "dashboard": "",
                "download": "",
                "ellipse-h": "",
                "ellipse-v": "",
                "envelope-o": "",
                "exchange": "",
                "exclamation": "",
                "exclamation-triangle": "",
                "fa-spinner": "",
                "file": "",
                "fullscreen": "",
                "github": "",
                "globe": "",
                "google" : "",
                "grid": "",
                "heart": "",
                "help" : "",
                "inbox": "",
                "lightbulb": "",
                "link": "",
                "list": "",
                "location-shot":"",
                "long-list": "",
                "minus": "",
                "pencil-square-o":"",
                "picture-o":"",
                "picture-shot":"",
                "plus": "",
                "question": "",
                "refresh": "",
                "road": "",
                "save": "",
                "save2": "",
                "search": "",
                "send": "",
                "settings": "",
                "smile-o": "",
                "spinner": "",
                "square-o": "",
                "tasks": "",
                "times": "",
                "times-circle": "",
                "trash": "",
                "user": "",
                "users": "",
                "video-o": "",
                "video-shot": "",
                "voice-o": "",
                "voice-shot": ""
    }
}
