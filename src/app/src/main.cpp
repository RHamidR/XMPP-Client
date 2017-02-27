#include <time.h>

//#include <QObject>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QApplication>
#include <QQmlComponent>
#include <QDesktopServices>

#include "bridge.h"
#include "settings.h"
#include "app_info.h"
#include "notificationmanager.h"
#include "notificationclient.h"

#include "customquickwindow.h"

int generate_random_number (int max, int min)
{
    srand (time (nullptr));
    return rand() % (max - min + 1) + min;
}

int main (int argc, char *argv[])
{
    QApplication m_app (argc, argv);
    m_app.setApplicationName (APP_NAME);
    m_app.setApplicationVersion (APP_VERSION);

    Bridge m_bridge;
    Settings m_settings;

    QDir _smileys_dir (":/smileys/smileys/");
    QStringList m_smileys_list = _smileys_dir.entryList (QStringList ("*.png"));

    QDir _faces_dir (":/faces/faces/");
    QStringList m_faces_list = _faces_dir.entryList (QStringList ("*.jpg")) +
                               _faces_dir.entryList (QStringList ("*.png"));

    QString m_random_face = m_faces_list.at (generate_random_number (m_faces_list.count() - 1, 0));


    QQmlEngine *m_engine = new QQmlEngine();
    m_engine->addImageProvider ("profile-pictures", m_bridge.imageProvider);


    NotificationManager *notification  = NotificationManager::initialize(m_engine->rootContext()->contextObject());
    //notification->Notify("Hello");

    m_engine->rootContext()->setContextProperty ("bridge",      &m_bridge);
    m_engine->rootContext()->setContextProperty ("settings",    &m_settings);
    m_engine->rootContext()->setContextProperty ("device",      &m_bridge.manager);
    m_engine->rootContext()->setContextProperty ("facesList",   QVariant::fromValue (m_faces_list));
    m_engine->rootContext()->setContextProperty ("emojiList",   QVariant::fromValue (m_smileys_list));
    m_engine->rootContext()->setContextProperty ("randomFace",  QVariant::fromValue (m_random_face));
    m_engine->rootContext()->setContextProperty ("appName",     APP_NAME);
    m_engine->rootContext()->setContextProperty ("appCompany",  COMPANY_NAME);
    m_engine->rootContext()->setContextProperty ("appVersion",  APP_VERSION);
    m_engine->rootContext()->setContextProperty ("notificationio",  notification);

    QQmlComponent *m_component = new QQmlComponent (m_engine);
    m_component->loadUrl (QUrl ("qrc:/qml/qml/main.qml"));
    QQuickWindow *m_window = qobject_cast<QQuickWindow *> (m_component->create());
    notification->notifier->setWindow(m_window);

    QObject::connect(m_window, SIGNAL(windowStateChanged(Qt::WindowState)), notification, SLOT(winStateChanged(Qt::WindowState)));
    //QObject::connect(m_window, SIGNAL(windowStateChanged(Qt::WindowState)), m_window, SLOT(hide()));
    //customQuickWindow *m_window = qobject_cast<customQuickWindow *> (m_component->create());
    //m_window
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    m_window->showMaximized();
#else
    m_window->showNormal();
#endif

    return m_app.exec();
}
