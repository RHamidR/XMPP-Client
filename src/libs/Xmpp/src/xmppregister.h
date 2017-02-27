#ifndef XMPPREGISTER_H
#define XMPPREGISTER_H

#include <QObject>
#include "QXmppRegisterIq.h"
#include "QXmppClient.h"

class xmppRegister : public QObject
{
    Q_OBJECT
    QXmppClient *client_;
public:
    explicit xmppRegister(QString domain, QString username, QString password, QString email);//, QString nickname);
    ~xmppRegister();
    void start();

signals:
    void errorOccured(const QString);
    void successful(const QString);
    void complete();
private:
    void getForm();
    void setForm();
//    void testSetWithForm();
    QString domain_;
    QString _username;
    QString _password;
    //QString _nickname;
    QString _email;

    void HandleRegResult (const QXmppIq& iq);
//    enum class State {
                const static char
            Error_State //,
                = 'E'; const static char
            Idle_State //,
                = 'I'; const static char
            Connecting_State //,
                = 'C'; const static char
            FetchingForm_State //,
                = 'F'; const static char
            AwaitingRegistrationResult_State
                = 'R';
//    };
    char state_;
//    State state_;
private slots:
    void handleClientError(QXmppClient::Error error);
    void handleConnected();
    void handleIqReceived (const QXmppIq&);
};

#endif // XMPPREGISTER_H
