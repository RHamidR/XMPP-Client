#ifndef NOTIFICATIONCLIENT_H
#define NOTIFICATIONCLIENT_H

#include <QObject>
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)

#else
#include <QSystemTrayIcon>
#include <QMenu>
#include <QQuickWindow>
#endif

class NotificationClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString notification READ notification WRITE setNotification NOTIFY notificationChanged)

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)

#else
    QSystemTrayIcon * trayIcon;
    QMenu * trayMenu;
#endif


public:
    explicit NotificationClient(QObject *parent = 0);

    void setNotification(const QString &notification);
    QString notification() const;

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)

#else
    void setWindowAndTrayMenu();
#endif

signals:
    void notificationChanged();

private slots:
    void updateNotification();
/*#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    void trayActivated(int asd);
#else
    void trayActivated(QSystemTrayIcon::ActivationReason asd);//(QSystemTrayIcon::ActivationReason asd);
#endif
*/
/*
#if defined(Q_OS_IOS)
    void updateIOSNotification();
#endif
#if defined(Q_OS_IOS)
    void updateBBNotification();
#endif
*/

private:
    QString m_notification;
};

#endif // NOTIFICATIONCLIENT_H
