/****************************************************************************
**
** Copyright (C) 2012 Jeremy Lainé <jeremy.laine@m4x.org>
** Contact: http://www.qt-project.org/
**
** This file is part of the QtNetwork module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QDNSLOOKUP_P_H
#define QDNSLOOKUP_P_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists for the convenience
// of the QDnsLookup class.  This header file may change from
// version to version without notice, or even be removed.
//
// We mean it.
//

#include <QHostAddress>
#include <QMetaType>
#include <QMutex>
#include <QRunnable>
#include <QSharedPointer>
#include <QThreadPool>

#include "qdnslookup.h"

QT_BEGIN_NAMESPACE

//#define QDNSLOOKUP_DEBUG

class QDnsLookupRunnable;

class QDnsLookupReply
{
    public:
        QDnsLookupReply()
            : error (QDnsLookup::NoError)
        {
        }

        QDnsLookup::Error error;
        QString errorString;

        QList<QDnsDomainNameRecord> canonicalNameRecords;
        QList<QDnsHostAddressRecord> hostAddressRecords;
        QList<QDnsMailExchangeRecord> mailExchangeRecords;
        QList<QDnsDomainNameRecord> nameServerRecords;
        QList<QDnsDomainNameRecord> pointerRecords;
        QList<QDnsServiceRecord> serviceRecords;
        QList<QDnsTextRecord> textRecords;
};

class QDnsLookupPrivate
{
    public:
        QDnsLookupPrivate (QDnsLookup *qq)
            : isFinished (false)
            , type (QDnsLookup::A)
            , runnable (0)
            , q_ptr (qq)
        {
        }

        void _q_lookupFinished (const QDnsLookupReply &reply);

        bool isFinished;
        QString name;
        QDnsLookup::Type type;
        QDnsLookupReply reply;
        QDnsLookupRunnable *runnable;
        QDnsLookup *q_ptr;

        Q_DECLARE_PUBLIC (QDnsLookup)
};

class QDnsLookupRunnable : public QObject, public QRunnable
{
        Q_OBJECT

    public:
        QDnsLookupRunnable (QDnsLookup::Type type, const QByteArray &name)
            : requestType (type)
            , requestName (name)
        {
        }
        void run();

    signals:
        void finished (const QDnsLookupReply &reply);

    private:
        static void query (const int requestType, const QByteArray &requestName, QDnsLookupReply *reply);
        QDnsLookup::Type requestType;
        QByteArray requestName;
};

class QDnsLookupThreadPool : public QThreadPool
{
        Q_OBJECT

    public:
        QDnsLookupThreadPool();
        void start (QRunnable *runnable);

    private slots:
        void _q_applicationDestroyed();

    private:
        QMutex signalsMutex;
        bool signalsConnected;
};

class QDnsRecordPrivate : public QSharedData
{
    public:
        QDnsRecordPrivate()
            : timeToLive (0)
        {
        }

        QString name;
        quint32 timeToLive;
};

class QDnsDomainNameRecordPrivate : public QDnsRecordPrivate
{
    public:
        QDnsDomainNameRecordPrivate()
        {
        }

        QString value;
};

class QDnsHostAddressRecordPrivate : public QDnsRecordPrivate
{
    public:
        QDnsHostAddressRecordPrivate()
        {
        }

        QHostAddress value;
};

class QDnsMailExchangeRecordPrivate : public QDnsRecordPrivate
{
    public:
        QDnsMailExchangeRecordPrivate()
            : preference (0)
        {
        }

        QString exchange;
        quint16 preference;
};

class QDnsServiceRecordPrivate : public QDnsRecordPrivate
{
    public:
        QDnsServiceRecordPrivate()
            : port (0),
              priority (0),
              weight (0)
        {
        }

        QString target;
        quint16 port;
        quint16 priority;
        quint16 weight;
};

class QDnsTextRecordPrivate : public QDnsRecordPrivate
{
    public:
        QDnsTextRecordPrivate()
        {
        }

        QList<QByteArray> values;
};

QT_END_NAMESPACE

Q_DECLARE_METATYPE (QDnsLookupReply)

#endif // QDNSLOOKUP_P_H
