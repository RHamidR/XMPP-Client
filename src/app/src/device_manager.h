#ifndef DEVICE_MANAGER_H
#define DEVICE_MANAGER_H

#include <math.h>

#include <QObject>
#include <QScreen>
#include <QApplication>

class DeviceManager : public QObject
{
        Q_OBJECT

    public:
        DeviceManager();

        Q_INVOKABLE bool isMobile();
        Q_INVOKABLE qreal ratio (int value);

    private:

        QRect m_rect;
        double m_ratio;
};

#endif
