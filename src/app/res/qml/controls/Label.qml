import QtQuick 2.0

Text {
    signal linkedPictureFile(string theLink)
    signal linkedVideoFile(string theLink)
    signal linkedAudioFile(string theLink)

    property bool centered: false
    property string fontSize: "small"

    smooth: true
    color: theme.textColor
    font.family: global.font
    textFormat: Text.PlainText
    font.pixelSize: units.size(fontSize)
    linkColor: Qt.darker(theme.primary, 1.2)
    onLinkActivated: processLink(link)
    anchors.horizontalCenter: centered ? parent.horizontalCenter : undefined

    function processLink(link)
    {
        var subLink = link.substring(link.indexOf(":"))
        switch (link.substring(0,link.indexOf(":"))){
        case "picture":
            openPicture(subLink)
            break
        case "video":
            openVideo(subLink)
            break
        case "audio":
            openAudio(subLink)
            break
        default:
            Qt.openUrlExternally(link)
        }
    }
    function openPicture(link)
    {
        linkedPictureFile(link)
    }
    function openVideo(link)
    {
        linkedVideoFile(link)
    }
    function openAudio(link)
    {
        linkedAudioFile(link)
    }
}
