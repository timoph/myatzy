TARGET = myatzy

QT += core quick

equals(QT_MAJOR_VERSION, 6) {
    QT += quickcontrols2
}

SOURCES += main.cpp \
    engine.cpp

HEADERS += \
    engine.h

RESOURCES += \
    resources.qrc

