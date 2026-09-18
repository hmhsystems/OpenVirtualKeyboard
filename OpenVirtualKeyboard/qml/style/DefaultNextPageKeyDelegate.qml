/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    id: key

    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.32
        font.bold: true
        color: key.parent.colors.keyText
        text: key.parent.text
    }
}
