import QtQuick 2.0

QtObject {

    signal themeChanged()

    property string info: "#5bc0de"
    property string danger: "#f7846a"
    property string success: "#5cb85c"
    property string warning: "#ffc94e"


    property string notificationText: "#000000"
    property string notificationBorder: "#f0c36e"
    property string notificationBackground:"#f9edbe"

    property string panel: "#FFFFFF"
    property string dialog:"#FFFFFF"
    property string shadow: "#666666"
    property string chatText: "#333333"
    property string iconColor: "#5A5E67"
    property string textColor: "#5A5E67"
    property string background: "#F8F8F8"
    property string borderColor: "#D4DCE3"
    property string logoSubtitle: "#4C505A"
    property string chatDateTimeText: "#415F9B"
    property string chatNotification: "#7F7F7F"
    property string textFieldBackground: "#FFFFFF"
    property string textFieldForeground: "#5A5E67"
    property string textFieldPlaceholder: "#AAAAAA"

    property string primary
    property string secondary
    property string primaryForeground
    property string secondaryForeground

    Component.onCompleted: setColors()

    function setColors() {
        primary = settings.customColor() ? settings.primaryColor() : "#666666"

        secondary = getSecondaryColor(primary)
        primaryForeground = getForegroundColor(primary)
        secondaryForeground = getForegroundColor(secondary)

        themeChanged()
    }

    function getLuminance(string) {
        // Remove the "#" from hexadecimal color
        var color = string.replace("#", "")

        // Separate the hexadecimal values for Red, Green and Blue
        var r = color.substring(0, 2)
        var g = color.substring(2, 4)
        var b = color.substring(4, 6)

        // Convert hexadecimal numbers to decimals
        r = parseInt(r, 16)
        g = parseInt(g, 16)
        b = parseInt(b, 16)

        // Calculate the perspective luminance
        return 1 - ( 0.299 * r + 0.587 * g + 0.114 * b) / 255
    }

    function getSecondaryColor(string) {
        // Remove the "#" from hexadecimal color
        var color = string.replace("#", "")

        // Separate the hexadecimal values for Red, Green and Blue
        var r = color.substring(0, 2)
        var g = color.substring(2, 4)
        var b = color.substring(4, 6)

        // Convert hexadecimal numbers to decimals
        r = parseInt(r, 16)
        g = parseInt(g, 16)
        b = parseInt(b, 16)

        // Remove any "extreme" colors for a softer experience and ensure that the
        // obtained colors are valid
        r = optimizeColor(r)
        g = optimizeColor(g)
        b = optimizeColor(b)

        // Convert decimal to hexadecimal
        r = r.toString(16)
        g = g.toString(16)
        b = b.toString(16)

        // Create the color
        color = "#" + r + g + b
        return getLuminance(color) > 0.24 ? Qt.darker(color, 1.125) : Qt.lighter(color, 1.125)
    }

    function optimizeColor(color) {
        // Ensure that we do not crash the program
        // if the color is 0
        if (color <= 0) {
            color = 16
        }

        // Ensure that the color is not too dark
        if (color < 24) {
            while (color < 24) {
                color = color * 2.4
            }
        }

        // Ensure that the color is not too bright
        if (color > 216) {
            while (color > 216) {
                color = color * 0.75
            }
        }

        // Round the obtained color to the nearest integer
        return Math.round(color)
    }

    function getForegroundColor(color) {
        // Return a foreground color based on the luminance of the
        // background color
        return getLuminance(color) > 0.24 ? "#FFFFFF" : "#5A5E67"
    }
}
