/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Rectangle {
    radius: parent.height * 0.12
    color: parent.active ? parent.colors.keyPressedBackground
                         : parent.enabled ? parent.colors.specialKeyBackground
                                          : parent.colors.specialKeyDisabledBackground
    border.color: parent.active ? parent.colors.accent : parent.colors.keyBorder
    border.width: parent.active ? 2 : 1
    anchors.fill: parent
}
