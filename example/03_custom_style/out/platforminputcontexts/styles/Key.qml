import QtQuick
import "components"

KeyBase {
    id: key

    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.36
        color: "black"
        text: key.parent.text
    }
}

