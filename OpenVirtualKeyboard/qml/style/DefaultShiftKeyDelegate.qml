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
        color: key.parent.enabled ? key.parent.shiftOn ? "#80CB4E" : "#1A2238"
                                  : "#BFBFBF"
        name: 'up'
    }

    Rectangle {
        height: parent.height * 0.08
        width: height
        radius: height / 2
        color: key.parent.enabled ? "#80CB4E" : "#BFBFBF"
        visible: key.parent.shiftLocked
        anchors {
            left: icon.left
            top: icon.top
        }
    }
}
