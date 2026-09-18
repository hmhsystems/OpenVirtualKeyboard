/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Templates as T

T.Popup {
    id: popup

    width: parent.height * 4.5
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    // open above the language key instead of over the keyboard rows below it
    y: -height
    margins: 0
    verticalPadding: 3
    z: 2;

    // Popups share the window overlay and are stacked by z. When the keyboard
    // itself lives inside a Popup, the menu must be stacked above that popup,
    // otherwise it is drawn behind the keyboard.
    onAboutToShow: z = Math.max( 2, hostPopupZ() + 1 )

    function hostPopupZ() {
        const overlay = T.Overlay.overlay
        let item = popup.parent
        while (item && item.parent && item.parent !== overlay)
            item = item.parent
        return item && item.parent === overlay ? item.z : 0
    }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    background: Rectangle {
        width: popup.width
        implicitHeight: 40
        radius: 3
        color: popup.parent.colors.languageMenuBackground
        border.width: 1
        border.color: popup.parent.colors.languageMenuBorder
    }

    contentItem: ListView {
        width: popup.width
        implicitHeight: contentHeight
        model: popup.parent.languagesModel
        interactive: Window.window ? contentHeight > Window.window.height : false
        clip: true
        delegate: T.ItemDelegate {
            id: item
            width: parent?.width
            height: popup.parent.height * 0.86
            leftPadding: 12
            leftInset: 1
            rightInset: 1

            contentItem: Text {
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: Qt.locale( modelData ).nativeLanguageName.length > 0
                      ? Qt.locale( modelData ).nativeLanguageName
                      : modelData
                font.pixelSize: popup.parent.height * 0.36
                color: popup.parent.colors.languageMenuText
            }

            background: Rectangle {
                width: parent.width
                height: parent.height
                visible: item.down || index === popup.parent.selectedLanguageIndex
                color: item.down
                       ? popup.parent.colors.languageMenuPressed
                       : index === popup.parent.selectedLanguageIndex
                         ? popup.parent.colors.languageMenuSelected
                         : "transparent"
            }
            onClicked: {
                popup.parent.selectedLanguageIndex = index
                popup.close()
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}



