/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Rectangle {
    id: key
    radius: height * 0.12
    color: parent.active ? parent.colors.keyPressedBackground : parent.colors.keyBackground
    border.color: parent.active ? parent.colors.accent : parent.colors.keyBorder
    border.width: parent.active ? 2 : 1
    anchors.fill: parent

    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.42
        font.bold: true
        color: key.parent.colors.keyText
        text: parent.parent.text
    }
}
