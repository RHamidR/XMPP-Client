#ifndef QXMPPJID_H
#define QXMPPJID_H

#pragma once

#include <QtCore/QString>

class QxmppJid
{

public:
    static QxmppJid parse(QString jid);

    QxmppJid();
    explicit QxmppJid(QString node, QString domain, QString resource);

    QxmppJid withNode(QString node) const;
    QxmppJid withDomain(QString domain) const;
    QxmppJid withResource(QString resource) const;

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


#endif // QXMPPJID_H
