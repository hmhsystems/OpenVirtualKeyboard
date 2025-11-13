#include "keyboardsettings.h"

KeyboardSettings::KeyboardSettings(QObject* parent)
    : QObject { parent }
{
#ifdef Q_OS_ANDROID
    QString settingsPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
#else
    QString settingsPath = QCoreApplication::applicationDirPath();
#endif

    settingsPath = QDir(settingsPath).filePath(kUserSettingsSubFolder);
    QDir().mkpath(settingsPath);

    QString settingsFilePath = QDir(settingsPath).filePath(kUserSettingsFileName);
    m_settings = new QSettings(settingsFilePath, QSettings::IniFormat, parent);

    QFileInfo iniFile(settingsFilePath);

    if (!iniFile.exists()) {
        m_settings->setValue(kLanguageLayoutIndex, 0);
        m_settings->sync();
        if (m_settings->status() != QSettings::NoError) {
            qWarning() << "Failed to create and write initial settings. Status:" << m_settings->status();
        }
    }
}

int KeyboardSettings::currentLanguageIndex() const
{
    return m_settings->value(kLanguageLayoutIndex).toInt();
}

void KeyboardSettings::setCurrentLanguageIndex(int currentLayoutIndex)
{
    m_settings->setValue(kLanguageLayoutIndex, currentLayoutIndex);
    m_settings->sync();

    if (m_settings->status() != QSettings::NoError) {
        qWarning() << "Failed to write settings. Status:" << m_settings->status();
    }
}
