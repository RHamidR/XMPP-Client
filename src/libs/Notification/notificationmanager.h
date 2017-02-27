#ifndef NOTIFICATIONMANAGER_H
#define NOTIFICATIONMANAGER_H

#include <QObject>
#include <QString>
#include "notificationclient.h"

#include <QQuickWindow>
#include <QTimer>

class NotificationManager : public QObject
{
    Q_OBJECT

private:
    NotificationClient *m_notification;
    QQuickWindow *parentWin;

public:
    static NotificationManager* notifier;
    static NotificationManager* initialize(QObject *parent = 0);
    static void Notify(QString strNotify);
    static void ReleaseNotification();
    static QQuickWindow* getWindow ();
    void setWindow (QQuickWindow *mainWin);
    explicit NotificationManager(QObject *parent = 0);
    NotificationClient* notification();
    ~NotificationManager();

signals:

public slots:
    void notify(QString strNotify);
    void winStateChanged(Qt::WindowState winState);
};

#endif // NOTIFICATIONMANAGER_H
