QT += network quick multimedia

CONFIG += c++11

linux: QMAKE_CXXFLAGS += -DAPP_VERSION=\\\"`git rev-parse --short HEAD`\\\"

# QMAKE_CXXFLAGS += -Wall -Werror -Wextra

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp tile.cpp \
    map.cpp \
    player.cpp \
    gamemanager.cpp \
    bomb.cpp \
    userplayer.cpp \
    networkclient.cpp \
    missile.cpp \
    movable.cpp

HEADERS += tile.h \
    map.h \
    player.h \
    gamemanager.h \
    bomb.h \
    userplayer.h \
    networkclient.h \
    parameters.h \
    missile.h \
    movable.h

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    qml/Button.qml \
    qml/MapSprite.qml \
    qml/BombSprite.qml \
    qml/EndScreen.qml \
    qml/main.qml \
    qml/PlayerSprite.qml \
    qml/PlayingField.qml \
    qml/StartScreen.qml \
    qml/Checkbox.qml \
    qml/MissileSprite.qml \

DISTFILES += \
    sprites/missile-empty.png \
    sprites/missile-full.png \
    sprites/missile-half.png
