#include <QApplication>

#ifdef QT5BUILD
#include <QQmlContext>
#include <QQuickView>
#else
#include <QDeclarativeContext>
#include <QDeclarativeView>
#endif

#include "engine.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("timoph");
    QCoreApplication::setOrganizationDomain("timoph.fi");
    QCoreApplication::setApplicationName("myatzy");
    QApplication app(argc, argv);
#ifdef QT5BUILD
    QQuickView viewer;
#else
    QDeclarativeView viewer;
#endif
	QScopedPointer<Engine> engine(new Engine());
	viewer.rootContext()->setContextProperty("engine", engine.data());
    viewer.setSource(QUrl("qrc:///main.qml"));
//    viewer.showFullScreen();
    return app.exec();
}
