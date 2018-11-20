TARGET = myatzy

greaterThan(QT_MAJOR_VERSION, 4) {
	QT += core quick widgets
	DEFINES += QT5BUILD
}
else {
	QT += core gui declarative
}

macx {
	CONFIG -= app_bundle
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

