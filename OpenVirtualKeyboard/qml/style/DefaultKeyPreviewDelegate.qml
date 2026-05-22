/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Item {
    id: key

    height: parent.keyHeight * 2.4
    width: parent.keyWidth

    Rectangle {
        anchors {
            fill: parent
            margins: key.parent.keyHeight * 0.05
        }
        radius: key.parent.keyHeight * 0.12
        color: "#FFFFFF"
        border.color: "#80CB4E"
        border.width: 2

        Text {
            anchors {
                centerIn: parent
                verticalCenterOffset: -(key.parent.keyHeight * 0.68)
            }
            font.pixelSize: key.parent.keyHeight * 0.48
            font.bold: true
            text: key.parent.keyText
            color: "#1A2238"
        }
    }
}
