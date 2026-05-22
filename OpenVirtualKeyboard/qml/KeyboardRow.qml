/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

import QtQuick
import QtQuick.Templates as T
import OpenVirtualKeyboard 1.0
import "style"

Row {
    id: root
    property alias model: repeater.model
    property StyleComponents style
    property real keySpacing: 0
    // Width of one base cell, accounting for the spacing inserted between keys.
    readonly property real baseWidth: repeater.count > 0
                                      ? ( width - keySpacing * ( repeater.count - 1 ) ) / repeater.count
                                      : 0
    property real adaptedStretch: 1.0

    spacing: keySpacing

    Repeater {
        id: repeater

        Loader {
            id: cell
            required property var modelData
            readonly property real __stretch: ( modelData && modelData.stretch !== undefined )
                                              ? modelData.stretch
                                              : 1
            height: root.height
            width: __stretch * root.adaptedStretch * root.baseWidth

            sourceComponent: {
                if ( !modelData )
                    return null
                switch ( modelData.type ) {
                case "key":       return keyC
                case "backspace": return backspaceC
                case "enter":     return enterC
                case "shift":     return shiftC
                case "symbol":    return symbolC
                case "language":  return languageC
                case "space":     return spaceC
                case "hide":      return hideC
                case "page":      return pageC
                case "filler":    return fillerC
                default:          return null
                }
            }

            Component {
                id: keyC
                Key {
                    id: keyButton
                    anchors.fill: parent
                    property string __text: cell.modelData.text !== undefined
                                            ? cell.modelData.text
                                            : ""
                    alternatives: cell.modelData.alternatives !== undefined
                                  ? cell.modelData.alternatives
                                  : ""
                    text: InputContext.shiftOn ? __text.toUpperCase() : __text
                    delegate: root.style.key.createObject( keyButton )
                    type: Key.KeyDefault
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: backspaceC
                Key {
                    id: backspaceButton
                    anchors.fill: parent
                    delegate: root.style.backspaceKey.createObject( backspaceButton )
                    type: Key.Backspace
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: enterC
                Key {
                    id: enterButton
                    anchors.fill: parent
                    readonly property bool enterKeyActionEnabled: InputContext.enterKeyActionEnabled
                    readonly property int enterKeyAction: InputContext.enterKeyAction
                    enabled: enterKeyActionEnabled
                    delegate: root.style.enterKey.createObject( enterButton )
                    type: Key.Enter
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: shiftC
                Key {
                    id: shiftButton
                    anchors.fill: parent
                    readonly property bool shiftOn: InputContext.shiftOn
                    readonly property bool shiftLocked: InputContext.shiftLocked
                    enabled: InputContext.shiftEnabled
                    delegate: root.style.shiftKey.createObject( shiftButton )
                    type: Key.Shift
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: symbolC
                Key {
                    id: symbolButton
                    anchors.fill: parent
                    text: cell.modelData.text !== undefined ? cell.modelData.text : ""
                    delegate: root.style.symbolKey.createObject( symbolButton )
                    type: Key.Symbol
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: languageC
                Key {
                    id: languageButton
                    anchors.fill: parent
                    property var languagesModel: InputContext.layoutProvider.layoutsList
                    property int selectedLanguageIndex: InputContext.layoutProvider.selectedLayoutIndex
                    onSelectedLanguageIndexChanged: InputContext.layoutProvider.selectedLayoutIndex
                                                    = selectedLanguageIndex
                    property T.Popup languageMenu: root.style.languageMenu.createObject( languageButton )
                    type: Key.Language
                    delegate: root.style.languageKey.createObject( languageButton )
                    enabled: InputContext.layoutProvider.layoutsCount > 1
                    onClicked: languageMenu.open()
                    Component.onDestruction: {
                        languageMenu.destroy()
                        delegate.destroy()
                    }
                }
            }

            Component {
                id: spaceC
                Key {
                    id: spaceButton
                    anchors.fill: parent
                    readonly property string selectedLayout: InputContext.layoutProvider.selectedLayout
                    delegate: root.style.spaceKey.createObject( spaceButton )
                    type: Key.Space
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: hideC
                Key {
                    id: hideButton
                    anchors.fill: parent
                    delegate: root.style.hideKey.createObject( hideButton )
                    type: Key.Hide
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: pageC
                Key {
                    id: pageButton
                    anchors.fill: parent
                    text: cell.modelData.text !== undefined ? cell.modelData.text : ""
                    delegate: root.style.nextPageKey.createObject( pageButton )
                    type: Key.NextPage
                    Component.onDestruction: delegate.destroy()
                }
            }

            Component {
                id: fillerC
                Item { anchors.fill: parent }
            }
        }
    }
}
