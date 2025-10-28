#include "keyboardsettings.h"

KeyboardSettings::KeyboardSettings(QObject* parent)
    : QObject { parent }
{
    QDir().mkpath(m_ApplicationFilePath);
    m_settings = new QSettings(m_UserSettingsFullPath, QSettings::IniFormat, parent);

    QFileInfo iniFile(m_UserSettingsFullPath);

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
