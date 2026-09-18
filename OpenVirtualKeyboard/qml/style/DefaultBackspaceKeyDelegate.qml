/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

DefaultSpecialKeyDelegate {
    id: key

    Icon {
        anchors.centerIn: parent
        size: parent.height * 0.45
        color: key.parent.colors.keyText
        name: 'cancel-alt'
    }
}
