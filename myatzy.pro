# Add more folders to ship with the application, here
#folder_01.source = qml/myatzy
#folder_01.target = qml
#DEPLOYMENTFOLDERS = folder_01
TARGET = myatzy
QT += core gui declarative

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE7E447BB

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# build configuration for n900 screen or n9 screen. comment this to build for nemo or
# pass CONFIG+=nemo to qmake
# CONFIG += nemo

# The .cpp file which was generated for your project. Feel free to hack it.
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

CONFIG(nemo) {
    RESOURCES += \
        resources_n900.qrc
    message(Building for Nemo)
} else {
    RESOURCES += \
        resources.qrc
    message(Building for Harmattan)
}

contains(MEEGO_EDITION,harmattan) {
    target.path = /opt/myatzy/bin
    INSTALLS += target
}

contains(MEEGO_EDITION,harmattan) {
    desktopfile.files = $${TARGET}.desktop
    desktopfile.path = /usr/share/applications
    INSTALLS += desktopfile
}

contains(MEEGO_EDITION,harmattan) {
    icon.files = myatzy80.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
}
