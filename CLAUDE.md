# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

OpenVirtualKeyboard is a Qt Quick virtual keyboard implemented as a `QPlatformInputContextPlugin`. It is loaded **in-process** by the host Qt application via the `QT_IM_MODULE` environment variable (e.g. `QT_IM_MODULE=openvirtualkeyboard`), not as a standalone app. Optional features are tacked onto that var as colon-separated suffixes: `:animateRollout:ownWindow:immediateLoading:noContentScrolling`.

Target Qt version: **Qt 6.8+** (the current CMake build). The legacy `.pro` files still claim Qt 5.12+ but the active build is CMake/Qt6 — prefer CMake when changing build inputs.

## Build

CMake is the source of truth ([CMakeLists.txt](CMakeLists.txt)). The qmake `.pro` files (`OpenVirtualKeyboard/OpenVirtualKeyboard.pro`, `example/*/*.pro`) are kept in parallel — if you add or remove a `.cpp`/`.h`, update **both** so the qmake-based examples still build.

The plugin must land in a `platforminputcontexts/` directory next to the host executable. CMake already enforces this via `LIBRARY_OUTPUT_DIRECTORY`/`RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/platforminputcontexts`. The output name is forced to `openvirtualkeyboard` with no `lib` prefix.

Typical build (MinGW shown — kit names live under `build/`):
```
cmake -S . -B build -G "MinGW Makefiles"
cmake --build build
```

### Examples

Four examples under `example/0{1..4}_*/`. Each is a separate qmake project. Before running, the example's `out/platforminputcontexts/` must contain the freshly built plugin DLL/SO — `example/shared/examples_shared.h` defines `CHECK_PLUGIN_IS_PREPARED`, a macro every example calls at startup that probes the plugin metadata for the sentinel key `"ovk-magic-key"` (declared in [OpenVirtualKeyboard.json](OpenVirtualKeyboard/OpenVirtualKeyboard.json)) and `std::exit`s if missing. If an example dies immediately, the plugin isn't deployed where it expects.

## Tests

There is no test suite. Validation is manual via the examples.

## Architecture

### Plugin entry point and lifecycle

1. Qt loads the plugin (`OpenVirtualKeyboardPlugin::create`, [openvirtualkeyboardplugin.h](OpenVirtualKeyboard/openvirtualkeyboardplugin.h)) when `QT_IM_MODULE` matches `"openvirtualkeyboard"`.
2. The plugin returns an `OpenVirtualKeyboardInputContext` — this is the bridge between Qt's input-method machinery and the QML keyboard.
3. `KeyboardCreator` ([keyboardcreator.h](OpenVirtualKeyboard/keyboardcreator.h)) is a `QQmlIncubator` that asynchronously instantiates `qrc:/ovk/qml/Keyboard.qml` (or `KeyboardWindow.qml` when `ownWindow` is set). Loading is **lazy by default**; `immediateLoading` forces creation up front.
4. Once incubated, key events flow QML → `KeyPressInterceptor` → `OpenVirtualKeyboardInputContext` → Qt focus object via `QInputMethodEvent`/`QKeyEvent`.

### Positioning strategies

The keyboard renders in one of two modes, selected by the `ownWindow` flag:
- **Injected** (default) — `InjectedKeyboardPositioner` parents the keyboard item into the focused window's `contentItem()`. May scroll the content to keep the focused input visible unless `noContentScrolling` is set.
- **Own window** — `KeyboardWindowPositioner` puts the keyboard in its own top-level `QQuickWindow` that follows the screen of the focused input window.

Both implement `AbstractPositioner`; `CommonPositioner` holds shared logic. When changing show/hide or focus-tracking behavior, check both subclasses — divergence has been a source of bugs (see the TODO list in [README.md](README.md)).

### Layouts

Layouts are JSON files describing rows of keys. Five layout *types* exist per language: `alphabet`, `symbols`, `dial`, `numbers`, `digits`. `KeyboardLayoutType::Type` is the enum. `KeyboardLayoutsProvider` ([keyboardlayoutsprovider.h](OpenVirtualKeyboard/keyboardlayoutsprovider.h)):
- Loads defaults from the qrc (`qml/layouts/*.json`, prefix `/ovk`).
- Then overlays **custom layouts** from `platforminputcontexts/layouts/<locale>/*.json` next to the plugin, one subfolder per locale (see `example/04_custom_layouts/out/platforminputcontexts/layouts/sk_SK/`).
- Exposes per-type `KeyboardLayoutModel`s to QML and tracks the currently selected language. Persisted selection is in `KeyboardSettings` (`platforminputcontexts/keyboard.ini`, key `Layouts/CurrentIndex`).

Each `KeyboardLayoutModel` paginates rows via `incrementPageForLayoutType`, driving the "NextPage" key.

### Styling

`KeyboardStyle` resolves delegate components used by [Keyboard.qml](OpenVirtualKeyboard/qml/Keyboard.qml) for each key type (default key, Enter, Backspace, Shift, Space, Hide, Symbol, NextPage, Language, KeyPreview, KeyAlternativesPreview, LanguageMenu, Background). Built-in defaults live in `qml/style/Default*.qml` (qrc). Custom overrides are loaded from `platforminputcontexts/styles/*.qml` next to the plugin — see `example/03_custom_style/out/platforminputcontexts/styles/` for the full set. Each style file binds against parent properties documented in [README.md](README.md) (e.g. `parent.active`, `parent.shiftOn`, `parent.enterKeyAction`).

### Resources (qrc)

All built-in QML, fonts, and default JSON layouts are baked into the plugin via [qml.qrc](OpenVirtualKeyboard/qml.qrc) under prefix `/ovk`. When adding a QML/JSON asset, register it there **and** mirror it in the CMake `qt_add_resources` call (already wired generically, but the file must appear in `qml.qrc`).

### Logging

Single category `openvirtualkeyboard` declared in [loggingcategory.h](OpenVirtualKeyboard/loggingcategory.h). Enable from the host app **before** constructing `QGuiApplication`:
```cpp
QLoggingCategory::setFilterRules( "openvirtualkeyboard=true" );
```

## Code style

`.clang-format` (WebKit-derived) is authoritative: 4-space indent, 100-col limit, `PointerAlignment: Left`, braces on new lines for functions/classes, `SpacesInParentheses: true` (i.e. `func( arg )`). Match the existing style — it's noticeably different from stock Qt.

## Things to watch out for

- The qmake `.pro` files and CMakeLists.txt list sources independently. They drift easily; keep them in sync.
- Examples will `std::exit(EXIT_FAILURE)` at startup if the plugin isn't deployed to `<example>/out/platforminputcontexts/` — that's `CHECK_PLUGIN_IS_PREPARED`, not a crash.
- The plugin metadata key `"ovk-magic-key"` exists solely to let examples find the plugin; don't remove it.
- Branching: `main` is the integration branch; current branch [naming](README.md) suggests issue-style prefixes (`fix/`, `refactor/`, `chore/`).
