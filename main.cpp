/*
 Myatzy - a version of the dice game Yatzy
 Copyright (C) 2021 Timo Härkönen

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QSettings>

#if QT_VERSION_MAJOR == 6
#include <QQuickStyle>
#endif

#include "engine.h"

// Earlier versions did not set an organization name, so QSettings stored the
// high scores under "Unknown Organization". Copy them over once.
static void migrateOldSettings()
{
    QSettings settings;
    if(settings.contains("high/1"))
        return;

    QSettings old("Unknown Organization", QCoreApplication::applicationName());
    const QStringList keys = old.allKeys();
    for(const QString &key : keys)
        settings.setValue(key, old.value(key));
}

int main(int argc, char *argv[])
{
#if QT_VERSION_MAJOR == 6
    QQuickStyle::setStyle("Basic");
#else
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName("myatzy");
    QCoreApplication::setApplicationName("myatzy");
    migrateOldSettings();

    QQmlApplicationEngine qml;
	QScopedPointer<Engine> engine(new Engine());
    qml.rootContext()->setContextProperty("engine", engine.data());
    qml.load(QUrl("qrc:/qml/main.qml"));

    return app.exec();
}
