import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "."

Window {
    id: win
    property var owin
    visible: true
    width: 96
    height: 96
    flags: Qt.FramelessWindowHint | Qt.Dialog | Qt.Popup | Qt.WindowStaysOnTopHint

    property var pixelData: pixelData_0
    property int imgW: 16
    property int imgH: 16

    property bool flip: false
    property bool doGrav: true
    property bool dragging: false

    property real velocity: 0
    property real gravity: 0.5

    property int floor: getFloor()

    function getFloor() {
        if (!win.screen || !win.screen.availableGeometry)
            return Screen.height - win.height

            return win.screen.availableGeometry.height - win.height
    }

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            if (!doGrav || win.dragging) return

                win.velocity += win.gravity
                win.y += win.velocity

                if (win.y >= win.floor) {
                    win.y = win.floor

                    if (Math.abs(win.velocity) > 1.5) {
                        win.velocity = -win.velocity / 2
                    } else {
                        win.velocity = 0
                    }
                }
        }
    }

    property bool autopilot: true

    NumberAnimation {
        id: autoanim
        target: win
        property: "x"
        duration: (optwin.sleepiness < 5 || optwin.hunger < 5 || optwin.thirst < 5)
        ? 1100 : 900
        easing.type: Easing.InOutQuad
    }

    Timer {
        interval: 3000 + Math.random() * 2000
        running: true
        repeat: true
        onTriggered: {
            if (!win.autopilot || optwin.sleeping || win.dragging) return

                let dir = Math.random() < 0.5 ? -1 : 1
                let dist = (optwin.sleepiness < 5 || optwin.hunger < 5 || optwin.thirst < 5)
                ? Screen.width / 7 : Screen.width / 5

                let targetX = win.x + dir * (Math.random() * dist)

                if (targetX < 0) targetX = 0
                    if (targetX + win.width > Screen.width)
                        targetX = Screen.width - win.width

                        win.flip = dir < 0

                        autoanim.to = targetX
                        autoanim.start()
        }
    }

    Item {
        anchors.fill: parent
        focus: true

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton | Qt.LeftButton

            onPressed: function(mouse) {
                if (optwin.visible && mouse.button !== Qt.RightButton)
                    optwin.visible = false
                    if (mouse.button === Qt.RightButton) {
                        if ((win.y + mouse.y) + optwin.height > Screen.height) {
                            optwin.x = win.x + mouse.x
                            optwin.y = win.y - optwin.height
                            optwin.visible = true
                            return
                        }

                        optwin.x = mouse.x + win.x
                        optwin.y = mouse.y + win.y
                        optwin.visible = true
                    } else {
                        win.dragging = true
                        win.startSystemMove()
                    }
            }

            onReleased: {
                win.dragging = false
            }

            onDoubleClicked: function(mouse) {
                if (optwin.optg.cooldown || mouse.button !== Qt.LeftButton)
                    return

                    optwin.visible = false
                    optwin.mwin.pixelData = pixelData_1

                    optwin.optg.revertTimer.start()
                    optwin.optg.cooldown = true
                    optwin.optg.cooldownTimer.start()
            }
        }

        Grid {
            id: pixelGrid
            anchors.fill: parent
            rows: imgH
            columns: imgW

            Repeater {
                model: imgW * imgH

                Rectangle {
                    width: Math.min(pixelGrid.width / imgW, pixelGrid.height / imgH)
                    height: width

                    color: {
                        let x = index % imgW
                        let y = Math.floor(index / imgW)
                        let f = flip ? (imgW - 1 - x) : x
                        let realIndex = y * imgW + f

                        let c = pixelData[realIndex]

                        if (c === "#ff00ff00") return clrwin.color1
                            if (c === "#ff00bf00") return clrwin.color2
                                if (c === "#ff000000") return clrwin.color3
                                    if (c === "#ffffffff") return clrwin.color4

                                        return c
                    }
                }
            }
        }

        Keys.onPressed: function(e) {
            if (e.key === Qt.Key_Escape)
                Qt.quit()

                if (e.key === Qt.Key_R) {
                    flip = !flip
                    optwin.optd.text = flip ? "✓ Flip (R)" : "Flip (R)"
                }

                if (e.key === Qt.Key_G) {
                    doGrav = !doGrav
                    optwin.opte.text = doGrav ? "✓ Gravity (G)" : "Gravity (G)"
                }
        }
    }

    Options {
        id: optwin
        mwin: win
        speedwin: spdwin
    }

    Paint {
        id: clrwin
    }

    Resize {
        id: reswin
    }

    Speed {
        id: spdwin
    }
}
