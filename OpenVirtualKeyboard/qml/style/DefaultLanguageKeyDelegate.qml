/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    Icon {
        anchors.centerIn: parent
        size: parent.height * 0.45
        color: enabled ? "#1A2238" : "#BFBFBF"
        name: 'globe'
    }
}
