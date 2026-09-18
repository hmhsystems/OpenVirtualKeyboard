/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    id: key

    Icon {
        id: icon
        anchors.centerIn: parent
        size: parent.height * 0.45
        color: key.parent.enabled ? key.parent.shiftOn ? key.parent.colors.accent
                                                        : key.parent.colors.keyText
                                  : key.parent.colors.keyDisabledText
        name: 'up'
    }

    Rectangle {
        height: parent.height * 0.08
        width: height
        radius: height / 2
        color: key.parent.enabled ? key.parent.colors.accent : key.parent.colors.keyDisabledText
        visible: key.parent.shiftLocked
        anchors {
            left: icon.left
            top: icon.top
        }
    }
}
