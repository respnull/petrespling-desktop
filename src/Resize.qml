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
            placeholderText: "Size in pixels..."
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Text {
            id: warningText
            text: {
                let val = parseInt(size.text)
                if (isNaN(val) || val < 16) {
                    return "Must be at least 16."
                } else if (val > Screen.height) {
                    return "Must be below " + Screen.height + "."
                } else if (val % 16 !== 0) {
                    return "Recommended to be divisible by 16."
                } else if (val < 64) {
                    return "Recommended to be at least 64."
                } else {
                    return ""
                }
            }
            font.pixelSize: 8
            color: text.length >= 30 ? "#aa5500" : "#aa0000"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: size.text.length > 0
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Apply"
                enabled: {
                    let val = parseInt(size.text)
                    return !isNaN(val) && val >= 16 && val <= Math.min(Screen.width, Screen.height)
                }
                onClicked: {
                    let val = parseInt(size.text)
                    if (val >= 16 && val <= Math.min(Screen.width, Screen.height)) {
                        let hval = val * (1.5 + 0.5 * ((win.hatH - 8) / 8))
                        if (win.hatID === -1) hval = val

                        win.minimumWidth = val
                        win.minimumHeight = hval
                        win.maximumWidth = val
                        win.maximumHeight = hval
                        win.width = val
                        win.height = hval
                        reswin.visible = false
                        size.text = ""
                    }
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
