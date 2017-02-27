#ifndef MYQXMPPJID_H
#define MYQXMPPJID_H

//#pragma once

#include <QtCore/QString>

class myQxmppJid
{

public:
    static myQxmppJid parse(QString jid);

    myQxmppJid();
    explicit myQxmppJid(QString node, QString domain, QString resource);

    myQxmppJid withNode(QString node) const;
    myQxmppJid withDomain(QString domain) const;
    myQxmppJid withResource(QString resource) const;

    bool isEmpty() const;

    QString full() const;
    QString bare() const;
    QString node() const;
    QString domain() const;
    QString resource() const;

private:
    QString m_full;
    QString m_bare;
    QString m_node;
    QString m_domain;
    QString m_resource;


#endif // MYQXMPPJID_H
