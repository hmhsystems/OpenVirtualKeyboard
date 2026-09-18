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
    color: parent.active ? parent.colors.keyPressedBackground : parent.colors.keyBackground
    border.color: parent.active ? parent.colors.accent : parent.colors.keyBorder
    border.width: parent.active ? 2 : 1
    anchors.fill: parent

    Text {
        id: languageName
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.32
        color: bg.parent.colors.spaceKeyText
        text: Qt.locale( parent.parent.selectedLayout ).nativeLanguageName
    }
}
