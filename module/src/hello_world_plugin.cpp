#include <QtQml/QQmlExtensionPlugin>
#include <QtQml/qqml.h>
#include "HelloWorldBridge.h"

class HelloWorldPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    void registerTypes(const char* uri) override
    {
        qmlRegisterType<HelloWorldBridge>(uri, 1, 0, "HelloWorldBridge");
    }
};

#include "hello_world_plugin.moc"
