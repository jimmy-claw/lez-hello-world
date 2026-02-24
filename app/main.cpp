#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
#include "HelloWorldBridge.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    qmlRegisterType<HelloWorldBridge>("LezHelloWorld", 1, 0, "HelloWorldBridge");

    QQmlApplicationEngine engine;

    QString appDir = QCoreApplication::applicationDirPath();
    engine.addImportPath(appDir + "/../qml");
    engine.load(QUrl::fromLocalFile(appDir + "/../share/main.qml"));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
