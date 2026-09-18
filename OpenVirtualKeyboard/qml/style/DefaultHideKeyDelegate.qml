/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    id: key

    Icon {
        anchors {
            centerIn: parent
            verticalCenterOffset: -parent.height * 0.10
        }
        size: parent.height * 0.42
        color: key.parent.colors.keyText
        name: 'keyboard'
    }

    Icon {
        anchors {
            centerIn: parent
            verticalCenterOffset: parent.height * 0.22
        }
        size: parent.height * 0.22
        color: key.parent.colors.keyText
        name: 'down-open'
    }
}
