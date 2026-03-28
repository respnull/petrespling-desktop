import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "."

Window {
    id: reswin
    visible: false
    width: 200
    height: 120
    title: "Resize"
    color: "#000"
    flags: Qt.WindowStaysOnTopHint

    Column {
        anchors.centerIn: parent
        spacing: 10

        TextField {
            id: size
            width: 180
            color: "#888"
            placeholderText: "Width & Height..."
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Apply"
                enabled: {
                    let val = parseInt(size.text)
                    return !isNaN(val) && val >= 32 && val <= Math.min(Screen.width, Screen.height)
                }
                onClicked: {
                    let val = parseInt(size.text)
                    win.width = val
                    win.height = val
                    reswin.visible = false
                    size.text = ""
                }
                contentItem: Text {
                    text: parent.text
                    color: "#888"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }

            Button {
                text: "Cancel"
                onClicked: {
                    reswin.visible = false
                    size.text = ""
                }
                contentItem: Text {
                    text: parent.text
                    color: "#888"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                }
            }
        }
    }
}
