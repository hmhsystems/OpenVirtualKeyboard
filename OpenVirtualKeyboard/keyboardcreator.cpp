/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

#include <QUrl>
#include <QQmlEngine>
#include <QScopeGuard>
#include <QQuickWindow>
#include <QQmlComponent>
#include <QQmlIncubationController>
#include <QDebug>
#include <QGuiApplication>
#include "keyboardcreator.h"
#include "keypressinterceptor.h"
#include "keypreview.h"
#include "keyalternativespreview.h"
#include "loggingcategory.h"

KeyboardCreator::KeyboardCreator( const QUrl& keyboardUrl )
    : _keyboardUrl( keyboardUrl )
{}

KeyboardCreator::~KeyboardCreator() = default;

void KeyboardCreator::createKeyboard()
{
    qInfo() << "OVK KeyboardCreator::createKeyboard loading=" << _loading
            << "currentKeyboard=" << _keyboard;
    if (_loading)
        return;

    auto app = applicationInstance();
    if (!app) {
        qCWarning( logOvk )
            << "QGuiApplication instance not available => virtual keyboard won't be created";
        return;
    }

    auto window = usedWindow();
    qInfo() << "OVK KeyboardCreator::createKeyboard app=" << app
            << "focusWindow=" << app->focusWindow() << "usedWindow=" << window;
    if (!window) {
        _loading = true;
        qWarning() << "OVK KeyboardCreator waiting for focusWindowChanged";
        connect(app, &QGuiApplication::focusWindowChanged, this, [this, app](){
            qInfo() << "OVK focusWindowChanged fired; focusWindow=" << app->focusWindow()
                    << "keyboard=" << _keyboard << "loading=" << _loading;
            if (!_keyboard && app->focusWindow())
                continueKeyboardCreation();
        });
        return;
    }

    continueKeyboardCreation();
}

QObject* KeyboardCreator::keyboardObject() const
{
    return _keyboard;
}

KeyPressInterceptor* KeyboardCreator::keyPressInterceptor() const
{
    return _keyPressInterceptor;
}

void KeyboardCreator::createKeyboardInstance()
{
    qInfo() << "OVK KeyboardCreator::createKeyboardInstance component=" << _keyboardComponent.get();
    if (!_keyboardComponent) {
        _loading = false;
        return;
    }

    auto engine = usedQmlEngine();
    if (!engine) {
        _loading = false;
        return;
    }

    qInfo() << "OVK KeyboardCreator::createKeyboardInstance engine=" << engine
            << "incubationController=" << engine->incubationController();

    if (!engine->incubationController()) {
        _incubationController.reset( new QQmlIncubationController );
        engine->setIncubationController( _incubationController.get() );
    }

    // Creation process is asynchronous and statusChanged()
    // method will be called during creation.
    _keyboardComponent->create( *this );
}

// QQmlIncubator interface
void KeyboardCreator::statusChanged( QQmlIncubator::Status status )
{
    qInfo() << "OVK KeyboardCreator incubator status=" << status
            << "object=" << object() << "errors=" << errors();
    if (status == QQmlIncubator::Loading || status == QQmlIncubator::Null)
        return;

    auto cleanup = qScopeGuard( [this] {
        _keyboardComponent.reset();
        if (_incubationController)
            usedQmlEngine()->setIncubationController( nullptr );
        _incubationController.reset();
        _loading = false;
    } );

    if (status == QQmlIncubator::Ready) {
        _keyboard = object();

        if (!_keyboard) {
            qCWarning(logOvk) << "Couldn't create virtual keyboard from plugin";
            return;
        }

        QQmlEngine::setObjectOwnership( _keyboard, QQmlEngine::CppOwnership );
        _keyboard->setParent( usedQmlEngine() );
        _keyPressInterceptor = _keyboard->findChild<KeyPressInterceptor*>( "keyInterceptor" );
        qCDebug(logOvk) << "Virtual keyboard created";
        emit created();
    } else if (status == QQmlIncubator::Error) {
        qInfo() << "OVK KeyboardCreator incubator error details=" << errors();
        qCWarning(logOvk) << "Virtual keyboard can't be created" << errors();
    }
}

void KeyboardCreator::continueKeyboardCreation()
{
    qInfo() << "OVK KeyboardCreator::continueKeyboardCreation loading=" << _loading
            << "component=" << _keyboardComponent.get();
    _loading = true;

    auto engine = usedQmlEngine();
    if (!engine) {
        _loading = false;
        return;
    }

    auto continueLoading = [cancelled = std::unique_ptr<QQmlComponent> {},
                            this]( QQmlComponent::Status status ) mutable {
        if (status == QQmlComponent::Ready) {
            createKeyboardInstance();
        } else if (status == QQmlComponent::Error) {
            qInfo() << "OVK KeyboardCreator component error details="
                    << _keyboardComponent->errors();
            qCWarning(logOvk) << "Virtual keyboard can't be created" << _keyboardComponent->errors();
            _loading = false;
            cancelled = move( _keyboardComponent );
        }
    };

    _keyboardComponent.reset( new QQmlComponent( engine, _keyboardUrl, QQmlComponent::Asynchronous ));
    qInfo() << "OVK KeyboardCreator created QQmlComponent; isLoading=" << _keyboardComponent->isLoading()
            << "status=" << _keyboardComponent->status();

    if (_keyboardComponent->isLoading())
        connect( _keyboardComponent.get(), &QQmlComponent::statusChanged, this, std::move(continueLoading ));
    else
        continueLoading( _keyboardComponent->status() );
}

QGuiApplication* KeyboardCreator::applicationInstance() const
{
    return qobject_cast<QGuiApplication*>( QCoreApplication::instance() );
}

QQmlEngine* KeyboardCreator::usedQmlEngine() const
{
    auto engine = qmlEngine( usedWindow() );
    if (!engine)
        qCWarning(logOvk) << "Virtual keyboard can't be created => QML engine not available";

    qInfo() << "OVK KeyboardCreator::usedQmlEngine window=" << usedWindow()
            << "engine=" << engine;

    return engine;
}

QQuickWindow* KeyboardCreator::usedWindow() const
{
    auto app = applicationInstance();
    if (!app)
        return nullptr;

    auto window = qobject_cast<QQuickWindow*>( app->focusWindow() );
    if (!window)
        return nullptr;

    qInfo() << "OVK KeyboardCreator::usedWindow returning" << window;

    return window;
}
