#include "HelloWorldBridge.h"
#include "hello_program.h"

HelloWorldBridge::HelloWorldBridge(QObject* parent)
    : QObject(parent)
{
}

QString HelloWorldBridge::storeName(const QString& inputJson)
{
    char* result = hello_store_name(inputJson.toUtf8().constData());
    QString response = QString::fromUtf8(result);
    hello_free_string(result);
    return response;
}

QString HelloWorldBridge::readGreeting(const QString& inputJson)
{
    char* result = hello_read(inputJson.toUtf8().constData());
    QString response = QString::fromUtf8(result);
    hello_free_string(result);
    return response;
}

QString HelloWorldBridge::getIdl()
{
    char* result = hello_get_idl();
    QString response = QString::fromUtf8(result);
    hello_free_string(result);
    return response;
}

QString HelloWorldBridge::version()
{
    char* result = hello_version();
    QString response = QString::fromUtf8(result);
    hello_free_string(result);
    return response;
}
