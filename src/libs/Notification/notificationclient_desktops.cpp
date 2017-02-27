#include "notificationclient.h"
#include <QMessageBox>
#include "notificationmanager.h"
#include <QFileInfo>
#include <QFileIconProvider>
#include <QApplication>

NotificationClient::NotificationClient(QObject *parent)
    : QObject(parent)
{

    trayMenu = new QMenu();
    trayIcon = new QSystemTrayIcon(this);

    QFileInfo fileInfo(qApp->arguments().at(0));
    trayIcon->setIcon(QIcon(QFileIconProvider().icon(fileInfo)));

    //trayIcon->setIcon(QIcon(":/icon.png"));
    trayIcon->setContextMenu(trayMenu);

    trayIcon->show();

    connect(this, SIGNAL(notificationChanged()), this, SLOT(updateNotification()));
    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)), this, SLOT(trayActivated(QSystemTrayIcon::ActivationReason)));
}

void NotificationClient::setWindowAndTrayMenu()
{
    QQuickWindow *window = NotificationManager::getWindow();
    QAction *showAction = new QAction(QObject::tr("Show"), window);
    window->connect(showAction, SIGNAL(triggered()), window, SLOT(show()));
    QAction *hideAction = new QAction(QObject::tr("Hide"), window);
    window->connect(hideAction, SIGNAL(triggered()), window, SLOT(hide()));

    QAction *quitAction = new QAction(QObject::tr("&Quit"), window);
    window->connect(quitAction, SIGNAL(triggered()), window, SLOT(close()));
    trayMenu->addAction (showAction);
    trayMenu->addAction (hideAction);
    trayMenu->addAction (quitAction);

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
    trayIcon->show();
    trayIcon->showMessage("پیام جدید", m_notification);
}

/*void NotificationClient::trayActivated(QSystemTrayIcon::ActivationReason asd)
{
    if (asd == QSystemTrayIcon::DoubleClick)
        NotificationManager::getWindow()->show();
    //QMessageBox::information(0,"Custom Action Slot Activated","Activation Event is Occured");
}*/
