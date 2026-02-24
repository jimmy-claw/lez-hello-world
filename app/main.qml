import QtQuick
import QtQuick.Window
import LezHelloWorld 1.0

Window {
    visible: true
    width: 480
    height: 640
    title: "LEZ Hello World"

    HelloWorldView {
        anchors.fill: parent
        bridge: HelloWorldBridge {}
    }
}
