#include "device_manager.h"

DeviceManager::DeviceManager()
{
#ifdef Q_OS_ANDROID
    // Scale the QML UI to match the size and DPI of
    // the device's screen
    QRect _screen = qApp->primaryScreen()->geometry();
    m_ratio = 1.8 * qMin (qMax (_screen.width(), _screen.height()) / 1136.,
                          qMin (_screen.width(), _screen.height()) / 640.);
#else
    // Scale the QML interface to a ratio of 1:1
    m_ratio = 1.0;
#endif
}

bool DeviceManager::isMobile()
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_BLACKBERRY)
    return true;
#else
    return false;
#endif
}

qreal DeviceManager::ratio (int value)
{
    return value * m_ratio;
}
