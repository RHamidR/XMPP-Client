#include "xmppregister.h"
#include <QDomDocument>
#include <QBuffer>
#include <QApplication>
#include "QXmppRosterIq.h"

//#include <QtTest/QtTest>

/*
template <class T>
static void parsePacket(T &packet, const QByteArray &xml)
{
    //qDebug ("parsing " + xml);
    QDomDocument doc;
    QDomElement element = doc.documentElement();
    packet.parse(element);
}
template <class T>
static void serializePacket(T &packet, const QByteArray &xml)
{
    QBuffer buffer;
    buffer.open(QIODevice::ReadWrite);
    QXmlStreamWriter writer(&buffer);
    packet.toXml(&writer);
    //qDebug("expect " + xml);
    //qDebug( "writing" + buffer.data());

}
*/
xmppRegister::xmppRegister(QString domain, QString username, QString password, QString email)//, QString nickname)
{
    _username   = username;
    _password   = password;
    _email      = email;
    //_nickname   = nickname;

    state_ = Idle_State;
    client_ = new QXmppClient(0);
    domain_ = domain;
}

xmppRegister::~xmppRegister()
{
    delete client_;
    //this->~QObject();
    //this->deleteLater();
}


void xmppRegister::start()
{
    connect (client_,SIGNAL(connected()),this,SLOT(handleConnected()));
    connect (client_,SIGNAL(error(QXmppClient::Error)),this,SLOT(handleClientError(QXmppClient::Error)));
    connect (client_,SIGNAL(iqReceived(QXmppIq)),this,SLOT(handleIqReceived(QXmppIq)));

    QXmppConfiguration conf;
    conf.setDomain (domain_);
    conf.setUseNonSASLAuthentication (false);
    conf.setUseSASLAuthentication (false);
    state_ = Connecting_State;
    client_->connectToServer (conf);
}

void xmppRegister::getForm()
{
    QXmppRegisterIq iq;
    iq.setId ("reg1");
    iq.setTo(domain_);
    iq.setType(QXmppIq::Get);

    client_->sendPacket(iq);

    QBuffer buffer;
    buffer.open(QIODevice::ReadWrite);
    QXmlStreamWriter writer(&buffer);
    iq.toXml(&writer);
    qDebug("SendGet  " + buffer.data());
}

void xmppRegister::setForm()
{
    /*
    const QByteArray xml(
        "<iq id=\"reg2\" type=\"set\">"
        "<query xmlns=\"jabber:iq:register\">"
        "<username>bill</username>"
        "<password>Calliope</password>"
        "<email>bard@shakespeare.lit</email>"
        "</query>"
        "</iq>");
    //QXmppElementList userProperties();
    //userProperties.
    //userProperties.insert();
    */
    QXmppRegisterIq iq=QXmppRegisterIq();
    /*
    QXmppElement formPart;
    formPart.setTagName("name");
    formPart.setValue(_nickname);
    iq.setExtensions(QXmppElementList() << formPart);
    //iq.extensions().insert(0,formPart);
    */
    iq.setId("reg2");
    iq.setType(QXmppIq::Set);
    iq.setUsername(_username);
    iq.setPassword(_password);
    iq.setEmail(_email);



    QBuffer buffer;
    buffer.open(QIODevice::ReadWrite);
    QXmlStreamWriter writer(&buffer);
    iq.toXml(&writer);
    qDebug("Set  " + buffer.data());

    client_->sendPacket(iq);
}
/*
void xmppRegister::testSetWithForm()
{
    const QByteArray xml(
        "<iq id=\"reg4\" to=\"contests.shakespeare.lit\" from=\"juliet@capulet.com/balcony\" type=\"set\">"
        "<query xmlns=\"jabber:iq:register\">"
        "<x xmlns=\"jabber:x:data\" type=\"submit\">"
        "<field type=\"hidden\" var=\"FORM_TYPE\">"
        "<value>jabber:iq:register</value>"
        "</field>"
        "<field type=\"text-single\" label=\"Given Name\" var=\"first\">"
        "<value>Juliet</value>"
        "</field>"
        "<field type=\"text-single\" label=\"Family Name\" var=\"last\">"
        "<value>Capulet</value>"
        "</field>"
        "<field type=\"text-single\" label=\"Email Address\" var=\"email\">"
        "<value>juliet@capulet.com</value>"
        "</field>"
        "<field type=\"list-single\" label=\"Gender\" var=\"x-gender\">"
        "<value>F</value>"
        "</field>"
        "</x>"
        "</query>"
        "</iq>");

    QXmppRegisterIq iq;
    parsePacket(iq, xml);
    serializePacket(iq, xml);
}
*/
void xmppRegister::handleConnected ()
{
    qDebug("Connected");
    state_ = FetchingForm_State;
    getForm();
}

void xmppRegister::handleClientError (QXmppClient::Error error)
{
    qDebug("Errored");
    QString msg;
    switch (error)
    {
    case QXmppClient::SocketError:
        msg = tr ("خطا در اتصال به سرور - لطفا ارتباط با اینترنت را چک کنید. - کد") + ' ' + QString::number (client_->socketError ()) + '.';
        break;
    case QXmppClient::KeepAliveError:
        msg = tr ("ارتباط شما قطع شد.");
        break;
    case QXmppClient::XmppStreamError:
        msg = tr ("ثبت نام انجام نشد - کد") + ' ' + QString::number (client_->xmppStreamError ()) + '.';
        break;
    case QXmppClient::NoError:
        msg = tr ("خطای ناشناخته");
        break;
    }

    emit errorOccured(msg);
    this->~xmppRegister();
}

void xmppRegister::HandleRegResult (const QXmppIq& iq)
{
    if (iq.type () == QXmppIq::Result)
    {
        emit successful("ثبت نام با موفقیت انجام شد.");
        return;
    }
    else if (iq.type () != QXmppIq::Error)
    {
        qWarning () << Q_FUNC_INFO
                << "strange iq type"
                << iq.type ();
        return;
    }

    QString msg;
    for (int i=0; i<iq.extensions().length();i++)
    {
        QXmppElement elem = iq.extensions().at(i);
        if (elem.tagName () != "error")
            continue;

        if (!elem.firstChildElement ("conflict").isNull ())
            msg = tr ("شما قبلا ثبت نام کرده اید.");
        else if (!elem.firstChildElement ("not-acceptable").isNull ())
            msg = tr ("اطلاعات توسط سرور پذیرفته نیست");
        else
            msg = tr ("خطا:") +
                ' ' + elem.firstChildElement ().tagName ();
    }
    if (msg.isEmpty ())
        msg = tr ("ثبت نام با خطا مواجه شد. لطفا دوباره امتحان کنید.");
    emit errorOccured(msg);
    emit complete();
}
void xmppRegister::handleIqReceived (const QXmppIq& iq)
{
    //if (iq.id () != LastStanzaID_)
    //    return;

    //qDebug ("The IQ is Received **************");
    QBuffer buffer;
    buffer.open(QIODevice::ReadWrite);
    QXmlStreamWriter writer(&buffer);
    iq.toXml(&writer);
    //qDebug( "writing" + buffer.data());

    switch (state_)
    {
    case FetchingForm_State:
        state_ = AwaitingRegistrationResult_State;
        setForm();
        break;
    case AwaitingRegistrationResult_State:
        //qDebug("Register Completed");
        HandleRegResult(iq);
        break;
    default:
        qWarning (Q_FUNC_INFO);
        break;
    }
}
//QTEST_MAIN(xmppRegister)
//#include "moc_xmppregister.moc"
