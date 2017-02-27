TEMPLATE = app
CONFIG += c++11
TARGET = Messenger
CONFIG += qtquickcompiler

include($$PWD/../libs/Xmpp/Xmpp.pri)
include($$PWD/../libs/Notification/Notification.pri)

LIBS += -L$$OUT_PWD/../libs/QXmpp -lqxmpp
QT += svg xml gui qml quick widgets multimedia

HEADERS += $$PWD/src/*.h
#\
#    src/customquickwindow.h
SOURCES += $$PWD/src/*.cpp
#\
#    src/customquickwindow.cpp
RESOURCES += $$PWD/res/res.qrc

macx {
    TARGET = "Messenger"
    ICON = $$PWD/../../data/mac/icon.icns
    RC_FILE = $$PWD/../../data/mac/info.plist
    QMAKE_INFO_PLIST = $$PWD/../../data/mac/info.plist
}

linux:!android {
    target.path    = /usr/bin
    desktop.path   = /usr/share/applications
    desktop.files += $$PWD/../../data/linux/messenger.desktop
    INSTALLS      += target desktop
}

win32* {
    TARGET = "Messenger"
    RC_FILE = $$PWD/../../data/windows/manifest.rc
}

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/../../data/android/
}

ios {
    ICONS.files = $$PWD/../../data/ios/icon.png
    QMAKE_INFO_PLIST = $$PWD/../../data/ios/info.plist
    QMAKE_BUNDLE_DATA += ICONS
    HEADERS -=
    SOURCES -=
}

DISTFILES += \
    ../../data/android/gradle/wrapper/gradle-wrapper.jar \
    ../../data/android/AndroidManifest.xml \
    ../../data/android/res/values/libs.xml \
    ../../data/android/build.gradle \
    ../../data/android/gradle/wrapper/gradle-wrapper.properties \
    ../../data/android/gradlew \
    ../../data/android/gradlew.bat \
    ../../data/android/src/net/notnamed/chat/NotificationClient.java
