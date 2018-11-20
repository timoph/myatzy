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
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/myatzy/ScoreLabel.qml \
    qml/myatzy/MainPage_n900.qml

HEADERS += \
    engine.h

RESOURCES += \
    resources_n900.qrc

