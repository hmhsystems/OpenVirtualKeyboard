/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Rectangle {
    id: key
    radius: parent.height * 0.12
    color: parent.enabled ? parent.active ? parent.colors.enterKeyPressedBackground
                                         : parent.colors.enterKeyBackground
                          : parent.colors.enterKeyDisabledBackground
    border.color: parent.active ? parent.colors.accent : "transparent"
    border.width: parent.active ? 2 : 0
    anchors.fill: parent

    Icon {
        id: icon
        anchors.centerIn: parent
        size: parent.height * 0.45
        color: key.parent.enabled ? key.parent.colors.enterKeyText
                                  : key.parent.colors.enterKeyDisabledText
        name: {
            if (key.parent.enterKeyAction === Qt.EnterKeySearch)
                return "search"
            else if (key.parent.enterKeyAction === Qt.EnterKeyDone)
                return "ok"
            else if (key.parent.enterKeyAction === Qt.EnterKeyGo)
                return "link-ext"
            else if (key.parent.enterKeyAction === Qt.EnterKeySend)
                return "paper-plane"
            else if (key.parent.enterKeyAction === Qt.EnterKeyNext)
                return "right-open"
            else if (key.parent.enterKeyAction === Qt.EnterKeyPrevious)
                return "left-open"
            else
                return "level-down"
        }
        rotation: key.parent.enterKeyAction === Qt.EnterKeyDefault
                  || key.parent.enterKeyAction === Qt.EnterKeyReturn ? 90 : 0
    }
}
