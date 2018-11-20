#include <QGuiApplication>

#ifdef QT5BUILD
#include <QQmlContext>
#include <QQmlApplicationEngine>
#else
#include <QDeclarativeContext>
#include <QDeclarativeView>
#endif

#include "engine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
#ifdef QT5BUILD
    QQmlApplicationEngine qml;
#else
    QDeclarativeView qml;
#endif
	QScopedPointer<Engine> engine(new Engine());
    qml.rootContext()->setContextProperty("engine", engine.data());
#ifdef QT5BUILD
    qml.load(QUrl("qrc:///main.qml"));
#else
    qml.setSource(QUrl("qrc:///main.qml"));
#endif

    return app.exec();
}
