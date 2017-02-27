#ifndef XMPP_H
#define XMPP_H

#include <QDir>
#include <QFile>
#include <QImage>
#include <QObject>
#include <QBuffer>
#include <QImageReader>

#include <QXmppUtils.h>
#include <QXmppClient.h>
#include <QXmppMessage.h>
#include <QXmppVCardIq.h>
#include <QXmppVCardManager.h>
#include <QXmppRosterManager.h>
//#include "QXmppRegisterIq.h"
#include "xmppregister.h"
#include "notificationmanager.h"

class Xmpp : public QObject
{
        Q_OBJECT

    public:

        Xmpp();
        ~Xmpp();
        void requestVCard(QString jid);
        int retrieveUnexpectedMessage();
        bool completedLoad = false;

    public slots:
        void setDownloadPath (const QString& path);
        void login (const QString& jid, const QString& passwd);
        void createUser (const QString domain, const QString& jid,
                         const QString& passwd, const QString& mail);

        void shareFile (const QString& to, const QString& path);
        void sendStatus (const QString &to, const QString &status);
        void sendMessage (const QString& to, const QString& message);

        void friendRequest (const QString &jid);
        void slotPresenceReceived(QXmppPresence presence);
    signals:

        void connected();
        void disconnected();
        void delUser (const QString& name, const QString& id);
        void newMessage (const QString& from, const QString& message);
        void presenceChanged (const QString& from, const bool &connected);
        void newUser (const QString& name, const QString& id, const QImage& image);

        void registerError(const QString& message);
        void registerSuccessful();

        void presenceReceived(QXmppPresence presence);

        void rosterCounts(int rosters);
    private slots:
        void rosterReceived();
        void vCardReceived (const QXmppVCardIq& vCard);
        void messageReceived (const QXmppMessage& message);
        void registerComplete();

    private:

        QString m_jid;
        QString m_path;
        QXmppClient *m_client;
        xmppRegister *regTheUser;
        QStringList jids;
        QStringList users;

        void newUnexpectedMessage(const QString& from, const QString& message);
        QList < QPair< QString, QString > >unexpectedMessages;
};

#endif
