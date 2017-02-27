#include "qxmppjid.h"

QxmppJid QxmppJid::parse(QString jid)
{
    auto slashIndex = jid.indexOf("/");
    auto resource = slashIndex == -1
            ? QString{}
            : jid.mid(slashIndex + 1);
    auto rest = slashIndex == -1
            ? jid
            : jid.mid(0, slashIndex);
    auto atIndex = rest.indexOf("@");
    auto domain = atIndex == -1
            ? rest
            : rest.mid(atIndex + 1);
    auto node = atIndex == -1
            ? QString{}
            : rest.mid(0, atIndex);
    return Jid{node, domain, resource};
}

QxmppJid::QxmppJid()
{
}

QxmppJid::QxmppJid(QString node, QString domain, QString resource) :
        m_node{node},
        m_domain{domain},
        m_resource{resource}
{
    m_bare = m_node.isEmpty()
            ? m_domain
            : m_node + "@" + m_domain;
    m_full = m_resource.isEmpty()
            ? m_bare
            : m_bare + "/" + m_resource;
}

QxmppJid QxmppJid::withNode(QString node) const
{
    return QxmppJid{node, m_domain, m_resource};
}

QxmppJid QxmppJid::withDomain(QString domain) const
{
    return QxmppJid{m_node, domain, m_resource};
}

QxmppJid QxmppJid::withResource(QString resource) const
{
    return QxmppJid{m_node, m_domain, resource};
}

bool QxmppJid::isEmpty() const
{
    return m_full.isEmpty();
}

QString QxmppJid::full() const
{
    return m_full;
}

QString QxmppJid::bare() const
{
    return m_bare;
}

QString QxmppJid::node() const
{
    return m_node;
}

QString QxmppJid::domain() const
{
    return m_domain;
}

QString QxmppJid::resource() const
{
    return m_resource;
}
