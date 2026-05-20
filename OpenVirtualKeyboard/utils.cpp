/**
 *  MIT License
 *  Copyright (c) Pavel Hromada
 *  See accompanying LICENSE file
 */

#include <QCoreApplication>
#include <QDir>
#include <QLibrary>
#include <QPluginLoader>
#include <QJsonObject>
#include <QJsonArray>
#include "utils.h"
#include "loggingcategory.h"

QString ovk::pluginAbsolutePath()
{
    static QString foundPath{};

    if (!foundPath.isEmpty())
    {
        qInfo() << "OVK plugin path cached:" << foundPath;
        return foundPath;
    }

    const auto paths = QCoreApplication::libraryPaths();
    qInfo() << "OVK library paths:" << paths;

    for (auto&& p : paths) {
        qInfo() << "OVK searching for plugin in" << p;
        auto path = p.endsWith( '/' ) ? p : ( p + '/' );
        path = path + "platforminputcontexts/";
        const auto libraries = QDir( path ).entryList( QDir::Files );
        qInfo() << "OVK candidate folder:" << path << "files:" << libraries;

        for (auto&& lib : libraries) {
            if (!QLibrary::isLibrary( lib ))
                continue;
            QPluginLoader loader{ path + lib };
            const auto pluginMetaData = loader.metaData();
            if (pluginMetaData["MetaData"].toObject()["Keys"].toArray().contains("ovk-magic-key")) {
                qInfo() << "OVK recognized plugin:" << path + lib;
                foundPath = path;
                break;
            }
        }

        if (!foundPath.isEmpty())
            break;
    }

    if (foundPath.isEmpty())
        qWarning() << "OVK plugin path not found; default styles and layouts will be used";
    else
        qInfo() << "OVK found plugin path:" << foundPath;

    return foundPath;
}

QString ovk::stylesAbsolutePath()
{
    auto path = pluginAbsolutePath();
    if (path.isEmpty())
        return QString();

    path.append( QStringLiteral("styles/"));
    if (QDir( path ).exists())
        return path;

    return QString();
}

QString ovk::layoutsAbsolutePath()
{
    auto path = pluginAbsolutePath();
    if (path.isEmpty())
        return QString();

    path.append( QStringLiteral("layouts/"));
    if (QDir( path ).exists())
        return path;

    return QString();
}
