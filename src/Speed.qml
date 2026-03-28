import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "."

Window {
    id: spdwin
    visible: false
    width: 600
    height: 250
    title: "Speed"
    color: "#000"
    flags: Qt.WindowStaysOnTopHint

    property real timeFactor: 1.0
    property real speedmult: 1.0

    Column {
        anchors.centerIn: parent
        spacing: 10

        Label {
            text: "Time Factor will multiply most caretaking intervals by the value specified below.\n"
                  + "If value is set to 0, caretaking will be disabled."
            color: "#888"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 12
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            TextField {
                id: factorField
                width: 100
                color: "#888"
                placeholderText: "Value..."
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                text: timeFactor.toFixed(2)

                onEditingFinished: {
                    var val = parseFloat(factorField.text)
                    if (!isNaN(val) && val >= 0) {
                        spdwin.timeFactor = val
                    } else {
                        factorField.text = spdwin.timeFactor.toFixed(2)
                    }
                }
            }

            Button {
                text: "Apply"
                enabled: {
                    var val = parseFloat(factorField.text)
                    return !isNaN(val) && val >= 0
                }
                onClicked: {
                    spdwin.timeFactor = parseFloat(factorField.text)
                    speedmult = spdwin.timeFactor
                    if (speedmult <= 0) {
                        optwin.hunger = 99
                        optwin.thirst = 99
                        optwin.sleepiness = 99
                    } else {
                        optwin.hunger = Math.min(optwin.hunger, 10)
                        optwin.thirst = Math.min(optwin.hunger, 10)
                        optwin.sleepiness = Math.min(optwin.hunger, 10)
                    }
                    spdwin.visible = false
                }
                contentItem: Text {
                    text: parent.text
                    color: "#888"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Button {
                text: "Cancel"
                onClicked: {
                    spdwin.visible = false
                    factorField.text = spdwin.timeFactor.toFixed(2)
                }
                contentItem: Text {
                    text: parent.text
                    color: "#888"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Column {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                text: "Losing Sleep Timer: " + 60.0/spdwin.timeFactor + "-" + 90.0/spdwin.timeFactor + " seconds"
                color: "#888"
                font.pixelSize: 12
            }
            Label {
                text: "Getting Sleep Timer: " + 15.0/spdwin.timeFactor + "-" + 30.0/spdwin.timeFactor + " seconds"
                color: "#888"
                font.pixelSize: 12
            }
            Label {
                text: "Getting Hungry Timer: " + 60.0/spdwin.timeFactor + "-" + 90.0/spdwin.timeFactor + " seconds"
                color: "#888"
                font.pixelSize: 12
            }
            Label {
                text: "Getting Thirsty Timer: " + 30.0/spdwin.timeFactor + "-" + 60.0/spdwin.timeFactor + " seconds"
                color: "#888"
                font.pixelSize: 12
            }
        }
    }
}
