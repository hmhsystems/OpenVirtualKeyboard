#ifndef KEYBOARDSETTINGS_H
#define KEYBOARDSETTINGS_H

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QObject>
#include <QSettings>
#include <QStandardPaths>

constexpr char kUserSettingsFileName[] = "keyboardSettings.ini";
constexpr char kDefaultSettingsFilePath[] = ":/keyboardSettings.ini";
constexpr char kLanguageLayoutIndex[] = "Languages/LanguageLayoutIndex";

class KeyboardSettings : public QObject {
    Q_OBJECT

public:
    explicit KeyboardSettings(QObject* parent = nullptr);

    int currentLanguageIndex() const;
    void setCurrentLanguageIndex(int currentLayoutIndex);

private:
    QSettings* m_settings = nullptr;
#ifdef Q_OS_ANDROID
    const QString m_ApplicationFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QDir::separator();
#else
    const QString m_ApplicationFilePath = QCoreApplication::applicationDirPath() + QDir::separator();
#endif
    const QString m_UserSettingsFullPath = QDir(m_ApplicationFilePath).filePath(kUserSettingsFileName);

    void createUserIniFile();
    void checkAndCorrectUserSettings(const QSettings& defaultSettings);
};

#endif // KEYBOARDSETTINGS_H
