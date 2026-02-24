import QtQuick 2.15
import QtQuick.Controls 2.15
import LezHelloWorld 1.0

ApplicationWindow {
    visible: true
    width: 600
    height: 500
    title: "LEZ Hello World"
    color: "#1E1E1E"

    HelloWorldBridge {
        id: hwBridge
    }

    HelloWorldView {
        anchors.fill: parent
        bridge: hwBridge
    }
}
