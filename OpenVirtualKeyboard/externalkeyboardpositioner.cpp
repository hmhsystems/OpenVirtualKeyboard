/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

#include "externalkeyboardpositioner.h"
#include <QQuickItem>

void ExternalKeyboardPositioner::setKeyboardObject( QObject* keyboardObject )
{
    auto item = qobject_cast<QQuickItem*>( keyboardObject );
    if (!item)
        return;

    // init() stores the keyboard into CommonPositioner::_keyboard and connects
    // the key-preview / alternatives-preview handling to the interceptor.
    init( item );

    // host controls when it is shown; keep it hidden until showInputPanel()
    if (_keyboard)
        _keyboard->setVisible( false );
}

void ExternalKeyboardPositioner::enableAnimation( bool /*enabled*/ )
{
    // Animation/geometry is fully controlled by the host application.
}

void ExternalKeyboardPositioner::updateFocusItem( QQuickItem* /*focusItem*/ )
{
    // Geometry is owned by the host; nothing to reposition here.
}

void ExternalKeyboardPositioner::show()
{
    if (_keyboard)
        _keyboard->setVisible( true );
}

void ExternalKeyboardPositioner::hide()
{
    if (_keyboard)
        _keyboard->setVisible( false );
}

bool ExternalKeyboardPositioner::isAnimating() const
{
    return false;
}
