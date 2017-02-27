#include "notificationmanager.h"

NotificationManager * NotificationManager::notifier = nullptr;
NotificationManager* NotificationManager::initialize(QObject *parent){
    if (NotificationManager::notifier == nullptr){
        NotificationManager::notifier = new NotificationManager(parent);

    }
    return NotificationManager::notifier;
}

void NotificationManager::setWindow(QQuickWindow *mainWin)
{
    parentWin = mainWin;
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)

#else
    m_notification->setWindowAndTrayMenu();
#endif
}

QQuickWindow *NotificationManager::getWindow()
{
    return NotificationManager::notifier->parentWin;
}

void NotificationManager::ReleaseNotification()
{
    delete &NotificationManager::notifier;
}


NotificationManager::NotificationManager(QObject *parent)
    : QObject(parent)
{
    m_notification = new NotificationClient(parent);
}

NotificationClient* NotificationManager::notification(){
    return m_notification;
}

void NotificationManager::notify(QString strNotify)
{
    m_notification->setNotification(strNotify);
}

void NotificationManager::Notify(QString strNotify)
{
    notifier->notify(strNotify);
}

void NotificationManager::winStateChanged(Qt::WindowState winState)
{
    if (winState == Qt::WindowMinimized)
        parentWin->hide();
}

NotificationManager::~NotificationManager()
{
    delete m_notification;
}
