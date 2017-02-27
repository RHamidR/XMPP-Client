#ifndef BRIDGE_H
#define BRIDGE_H

#include <QImage>
#include <QClipboard>
#include <QFileDialog>
#include <QDomDocument>

#include <Xmpp>

#include "app_info.h"
#include "image_provider.h"
#include "device_manager.h"
#include "settings.h"

class Bridge : public QObject
{
        Q_OBJECT

    public:
        Bridge();


        Q_INVOKABLE void stopXmpp();
        Q_INVOKABLE void startXmpp (QString jid, QString passwd);

        Q_INVOKABLE void createUser (const QString jid, const QString domain, const QString password, const QString email);
        Q_INVOKABLE void addContact (QString userJid);

        Q_INVOKABLE void copy (const QString &string);

        Q_INVOKABLE QString getId (QString nickname);
        Q_INVOKABLE void shareFiles (const QString& peer);
        Q_INVOKABLE void sendStatus (const QString &to, const QString &status);
        Q_INVOKABLE void sendMessage (const QString& to, const QString &message);

        Q_INVOKABLE int readOfflineMessages();
        Q_INVOKABLE int getFriendsCount();

        DeviceManager manager;
        ImageProvider *imageProvider;

        Q_INVOKABLE void playAudio (QString address);
    signals:
        void xmppConnected();
        void xmppDisconnected();
        void delUser (QString nick, QString id);
        void newUser (QString nick, QString id);
        void sendFile (QString file, QString peer);
        void drawMessage (QString from, QString message);
        void sendStatusSignal (QString to, QString status);
        void returnPressed (QString message, QString peer);
        void presenceChanged (const QString &id, bool connected);
        void updateProgress (QString name, QString file, int progress);
        void statusChanged (const QString &from, const QString &status);
        void successReg();
        void error(const QString message);

        void presenceReceived ();

    private slots:
        void clearUsers();
        void processNewUser (const QString& nickname, const QString& id, const QImage& profilePicture);

        void newMessage (QString from, QString message);
        void presenceReceived (QXmppPresence presence);

        void friendsCountReceived(int count);

    private:
        Xmpp *m_xmpp;
        QStringList m_uuids;
        QStringList m_nicknames;

        QClipboard *m_clipboard;
        int friendsCount;

        QList<Xmpp *> m_xmpp_objects;
};

#endif
