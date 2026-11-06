TARGET = tst_scoring

QT += core testlib
QT -= gui
CONFIG += console testcase
CONFIG -= app_bundle

INCLUDEPATH += ..

SOURCES += tst_scoring.cpp \
    ../scoring.cpp \
    ../engine.cpp

HEADERS += \
    ../scoring.h \
    ../engine.h
