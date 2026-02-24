#ifndef HELLOWORLDBRIDGE_H
#define HELLOWORLDBRIDGE_H

#include <QObject>
#include <QString>

class HelloWorldBridge : public QObject {
    Q_OBJECT

public:
    explicit HelloWorldBridge(QObject* parent = nullptr);

    Q_INVOKABLE QString storeName(const QString& inputJson);
    Q_INVOKABLE QString readGreeting(const QString& inputJson);
    Q_INVOKABLE QString getIdl();
    Q_INVOKABLE QString version();
};

#endif // HELLOWORLDBRIDGE_H
