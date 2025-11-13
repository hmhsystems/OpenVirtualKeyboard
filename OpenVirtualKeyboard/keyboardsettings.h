#ifndef KEYBOARDSETTINGS_H
#define KEYBOARDSETTINGS_H

#include <QCoreApplication>
#include <QDir>
#include <QFile>
#include <QObject>
#include <QSettings>
#include <QStandardPaths>

constexpr char kUserSettingsFileName[] = "keyboard.ini";
constexpr char kUserSettingsSubFolder[] = "platforminputcontexts";
constexpr char kLanguageLayoutIndex[] = "Layouts/CurrentIndex";

class KeyboardSettings : public QObject {
    Q_OBJECT

public:
    void extracted();
    explicit KeyboardSettings(QObject* parent = nullptr);

    int currentLanguageIndex() const;
    void setCurrentLanguageIndex(int currentLayoutIndex);

private:
    QSettings* m_settings = nullptr;
};

#endif // KEYBOARDSETTINGS_H
