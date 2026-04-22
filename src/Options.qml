import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "."

Window {
    id: optwin
    property var mwin
    property var speedwin
    property alias optd: opt_d
    property alias opte: opt_e
    property alias optg: opt_g
    visible: false
    width: 120
    height: Math.min(column.implicitHeight+10, Screen.height-50)
    flags: Qt.FramelessWindowHint | Qt.Popup | Qt.WindowStaysOnTopHint

    property var pixelData: pixelData_0
    property int imgW: 16
    property int imgH: 16

    property bool sleeping: false
    property int sleepFrame: 0
    property int sleepiness: 10
    property bool drool: false

    property int hunger: 10
    property int thirst: 10

    function idlesprite() {
        if (hunger < 2 || thirst < 2) return pixelData_3
        return pixelData_0
    }

    Timer {
        id: sleepAnim
        interval: 1800 + Math.random() * 200
        repeat: true
        onTriggered: {
            if (!sleeping) return
            sleepFrame = 1 - sleepFrame
            if (sleepFrame === 0) {
                win.pixelData = pixelData_4
            } else {
                win.pixelData = pixelData_5
            }
        }
    }

    Timer {
        id: exh
        interval: (60000 + Math.random() * 30000) / Math.max(spdwin.speedmult, 0.0001)
        repeat: true
        running: true
        onTriggered: {
            if (spdwin.speedmult <= 0) return
            if (sleepiness > 0) sleepiness--
            if (sleepiness === 0 && !sleeping) {
                opt_j.clicked()
                reg.start()
                exh.stop()
            }
        }
    }

    Timer {
        id: reg
        interval: (15000 + Math.random() * 15000) / Math.max(spdwin.speedmult, 0.0001)
        repeat: true
        running: false
        onTriggered: {
            if (spdwin.speedmult <= 0) return
            if (sleepiness < 10) sleepiness++
            if (sleepiness === 10 && sleeping) {
                sleeping = false
		        sleepAnim.stop()
		        drool = Math.random() > 0.96
		        if (!drool) win.pixelData = idlesprite()
		        else tdrool.start()

                opt_i.enabled = true
                opt_h.enabled = true

                exh.start()
                reg.stop()
            }
        }
    }

    Timer {
        id: tdrool
        interval: 1000
        repeat: false
        running: false
        onTriggered: {
            win.pixelData = pixelData_6
            tdroolr.start()
        }
    }

    Timer {
        id: tdroolr
        interval: 1000
        repeat: false
        running: false
        onTriggered: { win.pixelData = idlesprite() }
    }

    Timer {
        id: stomach
        interval: (60000 + Math.random() * 30000) / Math.max(spdwin.speedmult, 0.0001)
        repeat: true
        running: true
        onTriggered: {
            if (spdwin.speedmult <= 0) return
            if (hunger > 0) hunger--
            if (hunger < 2 && win.pixelData === pixelData_0) win.pixelData = pixelData_2

        }
    }

    Timer {
        id: h2o
        interval: (30000 + Math.random() * 30000) / Math.max(spdwin.speedmult, 0.0001)
        repeat: true
        running: true
        onTriggered: {
            if (spdwin.speedmult <= 0) return
            if (thirst > 0) thirst--
            if (thirst < 2 && win.pixelData === pixelData_0) win.pixelData = pixelData_2
        }
    }

    Column {
        id: column
        spacing: 0
        clip: true

        Component.onCompleted: {
            optwin.height = Math.min(column.implicitHeight+10, Screen.height-50)
        }

        onVisibleChanged: {
            if (visible)
                height = Math.min(column.implicitHeight+10, Screen.height-50)
        }

        Button {
            id: opt_a
            text: "Customize..."
            onClicked: {
                optwin.visible = false
                clrwin.visible = true
            }
            width: optwin.width

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_a.hovered ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_a.text
                color: "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_b
            text: "Resize..."
            onClicked: {
                optwin.visible = false
                reswin.visible = true
            }
            width: optwin.width

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_b.hovered ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_b.text
                color: "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_c
            text: "Time factor..."
            onClicked: {
                optwin.visible = false
                spdwin.visible = true
            }
            width: optwin.width

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_c.hovered ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_c.text
                color: "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_d
            text: "Flip (R)"
            onClicked: {
                optwin.visible = false
                optwin.mwin.flip = !optwin.mwin.flip
                opt_d.text = optwin.mwin.flip ? "✓ Flip (R)" : "Flip (R)"
            }
            width: optwin.width

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_d.hovered ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_d.text
                color: "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_e
            text: wayland ? "Gravity" : "✓ Gravity (G)"
            onClicked: {
                optwin.visible = false
                optwin.mwin.doGrav = !optwin.mwin.doGrav
                opt_e.text = optwin.mwin.doGrav ? "✓ Gravity (G)" : "Gravity (G)"
            }
	    width: optwin.width
	    enabled: !wayland

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_e.hovered && !wayland ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_e.text
                color: wayland ? "#222" : "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_f
            text: wayland ? "Autopilot" : "✓ Autopilot"
            onClicked: {
                optwin.visible = false
                optwin.mwin.autopilot = !optwin.mwin.autopilot
                opt_f.text = optwin.mwin.autopilot ? "✓ Autopilot" : "Autopilot"
            }
	    width: optwin.width
	    enabled: !wayland

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_f.hovered && !wayland ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_f.text
                color: wayland ? "#222" : "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_g
            text: "Pet (2LMB)"
            width: optwin.width

            property bool cooldown: false
            property alias revertTimer: revertTimer
            property alias cooldownTimer: cooldownTimer

            Timer {
                id: revertTimer
                interval: 800 + Math.random() * 400
                repeat: false
                onTriggered: {
                    if (!sleeping) optwin.mwin.pixelData = idlesprite()
                }
            }

            Timer {
                id: cooldownTimer
                interval: 1500 + Math.random() * 500
                repeat: false
                onTriggered: opt_g.cooldown = false
            }

            onClicked: {
                if (opt_g.cooldown)
                    return

                optwin.visible = false

                if (!sleeping) optwin.mwin.pixelData = pixelData_1

                revertTimer.start()

                opt_g.cooldown = true
                cooldownTimer.start()
            }

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_g.hovered && !opt_g.cooldown ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_g.text
                color: opt_g.cooldown ? "#444" : "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_h
            text: "Feed (" + hunger + "/10)"
            width: optwin.width
            enabled: !cooldown && !sleeping && (hunger < 10 || spdwin.speedmult <= 0)

            property bool cooldown: false

            Timer {
                id: revertTimer_h
                interval: 700 + Math.random() * 300
                repeat: false
                onTriggered: {
                    optwin.mwin.pixelData = idlesprite()
                }
            }

            Timer {
                id: cooldownTimer_h
                interval: 5000
                repeat: false
                onTriggered: opt_h.cooldown = false
            }

            onClicked: {
                if (cooldown) return
                optwin.visible = false
                optwin.mwin.pixelData = pixelData_2
                revertTimer_h.start()
                cooldown = true
                cooldownTimer_h.start()

                if (spdwin.speedmult > 0) hunger = Math.min(10, hunger + Math.round(3 + Math.random()))
            }

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_h.hovered && !opt_h.cooldown && !sleeping && enabled ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_h.text
                color: opt_h.cooldown || sleeping || !enabled ? "#444" : "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_i
            text: "Water (" + thirst + "/10)"
            width: optwin.width
            enabled: !cooldown && !sleeping && (thirst < 10 || spdwin.speedmult <= 0)

            property bool cooldown: false

            Timer {
                id: revertTimer_i
                interval: 600 + Math.random() * 300
                repeat: false
                onTriggered: {
                    optwin.mwin.pixelData = idlesprite()
                }
            }

            Timer {
                id: cooldownTimer_i
                interval: 5000
                repeat: false
                onTriggered: opt_i.cooldown = false
            }

            onClicked: {
                if (cooldown) return
                optwin.visible = false
                optwin.mwin.pixelData = pixelData_2
                revertTimer_i.start()
                cooldown = true
                cooldownTimer_i.start()

                if (spdwin.speedmult > 0) thirst = Math.min(10, thirst + Math.round(3 + Math.random()))
            }

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_i.hovered && !opt_i.cooldown && !sleeping && enabled ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_i.text
                color: opt_i.cooldown || sleeping || !enabled ? "#444" : "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            id: opt_j
            text: optwin.sleeping ? "Wake Up (" + sleepiness + "/10)"
                        : "Sleep (" + sleepiness + "/10)"
            width: optwin.width

            onClicked: {
                optwin.visible = false
                if (sleeping) {
                    sleeping = false
                    sleepAnim.stop()
                    win.pixelData = idlesprite()

                    opt_i.enabled = true
                    opt_h.enabled = true

                    h2o.start()
                    stomach.start()

                    exh.start()
                    reg.stop()
                } else {
                    sleeping = true
                    sleepAnim.start()
                    win.pixelData = pixelData_4

                    opt_i.enabled = false
                    opt_h.enabled = false

                    h2o.stop()
                    stomach.stop()

                    reg.start()
                    exh.stop()
                }
            }

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_j.hovered ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_j.text
                color: "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Button {
            width: optwin.width

            onClicked: {
                optwin.visible = false
            }

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "#000"
                }
            }

            contentItem: Text {
                text: ""
                color: "#000"
                anchors.fill: parent
                font.pixelSize: 8
            }
        }

        Button {
            id: opt_k
            text: "Advanced..."
            onClicked: {
                optwin.visible = false
                advwin.visible = true
            }
            enabled: !wayland
            width: optwin.width

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_k.hovered && !wayland ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_k.text
                color: wayland ? "#222" : "#888"

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }


        Button {
            id: opt_l
            text: "Close (ESC)"
            onClicked: {
                optwin.visible = false
                Qt.quit()
            }
            width: optwin.width

            background: Rectangle {
                color: "#000"
                radius: 0

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: opt_l.hovered ? 0.3 : 0.0
                }
            }

            contentItem: Text {
                text: opt_l.text
                color: "#888"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.fill: parent
                font.pixelSize: 12
            }
        }

        Rectangle {
            width: optwin.width
            height: optwin.height
            color: "#000"
        }
    }
}
