#include "settings.h"

QString Settings::my_server;

Settings::Settings()
{
    m_primary_color = "#2672AC";
    m_settings = new QSettings (COMPANY_NAME, APP_NAME);
    m_Server = "192.168.43.177";
    Settings::my_server = "192.168.43.177";
    //m_Server = "217.79.180.224";
    //Settings::my_server = "217.79.180.224";
}

void Settings::setValue (QString key, QVariant value)
{
    Q_ASSERT (!key.isEmpty());
    Q_ASSERT (!value.isNull());

    m_settings->setValue (key, value);
}

QVariant Settings::value (QString key, QVariant defaultValue) const
{
    Q_ASSERT (!key.isEmpty());
    Q_ASSERT (!defaultValue.isNull());

    return m_settings->value (key, defaultValue);
}

int Settings::x()
{
    return value ("x", 150).toInt();
}

int Settings::y()
{
    return value ("y", 150).toInt();
}

int Settings::width()
{
    return value ("width", 860).toInt();
}

int Settings::height()
{
    return value ("height", 560).toInt();
}

bool Settings::textChat()
{
    return value ("textChat", false).toBool();
}

bool Settings::customColor()
{
    return value ("customColor", true).toBool();
}

bool Settings::firstLaunch()
{
    return value ("firstLaunch", true).toBool();
}

bool Settings::notifyUpdates()
{
    return value ("notifyUpdates", true).toBool();
}

bool Settings::soundsEnabled()
{
    return value ("soundsEnabled", true).toBool();
}

QString Settings::primaryColor()
{
    return value ("primaryColor", m_primary_color).toString();
}

QString Settings::getUserName()
{
    if (m_UserName.isEmpty() || m_UserName.isNull())
        m_UserName = value ("UserName", "").toString();
    return m_UserName;
}
QString Settings::getPassWord()
{
    if (m_PassWord.isEmpty() || m_PassWord.isNull())
        m_PassWord = value ("PassWord", "").toString();
    return m_PassWord;
}

void Settings::setUserPass (QString strUserName, QString strPassWord)
{
    Q_ASSERT(!strUserName.isNull() || !strPassWord.isEmpty());
    setValue ("UserName", strUserName);
    setValue ("PassWord", strPassWord);
}
