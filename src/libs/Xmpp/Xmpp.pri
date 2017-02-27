CONFIG += c++11


LIBS += -L$$OUT_PWD/../libs/QXmpp -lqxmpp

SOURCES += $$PWD/src/xmpp.cpp \
    $$PWD/src/xmppregister.cpp
HEADERS += $$PWD/src/xmpp.h \
    $$PWD/src/xmppregister.h

#OTHER_FILES += $$PWD/src/Xmpp

INCLUDEPATH += $$PWD/src \
               $$PWD/../QXmpp/src/base \
               $$PWD/../QXmpp/src/client \
               $$PWD/../QXmpp/src/server

DISTFILES += \
    $$PWD/../../app/res/qml/ShareFileControls.qml
