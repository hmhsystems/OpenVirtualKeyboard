/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick
import QtQuick.Layouts
import OpenVirtualKeyboard 1.0
import "style"

StackLayout {
    id: keyboardLayout

    property StyleComponents keyStyles
    property KeyboardLayoutModel layoutModel
    property real keySpacing: 0
    readonly property int rowCount: 4
    // Row height so that rowCount rows + (rowCount-1) gaps exactly fill the height.
    readonly property real rowHeight: ( height - ( rowCount - 1 ) * keySpacing ) / rowCount

    currentIndex: layoutModel.currentPage
    onVisibleChanged: layoutModel.currentPage = 0

    Repeater {
        model: layoutModel.pages
        delegate: Column {
            spacing: keyboardLayout.keySpacing
            Layout.fillHeight: true
            Layout.fillWidth: true

            KeyboardRow {
                id: row1
                style: keyboardLayout.keyStyles
                keySpacing: keyboardLayout.keySpacing
                model: modelData.length >= 1 ? modelData[0] : null
                adaptedStretch: layoutModel.adaptedStretchRow1
                height: keyboardLayout.rowHeight
                width: parent.width
            }

            KeyboardRow {
                id: row2
                style: keyboardLayout.keyStyles
                keySpacing: keyboardLayout.keySpacing
                model: modelData.length >= 2 ? modelData[1] : null
                adaptedStretch: layoutModel.adaptedStretchRow2
                height: keyboardLayout.rowHeight
                width: parent.width
            }

            KeyboardRow {
                id: row3
                style: keyboardLayout.keyStyles
                keySpacing: keyboardLayout.keySpacing
                model: modelData.length >= 3 ? modelData[2] : null
                adaptedStretch: layoutModel.adaptedStretchRow3
                height: keyboardLayout.rowHeight
                width: parent.width
            }

            KeyboardRow {
                id: row4
                style: keyboardLayout.keyStyles
                keySpacing: keyboardLayout.keySpacing
                model: modelData.length >= 4 ? modelData[3] : null
                adaptedStretch: layoutModel.adaptedStretchRow4
                height: keyboardLayout.rowHeight
                width: parent.width
            }
        }
    }
}


