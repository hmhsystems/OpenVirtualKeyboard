/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.32
        font.bold: true
        color: "#1A2238"
        text: parent.parent.text
    }
}
