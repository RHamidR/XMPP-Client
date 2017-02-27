#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QPalette>
#include <QScreen>
#include <QSettings>
#include <QApplication>

#include "app_info.h"

class Settings : public QObject
{
        Q_OBJECT
        Q_PROPERTY(QString server READ getServer)
    public:
        Settings();

        Q_INVOKABLE void setValue (QString key, QVariant value);
        Q_INVOKABLE void setUserPass (QString strUserName, QString strPassWord);
        Q_INVOKABLE QVariant value (QString key, QVariant defaultValue) const;

        Q_INVOKABLE int x();
        Q_INVOKABLE int y();
        Q_INVOKABLE int width();
        Q_INVOKABLE int height();
        Q_INVOKABLE bool textChat();
        Q_INVOKABLE bool customColor();
        Q_INVOKABLE bool firstLaunch();
        Q_INVOKABLE bool notifyUpdates();
        Q_INVOKABLE bool soundsEnabled();
        Q_INVOKABLE QString primaryColor();
        Q_INVOKABLE QString getUserName();
        Q_INVOKABLE QString getPassWord();

        Q_INVOKABLE QString getServer(){return m_Server;}


        //Not Safe but I have no time for fixing this static defination
        static QString my_server;
    private:
        QSettings *m_settings;
        QString m_primary_color;
        QString m_UserName;
        QString m_PassWord;
        QString m_Server;
};

#endif
