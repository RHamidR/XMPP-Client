#include "xmpp.h"

Xmpp::Xmpp()
{
    // Initialize a new QXmppClient and make ourselves known to the
    // World Wide Web :)
    m_client = new QXmppClient();
    m_client->configuration().setResource ("Messenger");

    unexpectedMessages = QList < QPair<QString, QString > >();
    connect (m_client, SIGNAL(presenceReceived(QXmppPresence)), this, SLOT(slotPresenceReceived(QXmppPresence)));
}

Xmpp::~Xmpp()
{
    // Close the XMPP connection(s) when this class is destroyed
    m_client->disconnectFromServer();
}

void Xmpp::requestVCard(QString jid)
{
    m_client->vCardManager().requestVCard(jid);
}

void Xmpp::setDownloadPath (const QString& path)
{
    Q_ASSERT (!path.isEmpty());

    // Change the path where we should write all downloaded files
    if (!path.isEmpty())
        m_path = path;

    // Show a console warning when the "path" parameter is invalid
    else
        qWarning() << "Xmpp: Download path cannot be empty!";
}


void Xmpp::createUser (const QString domain, const QString& uname,
                       const QString& passwd, const QString& mail)//, const QString& nickname)
{
    regTheUser = new xmppRegister(domain, uname, passwd, mail);//, "nickname");//(client);
    connect (regTheUser, SIGNAL(errorOccured(QString)),
             this, SIGNAL(registerError(QString)));
    connect (regTheUser, SIGNAL(successful(QString)),
             this, SIGNAL(registerSuccessful()));
    connect (regTheUser, SIGNAL(complete()),
             this, SLOT(registerComplete()));
    regTheUser->start();

}

void Xmpp::login (const QString& jid, const QString& passwd)
{
    Q_ASSERT (!jid.isEmpty());
    Q_ASSERT (!passwd.isEmpty());

    m_jid = jid;

    // Connect with the specified JID and password
    m_client->connectToServer (m_jid, passwd);

    // Communicate the XMPP client with the rest of the class
    connect (m_client, SIGNAL (connected()), this, SIGNAL (connected()));
    connect (m_client, SIGNAL (disconnected()), this, SIGNAL (disconnected()));
    connect (m_client, SIGNAL (error (QXmppClient::Error)), this, SIGNAL (disconnected()));
    connect (&m_client->rosterManager(), SIGNAL (rosterReceived()),
             this, SLOT (rosterReceived()));
    connect (m_client, SIGNAL (messageReceived (QXmppMessage)), this,
             SLOT (messageReceived (QXmppMessage)));
}

void Xmpp::friendRequest(const QString &jid)
{
    QXmppPresence subscribe;
    subscribe.setTo(jid);
    subscribe.setType(QXmppPresence::Subscribe);
    m_client->sendPacket(subscribe);
}

void Xmpp::shareFile (const QString &to, const QString& path)
{
    Q_UNUSED (path);
    Q_UNUSED (to);
}

void Xmpp::sendMessage (const QString &to, const QString &message)
{
    Q_ASSERT (!to.isEmpty());
    Q_ASSERT (!message.isEmpty());

    if (!message.isEmpty() && !to.isEmpty())
        m_client->sendMessage (to, message);

    else
        qWarning() << "Xmpp: Invalid arguments for new message:" << to << message;
}

void Xmpp::sendStatus (const QString &to, const QString &status)
{
    Q_UNUSED (to);
    Q_UNUSED (status);
}

void Xmpp::rosterReceived()
{
    QStringList list = m_client->rosterManager().getRosterBareJids();
    connect (&m_client->vCardManager(), SIGNAL (vCardReceived (QXmppVCardIq)),
             this, SLOT (vCardReceived (QXmppVCardIq)));

    emit rosterCounts(list.count());
    for (int i = 0; i < list.size(); ++i)
        requestVCard (list.at (i));

    if (list.count() == 0)
        completedLoad = true;
}

void Xmpp::slotPresenceReceived(QXmppPresence presence)
{
    if (presence.type() == QXmppPresence::Subscribed)
        requestVCard (presence.from());
    emit presenceReceived(presence);
}

void Xmpp::vCardReceived (const QXmppVCardIq& vCard)
{
    QByteArray photo = vCard.photo();
    QBuffer buffer;
    buffer.setData (photo);
    buffer.open (QIODevice::ReadOnly);
    QImageReader imageReader (&buffer);
    QImage image = imageReader.read();

    if (image.isNull())
        image = QImage (":/faces/faces/generic-user.png");

    jids.append (vCard.from());
    users.append (vCard.from().section("",0,vCard.from().indexOf("@")).toLatin1());//(vCard.nickName());//(vCard.fullName());
    //qDebug("FullName: " + vCard.fullName() + " | From: " +vCard.)
    emit newUser (vCard.from().section("",0,vCard.from().indexOf("@")).toLatin1(), vCard.from(), image); //(vCard.fullName(), vCard.from(), image);
    //char * msgs = (vCard.nickName() + "VCARD RECiEVED *************************").pointer->
    if ((unexpectedMessages.length() > 0) && (completedLoad)) retrieveUnexpectedMessage();
    //qDebug (vCard.from().section("",0,vCard.from().indexOf("@")).toLatin1());
}

int Xmpp::retrieveUnexpectedMessage()
{
    int drawedMessages = 0;
    for (int theCounter = unexpectedMessages.length()-1; theCounter >= 0; theCounter--)
    {
        qDebug ((unexpectedMessages[theCounter].second + " <<<<<<>>>>>>> " + (unexpectedMessages.length()+48)).toLatin1());
        if (jids.contains(unexpectedMessages[theCounter].first))// == QXmppUtils::jidToBareJid(vCard.from()))
        {
            emit newMessage(users.at (jids.indexOf (unexpectedMessages[theCounter].first)),
                                                    unexpectedMessages[theCounter].second);
            qDebug ((unexpectedMessages[theCounter].second + " | " + (unexpectedMessages.length()+48)).toLatin1());
            unexpectedMessages.removeAt(theCounter);
            drawedMessages += 1;
        }
    }
    return drawedMessages;
}

void Xmpp::messageReceived (const QXmppMessage &message)
{
    //qDebug (((QString::number(jids.indexOf (QXmppUtils::jidToBareJid (message.from())))) + " ----> " + QXmppUtils::jidToBareJid (message.from())).toLatin1());
    QString body = message.body();
    if (jids.contains(QXmppUtils::jidToBareJid (message.from()))){
        QString peer = users.at (jids.indexOf (QXmppUtils::jidToBareJid (message.from())));
        emit newMessage (peer, body);
    }
    else{
        QString peer = QXmppUtils::jidToBareJid (message.from());
        newUnexpectedMessage(peer, body);
    }
}
void Xmpp::newUnexpectedMessage(const QString& from, const QString& message)
{
    qDebug ((from + " --#this is new Unexpected#-- " + message).toLatin1());
    unexpectedMessages.prepend(qMakePair<QString, QString>(from, message));
    //unexpectedMessages.append(qMakePair<QString, QString>(from, message));
    requestVCard(from);
}

void Xmpp::registerComplete()
{
    delete regTheUser;
}
