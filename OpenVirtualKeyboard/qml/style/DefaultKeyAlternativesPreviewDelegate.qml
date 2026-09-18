/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

Item {
    id: key

    readonly property real margin: parent.keyHeight * 0.05

    height: parent.keyHeight * 2.4
    width: (parent.keyWidth - 2 * margin) * parent.alternatives.length + 2 * margin

    Rectangle {
        anchors {
            fill: parent
            margins: key.margin
        }
        radius: key.parent.keyWidth * 0.12
        color: key.parent.colors.previewBackground
        border.color: key.parent.colors.accent
        border.width: 2

        ListView {
            anchors.fill: parent
            orientation: ListView.Horizontal
            interactive: false
            model: key.parent.alternatives
            currentIndex: key.parent.alternativeIndex
            delegate: Item {
                width: key.parent.keyWidth - (key.margin * 2)
                height: key.parent.keyHeight * 2.4 - (key.margin * 2)

                Text {
                    text: modelData
                    color: key.parent.colors.previewText
                    font.pixelSize: key.parent.keyHeight * 0.44
                    font.bold: true
                    anchors {
                        centerIn: parent
                        verticalCenterOffset: -(key.parent.keyHeight * 0.68)
                    }
                }
            }
            highlightMoveVelocity: -1
            highlight: Rectangle {
                color: key.parent.colors.accent
                opacity: 0.25
                radius: width * 0.12
            }
        }
    }
}
