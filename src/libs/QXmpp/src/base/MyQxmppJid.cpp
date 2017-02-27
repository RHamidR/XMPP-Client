#include "myqxmppjid.h"

myQxmppJid::myQxmppJid()
{
}

myQxmppJid::myQxmppJid(QString node, QString domain, QString resource) :
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

myQxmppJid myQxmppJid::parse(QString jid)
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
    auto node = (atIndex == -1
            ? QString{}
            : rest.mid(0, atIndex));
    return Jid{node, domain, resource};
}


myQxmppJid myQxmppJid::withNode(QString node) const
{
    return myQxmppJid{node, m_domain, m_resource};
}

myQxmppJid myQxmppJid::withDomain(QString domain) const
{
    return myQxmppJid{m_node, domain, m_resource};
}

myQxmppJid myQxmppJid::withResource(QString resource) const
{
    return myQxmppJid{m_node, m_domain, resource};
}

bool myQxmppJid::isEmpty() const
{
    return m_full.isEmpty();
}

QString myQxmppJid::full() const
{
    return m_full;
}

QString myQxmppJid::bare() const
{
    return m_bare;
}

QString myQxmppJid::node() const
{
    return m_node;
}

QString myQxmppJid::domain() const
{
    return m_domain;
}

QString myQxmppJid::resource() const
{
    return m_resource;
}
