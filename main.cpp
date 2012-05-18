#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include "engine.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("timoph");
    QCoreApplication::setOrganizationDomain("timoph.fi");
    QCoreApplication::setApplicationName("myatzy");
    QApplication app(argc, argv);
    QDeclarativeView viewer;
    QScopedPointer<Engine> engine(new Engine());
    viewer.rootContext()->setContextProperty("engine", engine.data());
    viewer.setSource(QUrl("qrc:///main.qml"));
    viewer.showFullScreen();
    return app.exec();
}
