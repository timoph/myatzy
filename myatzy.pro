TARGET = myatzy

QT += core quick

equals(QT_MAJOR_VERSION, 6) {
    QT += quickcontrols2
}

SOURCES += main.cpp \
    engine.cpp

OTHER_FILES += \
    qml/myatzy/ScoreButton.qml \
    qml/myatzy/MainPage.qml \
    qml/myatzy/main.qml \
    qml/myatzy/Dot.qml \
    qml/myatzy/Dice.qml \
    qml/myatzy/ScoreLabel.qml \
    qml/myatzy/MainPage.qml

HEADERS += \
    engine.h

RESOURCES += \
    resources.qrc

