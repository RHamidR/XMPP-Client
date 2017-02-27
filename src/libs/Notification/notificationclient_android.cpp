#include "notificationclient.h"

//#if defined(Q_OS_ANDROID)
    #include <QtAndroidExtras/QAndroidJniObject>
//#else
//defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
//#endif

NotificationClient::NotificationClient(QObject *parent)
    : QObject(parent)
{
    connect(this, SIGNAL(notificationChanged()), this, SLOT(updateNotification()));
}

void NotificationClient::setNotification(const QString &notification)
{
    if (m_notification == notification)
        return;

    m_notification = notification;
    emit notificationChanged();
}

QString NotificationClient::notification() const
{
    return m_notification;
}

void NotificationClient::updateNotification()
{
    QAndroidJniObject javaNotification = QAndroidJniObject::fromString(m_notification);
    QAndroidJniObject::callStaticMethod<void>("net/notnamed/chat/NotificationClient",
                                       "notify",
                                       "(Ljava/lang/String;)V",
                                       javaNotification.object<jstring>());
}

/*void NotificationClient::trayActivated(int asd)
{
    Q_UNUSED(asd);
}*/
