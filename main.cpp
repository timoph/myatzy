#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>

#if QT_VERSION_MAJOR == 6
#include <QQuickStyle>
#endif

#include "engine.h"

int main(int argc, char *argv[])
{
#if QT_VERSION_MAJOR == 6
    QQuickStyle::setStyle("Basic");
#else
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine qml;
	QScopedPointer<Engine> engine(new Engine());
    qml.rootContext()->setContextProperty("engine", engine.data());
    qml.load(QUrl("qrc:/main.qml"));

    return app.exec();
}
