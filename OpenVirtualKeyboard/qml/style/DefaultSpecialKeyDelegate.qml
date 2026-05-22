/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Rectangle {
    radius: parent.height * 0.12
    color: parent.active ? Qt.rgba(0x80/255, 0xCB/255, 0x4E/255, 0.3)
                         : parent.enabled ? "#F1F9EB" : "#F7F7F7"
    border.color: parent.active ? "#80CB4E" : "#E5E5E5"
    border.width: parent.active ? 2 : 1
    anchors.fill: parent
}
