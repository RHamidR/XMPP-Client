#include "bridge.h"
#include <QMessageBox>
#include <QSoundEffect>

Bridge::Bridge()
{
    imageProvider = new ImageProvider;
    m_clipboard = QApplication::clipboard();
}

void Bridge::stopXmpp()
{
    clearUsers();
	
    qDeleteAll (m_xmpp_objects.begin(), m_xmpp_objects.end());
    m_xmpp_objects.clear();
    //delete m_xmpp;
}

void Bridge::startXmpp (QString jid, QString passwd)
{
    Q_ASSERT (!jid.isEmpty());
    Q_ASSERT (!passwd.isEmpty());

    m_xmpp = new Xmpp();
    m_xmpp_objects.append (m_xmpp);

    connect (m_xmpp, SIGNAL (connected()),
             this,   SIGNAL (xmppConnected()));
    connect (m_xmpp, SIGNAL (disconnected()),
             this,   SIGNAL (xmppDisconnected()));
    connect (m_xmpp, SIGNAL (delUser (QString, QString)),
             this,   SIGNAL (delUser (QString, QString)));
    connect (m_xmpp, SIGNAL (newUser        (QString, QString, QImage)),
             this,   SLOT   (processNewUser (QString, QString, QImage)));
    connect (m_xmpp, SIGNAL (newMessage  (QString, QString)),
             this,   SLOT   (newMessage (QString, QString)));

    connect (this,   SIGNAL (returnPressed (QString, QString)),
             m_xmpp, SLOT   (sendMessage   (QString, QString)));
    connect (this,   SIGNAL (sendFile  (QString, QString)),
             m_xmpp, SLOT   (shareFile (QString, QString)));
    connect (this,   SIGNAL (sendStatusSignal  (QString, QString)),
             m_xmpp, SLOT   (sendStatus        (QString, QString)));

    connect (m_xmpp, SIGNAL(presenceReceived(QXmppPresence)),
             this,   SIGNAL(presenceReceived()));
    connect (m_xmpp, SIGNAL(rosterCounts(int)), this, SLOT(friendsCountReceived(int)));

    m_xmpp->login (jid, passwd);
}
void Bridge::createUser (QString jid, QString domain, QString password, QString email)
{
    m_xmpp = new Xmpp();
    m_xmpp_objects.append (m_xmpp);

    connect (m_xmpp, SIGNAL(registerSuccessful()),
             this, SIGNAL(successReg()));
    connect (m_xmpp, SIGNAL(registerError(QString)),
             this, SIGNAL(error(QString)));

    m_xmpp->createUser(domain, jid, password, email);
}

void Bridge::addContact (QString userJid)
{
    if (userJid.indexOf("@")>1)
        m_xmpp->friendRequest(userJid);
    else
        emit error("مخاطب جدید اضافه نشد.");
}

void Bridge::playAudio(QString address)
{
    QSoundEffect* player = new QSoundEffect;
    player->setSource(QUrl(address));
    player->setVolume(1.0f);
    player->play();
}

void Bridge::shareFiles (const QString& peer)
{
    Q_ASSERT (!peer.isEmpty());

    // Get list of selected files
    QStringList _filenames =
        QFileDialog::getOpenFileNames (0, tr ("Select files"), QDir::homePath());

    // Send each file using the SIGNALS/SLOTS mechanism
    for (int i = 0; i < _filenames.count(); ++i)
        emit sendFile (_filenames.at (i), peer);
}

void Bridge::sendMessage (const QString& to, const QString &message)
{
    Q_ASSERT (!message.isEmpty());
    emit returnPressed (to, message);
}

void Bridge::newMessage(QString from, QString message)
{
    qDebug(("**************** " + from + "@----" + Settings::my_server).toLatin1());
    NotificationManager::Notify(from.section("",0,from.indexOf("@")).toLatin1() + ": " + message);
    emit drawMessage(from,message);
}

void Bridge::clearUsers()
{
    m_uuids.clear();
    m_nicknames.clear();
    imageProvider->clearImages();
}

void Bridge::processNewUser (const QString& nickname, const QString &id,
                             const QImage& profilePicture)
{
    qDebug (("++++++++++++++++ " + id).toLatin1());
    Q_ASSERT (!id.isEmpty());
    Q_ASSERT (!nickname.isEmpty());

    m_nicknames.append (nickname);
    imageProvider->addImage (profilePicture, id);
    if (!m_uuids.contains(id)) emit newUser (nickname, id);
    m_uuids.append (id);
}

void Bridge::presenceReceived(QXmppPresence presence)
{
    switch(presence.type())
    {
    case QXmppPresence::Subscribe:
        {
            // SomeOne wants to subscribe You

            return;
        }
        break;
    case QXmppPresence::Subscribed:
            // SomeOne accepted your request
        break;
    case QXmppPresence::Unsubscribe:
            // SomeOne wants to unsubscribe you
        break;
    case QXmppPresence::Unsubscribed:
        // SomeOne unsubscribed you
        break;
    default:
        return;
        break;
    }
    emit presenceReceived();
}

void Bridge::copy (const QString &string)
{
    Q_ASSERT (!string.isEmpty());

    m_clipboard->clear();
    m_clipboard->setText (string);
}

QString Bridge::getId (QString nickname)
{
    Q_ASSERT (!nickname.isEmpty());
    return m_uuids.at (m_nicknames.indexOf (nickname));
}

int Bridge::getFriendsCount()
{
    return friendsCount;
}

int Bridge::readOfflineMessages()
{
    qDebug ("//////////This is loading OFFLINE MESSAGES");
    m_xmpp->completedLoad = true;
    return m_xmpp->retrieveUnexpectedMessage();
}

void Bridge::friendsCountReceived(int count)
{
    friendsCount = count;
}

void Bridge::sendStatus (const QString &to, const QString &status)
{
    Q_ASSERT (!status.isEmpty());
    emit sendStatusSignal (to, status);
}
