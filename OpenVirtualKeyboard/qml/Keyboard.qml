/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import OpenVirtualKeyboard 1.0
import "style"

Item {
    id: keyboard
    
    property real contentWidth: width - keyboard.leftPadding - keyboard.rightPadding
    property real padding: 0
   property real leftPadding: Math.max(Screen.pixelDensity  * (InputContext.dpiScale /100), (Window.width - (Screen.pixelDensity * 168 * (InputContext.dpiScale /100)))/2)
    property real rightPadding: Math.max(Screen.pixelDensity  * (InputContext.dpiScale /100) , (Window.width - (Screen.pixelDensity * 168 * (InputContext.dpiScale /100)))/2)
    property real topPadding: 0
    property real bottomPadding: 0
    property KeyboardStyle style: KeyboardStyle {}

    // Number of key rows in every layout (alphabet/symbols/...).
    readonly property int rowCount: 4
    // Height of a single key row. Host applications may override this.
    property real keyHeight: keyboard.contentWidth * 0.085
    // Spacing between keys (applied both horizontally and vertically).
    property real keySpacing: keyboard.keyHeight * 0.1

    objectName: "keyboard"
    //width: parent ? Math.min(Window.width, Screen.pixelDensity * 168) : 0
    width: parent ? Window.width : 0
    // Height is derived from keyHeight + keySpacing. If a host sets `height`
    // explicitly on the Keyboard instance, that binding overrides this default.
    height: rowCount * keyHeight + (rowCount - 1) * keySpacing
            + keyboard.topPadding + keyboard.bottomPadding
    z:1;

    // When the plugin creates the keyboard itself (default/injected mode) it must
    // live in the application overlay. In "direct usage" (externalKeyboard) mode
    // the host nests this component in its own QML, so we must NOT override the
    // parent assigned by that nesting.
    Binding {
        target: keyboard
        property: "parent"
        value: Overlay.overlay
        when: !InputContext.externalMode
    }

    Component.onCompleted: {
        if (InputContext.externalMode)
            InputContext.attachExternalKeyboard( keyboard )
        else
            InputContext.informKeyboardCreated()
    }

    StyleComponents {
        id: styles
        key: Qt.createComponent( style.keyUrl )
        enterKey: Qt.createComponent( style.enterKeyUrl )
        backspaceKey: Qt.createComponent( style.backspaceKeyUrl )
        shiftKey: Qt.createComponent( style.shiftKeyUrl )
        spaceKey: Qt.createComponent( style.spaceKeyUrl )
        hideKey: Qt.createComponent( style.hideKeyUrl )
        symbolKey: Qt.createComponent( style.symbolKeyUrl )
        languageKey: Qt.createComponent( style.languageKeyUrl )
        nextPageKey: Qt.createComponent( style.nextPageKeyUrl )
        keyPreview: Qt.createComponent( style.keyPreviewUrl )
        keyAlternativesPreview: Qt.createComponent( style.keyAlternativesPreviewUrl )
        languageMenu: Qt.createComponent( style.languageMenuUrl )
    }

    MouseArea {
        anchors.fill: parent // to avoid clicks propagate through the background
    }

    // Loader {
    //     anchors.fill: parent
    //     source: style.backgroundUrl
    // }

    Item {
        id: keyboardContent
        anchors {
            fill: parent
            margins: keyboard.padding
            topMargin: keyboard.topPadding
            bottomMargin: keyboard.bottomPadding
            leftMargin: keyboard.leftPadding
            rightMargin: keyboard.rightPadding
        }

        Item {
            id: layoutsContainer
            anchors.fill: parent

            KeyboardLayout {
                visible: InputContext.layoutType == KeyboardLayoutType.Alphabet
                anchors.fill: parent
                keyStyles: styles
                keySpacing: keyboard.keySpacing
                layoutModel: InputContext.layoutProvider.alphabetModel
            }

            KeyboardLayout {
                visible: InputContext.layoutType == KeyboardLayoutType.Symbols
                anchors.fill: parent
                keyStyles: styles
                keySpacing: keyboard.keySpacing
                layoutModel: InputContext.layoutProvider.symbolsModel
            }

            KeyboardLayout {
                visible: InputContext.layoutType == KeyboardLayoutType.Dial
                anchors.fill: parent
                keyStyles: styles
                keySpacing: keyboard.keySpacing
                layoutModel: InputContext.layoutProvider.dialModel
            }

            KeyboardLayout {
                visible: InputContext.layoutType == KeyboardLayoutType.Numbers
                anchors.fill: parent
                keyStyles: styles
                keySpacing: keyboard.keySpacing
                layoutModel: InputContext.layoutProvider.numbersModel
            }

            KeyboardLayout {
                visible: InputContext.layoutType == KeyboardLayoutType.Digits
                anchors.fill: parent
                keyStyles: styles
                keySpacing: keyboard.keySpacing
                layoutModel: InputContext.layoutProvider.digitsModel
            }
        }

        KeyPressInterceptor {
            objectName: "keyInterceptor"
            anchors.fill: parent
            forwardTo: layoutsContainer
        }

        KeyPreview {
            id: keyPreview
            objectName: "keyPreview"
            delegate: styles.keyPreview.createObject( keyPreview )
        }

        KeyAlternativesPreview {
            id: alternativesPreview
            objectName: "keyAlternatives"
            uppercase: InputContext.shiftOn
            delegate: styles.keyAlternativesPreview.createObject( alternativesPreview )
        }
    }
}


