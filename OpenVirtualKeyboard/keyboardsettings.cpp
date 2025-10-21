#include "keyboardsettings.h"

KeyboardSettings::KeyboardSettings(QObject* parent)
    : QObject { parent }
{
    QDir().mkpath(m_ApplicationFilePath);

    QFileInfo iniFile(m_UserSettingsFullPath);

    if (iniFile.exists()) {
        const QSettings defaultSettings(kDefaultSettingsFilePath, QSettings::IniFormat);
        m_settings = new QSettings(m_UserSettingsFullPath, QSettings::IniFormat, parent);
        // if (!m_settings->isWritable()) {
        //     qFatal() << "Ini file is not writable. Please check if you have the necessary privileges and try again.";
        // }
        checkAndCorrectUserSettings(defaultSettings);
    } else {
        createUserIniFile();
        m_settings = new QSettings(m_UserSettingsFullPath, QSettings::IniFormat);
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

void KeyboardSettings::createUserIniFile()
{
    QFile userIniFile(m_UserSettingsFullPath);
    if (userIniFile.exists() && !userIniFile.remove()) {
        qFatal() << "Could not remove ini file. Please check if you have the necessary privileges or if it's being used by another process and try again.";
    };
    if (!QFile::copy(kDefaultSettingsFilePath, m_ApplicationFilePath + kUserSettingsFileName)) {
        qFatal() << "Could not copy ini file. Please check if you have the necessary privileges and try again.";
    }
    userIniFile.setFileName(m_UserSettingsFullPath);
    if (!userIniFile.setPermissions(QFileDevice::WriteOwner | QFileDevice::ReadOwner
            | QFileDevice::WriteGroup | QFileDevice::ReadGroup
            | QFileDevice::WriteOther | QFileDevice::ReadOther)) {
        qWarning() << "Could not set file permissions";
    }
}

void KeyboardSettings::checkAndCorrectUserSettings(const QSettings& defaultSettings)
{
    QStringList defaultKeys = defaultSettings.allKeys();

    foreach (const QString& defaultKey, defaultKeys) {
        if (!m_settings->contains(defaultKey)) {
            m_settings->setValue(defaultKey, defaultSettings.value(defaultKey));
        }
    }
}
