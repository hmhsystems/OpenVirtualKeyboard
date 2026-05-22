/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Rectangle {
    id: key
    radius: parent.height * 0.12
    color: parent.enabled ? parent.active ? Qt.darker( "#2E4B9E", 1.15 ) : "#2E4B9E"
                          : Qt.lighter( "#2E4B9E", 1.6 )
    border.color: parent.active ? "#80CB4E" : "transparent"
    border.width: parent.active ? 2 : 0
    anchors {
        fill: parent
        margins: parent.height * 0.05
    }

    Icon {
        id: icon
        anchors.centerIn: parent
        size: parent.height * 0.45
        color: key.parent.enabled ? "white" : "#E5E5E5"
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
