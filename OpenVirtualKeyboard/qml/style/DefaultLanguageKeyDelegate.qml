/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    Icon {
        anchors.centerIn: parent
        size: parent.height * 0.5
        color: enabled ? "white" : "#302f35"
        name: 'globe'
    }
}


