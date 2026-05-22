/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

#ifndef EXTERNALKEYBOARDPOSITIONER_H
#define EXTERNALKEYBOARDPOSITIONER_H

#include "commonpositioner.h"

class QQuickItem;

/**
 * Positioner used when the keyboard is instantiated directly inside the host
 * application's QML (the "direct usage" mode, enabled via the
 * `externalKeyboard` plugin parameter). The host application owns the
 * keyboard's geometry (parent, size, position) through normal QML bindings, so
 * this positioner does not reparent, resize or move the keyboard. It only
 * toggles its visibility on show/hide and wires up the key-preview / key
 * alternatives logic via CommonPositioner::init().
 */
class ExternalKeyboardPositioner : public CommonPositioner
{
public:
    void setKeyboardObject( QObject* keyboardObject ) override;
    void enableAnimation( bool enabled ) override;
    void updateFocusItem( QQuickItem* focusItem ) override;
    void show() override;
    void hide() override;
    bool isAnimating() const override;
};

#endif // EXTERNALKEYBOARDPOSITIONER_H
