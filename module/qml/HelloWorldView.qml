import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property var bridge

    // Stored state data (simulates PDA state)
    property string storedStateData: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header
        Text {
            text: "Hello World - LEZ Module"
            font.pixelSize: 24
            font.bold: true
            color: "#FF8800"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Store your name on-chain and get a greeting back!"
            font.pixelSize: 14
            color: "#CCCCCC"
            Layout.alignment: Qt.AlignHCenter
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }

        // Input section
        ColumnLayout {
            spacing: 8
            Layout.fillWidth: true

            Text {
                text: "Enter your name:"
                font.pixelSize: 14
                color: "#EEEEEE"
            }

            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                TextField {
                    id: nameInput
                    placeholderText: "Your name..."
                    Layout.fillWidth: true
                    font.pixelSize: 14
                    color: "#EEEEEE"
                    background: Rectangle {
                        color: "#2A2A2A"
                        border.color: nameInput.activeFocus ? "#FF8800" : "#444444"
                        border.width: 1
                        radius: 4
                    }
                    placeholderTextColor: "#666666"
                }

                Button {
                    text: "Submit"
                    enabled: nameInput.text.length > 0
                    onClicked: submitName()

                    background: Rectangle {
                        color: parent.enabled ? "#FF8800" : "#555555"
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.bold: true
                        color: "#FFFFFF"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // Separator
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "#333333"
        }

        // Result section
        ColumnLayout {
            spacing: 8
            Layout.fillWidth: true

            Text {
                text: "Result:"
                font.pixelSize: 14
                color: "#EEEEEE"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 80
                color: "#1E1E1E"
                border.color: "#333333"
                border.width: 1
                radius: 4

                Text {
                    id: resultText
                    anchors.centerIn: parent
                    text: "No greeting yet. Submit a name above!"
                    font.pixelSize: 16
                    color: "#AAAAAA"
                }
            }

            Button {
                text: "Read Greeting"
                enabled: storedStateData.length > 0
                onClicked: readGreeting()

                background: Rectangle {
                    color: parent.enabled ? "#2A6BBF" : "#555555"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Status bar
        Text {
            id: statusText
            text: ""
            font.pixelSize: 12
            color: "#888888"
            Layout.alignment: Qt.AlignHCenter
        }

        Item { Layout.fillHeight: true }
    }

    function submitName() {
        if (!bridge) {
            resultText.text = "Error: Bridge not connected";
            resultText.color = "#FF4444";
            return;
        }

        var input = JSON.stringify({ "name": nameInput.text });
        var response = bridge.storeName(input);
        var result = JSON.parse(response);

        if (result.success) {
            storedStateData = result.state_data;
            resultText.text = result.greeting;
            resultText.color = "#FF8800";
            statusText.text = "Name stored successfully!";
        } else {
            resultText.text = "Error: " + result.error;
            resultText.color = "#FF4444";
            statusText.text = "Transaction failed.";
        }
    }

    function readGreeting() {
        if (!bridge) {
            resultText.text = "Error: Bridge not connected";
            resultText.color = "#FF4444";
            return;
        }

        var input = JSON.stringify({ "state_data": storedStateData });
        var response = bridge.readGreeting(input);
        var result = JSON.parse(response);

        if (result.success) {
            resultText.text = result.greeting;
            resultText.color = "#44FF44";
            statusText.text = "Read from PDA state.";
        } else {
            resultText.text = "Error: " + result.error;
            resultText.color = "#FF4444";
            statusText.text = "Read failed.";
        }
    }
}
