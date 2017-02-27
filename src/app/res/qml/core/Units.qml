import QtQuick 2.0

QtObject {
    id: _units

    function scale(number) {
        return device.ratio(number)
    }

    function gu(number) {
        return units.scale(8 * number)
    }

    function size(string) {
        if (string === "xx-large")     return gu(2.7)
        else if (string === "x-large") return gu(2.4)
        else if (string === "large")   return gu(2.2)
        else if (string === "medium")  return gu(1.9)
        else if (string === "small")   return gu(1.6)
        else if (string === "x-small") return gu(1.2)
        else {
            console.log("Warning: " + string + " is not a valid size!")
            return gu(1.6)
        }
    }
}
