/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick

// Colors used by the default key delegates, previews and language menu.
// Host applications override them through the Keyboard's `colors` group,
// e.g. `colors.keyBackground: "#383838"`. Delegates read them as `parent.colors`.
QtObject {
    // highlight color: pressed key border, shift on/locked, previews
    property color accent: "#80CB4E"

    // regular keys (letters and space)
    property color keyBackground: "#FFFFFF"
    property color keyPressedBackground: Qt.rgba( accent.r, accent.g, accent.b, 0.3 )
    property color keyBorder: "#E5E5E5"
    property color keyText: "#1A2238"
    property color keyDisabledText: "#BFBFBF"
    property color spaceKeyText: "#8A8FA3"

    // special keys (shift, backspace, symbols, language, next page, hide)
    property color specialKeyBackground: "#F1F9EB"
    property color specialKeyDisabledBackground: "#F7F7F7"

    // enter key
    property color enterKeyBackground: "#2E4B9E"
    property color enterKeyPressedBackground: Qt.darker( enterKeyBackground, 1.15 )
    property color enterKeyDisabledBackground: Qt.lighter( enterKeyBackground, 1.6 )
    property color enterKeyText: "#FFFFFF"
    property color enterKeyDisabledText: "#E5E5E5"

    // key preview and alternatives preview
    property color previewBackground: "#FFFFFF"
    property color previewText: "#1A2238"

    // language menu
    property color languageMenuBackground: "#EEEEEE"
    property color languageMenuBorder: "#CCCCCC"
    property color languageMenuText: "#000000"
    property color languageMenuSelected: "#DDDDDD"
    property color languageMenuPressed: "#D6D6D6"
}
