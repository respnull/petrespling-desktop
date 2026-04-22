import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "."

Window {
    id: advwin
    visible: false
    width: 240
    height: 240
    title: "Physics"
    color: "#000"
    flags: Qt.WindowStaysOnTopHint

    Column {
        anchors.centerIn: parent
        spacing: 10
        TextField {
            id: gravity
            width: 200
            color: "#888"
            placeholderText: "Gravity (default: 1)"
            inputMethodHints: Qt.ImhDigitsOnly
            Component.onCompleted: {
                if (win.gravity !== 0.5) text = win.gravity.toString()
            }
        }

        GroupBox {
            title: "Autopilot Settings"
            width: 200
            Column {
                spacing: 5
                CheckBox { id: optwalk; text: "Move"; checked: win.automove }
                CheckBox { id: optjump; text: "Jump"; checked: win.autojump }
            }
        }

        TextField {
            id: velocity
            width: 200
            color: "#888"
            placeholderText: "Velocity (default: 1)"
            inputMethodHints: Qt.ImhDigitsOnly
            Component.onCompleted: {
                if (win.velocityMult !== 1) text = win.velocityMult.toString()
            }
        }

        Text {
            id: warningText
            text: {
                let g = parseFloat(gravity.text)
                let v = parseFloat(velocity.text)

                if (g < 0 || v < 0) {
                    return "Both must be at least 0."
                }

                if (g === 0 && v === 0) {
                    return "Someone put effort into this."
                }

                if (g >= 100) {
                    return "What is this, the sun?"
                }

                if (v >= 20) {
                    return "It's gonna slip out of your hand."
                }

                return ""
            }

            font.pixelSize: 8
            color: {
                let g = parseFloat(gravity.text)
                let v = parseFloat(velocity.text)

                if (g >= 100 || v >= 20 || (g === 0 && v === 0)) return "#aa5500"
                return "#aa0000"
            }

            anchors.horizontalCenter: parent.horizontalCenter
            visible: gravity.text.length > 0 || velocity.text.length > 0
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                text: "Apply"
                enabled: true
                onClicked: {
                    let gval = parseFloat(gravity.text)
                    if (gval >= 0) win.gravity = gval/2
                    if (gravity.text === null || gravity.text.trim() === "") win.gravity = 0.5
                    let val = parseFloat(velocity.text)
                    if (val >= 0) win.velocityMult = val
                    if (velocity.text === null || velocity.text.trim() === "") win.velocityMult = 1

                    win.automove = optwalk.checked
                    win.autojump = optjump.checked

                    advwin.visible = false
                    if (win.gravity !== 0.5) gravity.text = (win.gravity*2).toString()
                    if (win.velocityMult !== 1) velocity.text = win.velocityMult.toString()
                    optwalk.checked = win.automove
                    optjump.checked = win.autojump
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
                    advwin.visible = false
                    if (win.gravity !== 0.5) gravity.text = (win.gravity*2).toString()
                    if (win.velocityMult !== 1) velocity.text = win.velocityMult.toString()
                    optwalk.checked = win.automove
                    optjump.checked = win.autojump
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
