/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    Icon {
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.10
        }
        size: parent.height * 0.42
        color: "#1A2238"
        name: 'keyboard'
    }

    Icon {
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.22
        }
        size: parent.height * 0.22
        color: "#1A2238"
        name: 'down-open'
    }
}
