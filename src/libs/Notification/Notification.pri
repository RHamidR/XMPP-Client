#ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
INCLUDEPATH += $$PWD
SOURCES += \
    $$PWD/notificationmanager.cpp
#    $$PWD/notificationclient.cpp

android:SOURCES +=      $$PWD/notificationclient_android.cpp
else:symbian:SOURCES += $$PWD/notificationclient_symbian.cpp
else:unix:SOURCES +=    $$PWD/notificationclient_desktops.cpp
else:win32:SOURCES +=   $$PWD/notificationclient_desktops.cpp
else:SOURCES +=         $$PWD/notificationclient_stub.cpp

HEADERS += \
    $$PWD/notificationclient.h \
    $$PWD/notificationmanager.h

android {
    OTHER_FILES += \
        #$$PWD/../../../data/android/src/net/notnamed/chat/notification/NotificationClient.java \
        #$$PWD/../../../data/android/AndroidManifest.xml

    QT += androidextras
}
