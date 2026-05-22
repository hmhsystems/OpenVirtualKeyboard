/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick
import QtQml

Rectangle {
    id: bg
    radius: parent.height * 0.12
    color: parent.active ? Qt.rgba(0x80/255, 0xCB/255, 0x4E/255, 0.3) : "#FFFFFF"
    border.color: parent.active ? "#80CB4E" : "#E5E5E5"
    border.width: parent.active ? 2 : 1
    anchors {
        fill: parent
        margins: parent.height * 0.05
    }

    Text {
        id: languageName
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.32
        color: "#8A8FA3"
        text: Qt.locale( parent.parent.selectedLayout ).nativeLanguageName
    }
}
