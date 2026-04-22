import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "."

Window {
    id: win
    property var owin
    visible: true
    width: 96
    height: pixelGrid.height + (hatVisible ? hatGrid.height : 0)
    flags: Qt.FramelessWindowHint | Qt.Dialog | Qt.Popup | Qt.WindowStaysOnTopHint
    color: "transparent"

    maximumWidth: width
    minimumWidth: width
    maximumHeight: height
    minimumHeight: height

    property real winX: 0
    property real winY: 0

    property var pixelData: pixelData_0
    property int imgW: 16
    property int imgH: 16 

    property var hatPixelData: null
    property int hatID: -1
    property int hatW: 16
    property int hatH: { (hatID === 102 || hatID === 104 || hatID === 105) ? 8 : 16 }

    property bool hatVisible: false
    property int hatOffsetY: 0

    property bool flip: false
    property bool doGrav: true
    property bool dragging: false

    property real velocity: 0
    property real velocityMult: 1
    property real velocityX: 0
    property real velocityY: 0 
    property real gravity: 0.5

    property bool autopilot: true
    property bool autopiloting: false

    property bool automove: true
    property bool autojump: true

    property int workareaX: workarea ? workarea.x : 0
    property int workareaY: workarea ? workarea.y : 0
    property int workareaWidth: (workarea && workarea.width > 0) ? workarea.width : Screen.width
    property int workareaHeight: (workarea && workarea.height > 0) ? workarea.height : Screen.height
    property int floor: workareaHeight + workareaY - win.height

    Component.onCompleted: { winX = win.x; winY = win.y; }

    Timer {
        interval: 16
        running: !wayland
        repeat: true
        onTriggered: {
            win.x = winX
            win.y = winY
        }
    }

    Timer {
        interval: 16
        running: !wayland
        repeat: true
        onTriggered: {
            if (!win.dragging) {
                if (win.dragging) return

                if (doGrav) {
                    win.velocityY += gravity
                    winY += win.velocityY

                    if (winY <= workareaY) {
                        winY = workareaY
                        if (Math.abs(win.velocityY) > 5) {
                            win.velocityY = -win.velocityY / 2
                        } else {
                            win.velocityY = 1
                        }
                    }

                    if (winY >= win.floor) {
                        winY = win.floor
                        if (Math.abs(win.velocityY) > 5) {
                            win.velocityY = -win.velocityY / 2
                        } else {
                            win.velocityY = 0
                        }
                    }
                }

                if (win.autopiloting) return
                winX += win.velocityX

                if (winX <= workareaX) {
                    winX = workareaX
                    win.velocityX = -win.velocityX / 2
                } else if (winX > workareaX + workareaWidth - win.width) {
                    winX = workareaX + workareaWidth - win.width
                    win.velocityX = -win.velocityX / 2
                }

                win.velocityX *= 0.95
                win.velocityY *= 0.98

                if (Math.abs(win.velocityX) < 0.05) win.velocityX = 0
                if (Math.abs(win.velocityY) < 0.05) win.velocityY = 0
            }
        }
    }

    NumberAnimation {
        id: autoanim
        target: win
        property: "winX"
        duration: (optwin.sleepiness < 5 || optwin.hunger < 5 || optwin.thirst < 5) ? 1100 : 900
        easing.type: Easing.InOutQuad
        onStopped: { win.autopiloting = false }
    }

    Timer {
        interval: 3000 + Math.random() * 2000
        running: !wayland
        repeat: true
        onTriggered: {
            if (!win.autopilot || optwin.sleeping || win.dragging || !win.automove) return

            win.autopiloting = true
            win.velocityX = 0
            let dir = Math.random() < 0.5 ? -1 : 1
            let dist = (optwin.sleepiness < 5 || optwin.hunger < 5 || optwin.thirst < 5)
            ? Screen.width / 7 : Screen.width / 5

            let targetX = winX + dir * (Math.random() * dist)

            if (targetX < 0) targetX = 0
                if (targetX + win.width > Screen.width) targetX = Screen.width - win.width

                win.flip = dir < 0

                autoanim.to = targetX
                autoanim.start()
        }
    }

    Timer {
        interval: 15000 + Math.random() * 10000
        running: !wayland
        repeat: true
        onTriggered: {
            if (!win.autopilot || optwin.sleeping || win.dragging || !win.autojump) return

            if (Math.abs(winY - win.floor) < 1 && Math.abs(win.velocityY) < 1)
                win.velocityY = -5 - Math.random() * 10
        }
    }

    Item {
        anchors.fill: parent
        focus: true

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton | Qt.LeftButton

            property real lastX: 0
            property real lastY: 0
            property real draglastX: 0
            property real draglastY: 0
            property real dragVX: 0
            property real dragVY: 0
            property real dragoffsetX: 0
            property real dragoffsetY: 0
            property var velhistoryX: []
            property var velhistoryY: []

            onPressed: function(mouse) {
                if (optwin.visible && mouse.button !== Qt.RightButton)
                    optwin.visible = false

                if (mouse.button === Qt.RightButton) {
                    if ((winY + mouse.y) + optwin.height > Screen.height) {
                        optwin.x = winX + mouse.x
                        optwin.y = winY - optwin.height
                    } else {
                        optwin.x = mouse.x + winX
                        optwin.y = mouse.y + winY
                    }
                    optwin.visible = true
                    return
                }

                win.dragging = true
                autoanim.stop()

                dragoffsetX = mouse.x
                dragoffsetY = mouse.y
                dragVX = 0
                dragVY = 0
            }

            onReleased: function(mouse) {
                win.dragging = false

                let sumX = 0
                let sumY = 0

                for (let i = 0; i < velhistoryX.length; i++) {
                    sumX += velhistoryX[i]
                    sumY += velhistoryY[i]
                }

                let n = Math.max(1, velhistoryX.length)

                win.velocityX = (sumX / n) * velocityMult
                win.velocityY = (sumY / n) * velocityMult

                velhistoryX = []
                velhistoryY = []
            }

            onPositionChanged: function(mouse) {
                if (!win.dragging) return

                let newX = win.x + (mouse.x - dragoffsetX)
                let newY = win.y + (mouse.y - dragoffsetY)

                let dx = newX - winX
                let dy = newY - winY

                winX = newX
                winY = newY

                velhistoryX.push(dx)
                velhistoryY.push(dy)

                if (velhistoryX.length > 5) {
                    velhistoryX.shift()
                    velhistoryY.shift()
                }
            }

            onDoubleClicked: function(mouse) {
                if (optwin.optg.cooldown || mouse.button !== Qt.LeftButton) return

                optwin.visible = false
                if (!optwin.sleeping) optwin.mwin.pixelData = pixelData_1

                optwin.optg.revertTimer.start()
                optwin.optg.cooldown = true
                optwin.optg.cooldownTimer.start()
            }
        }

        Grid {
            id: pixelGrid

            x: 0
            y: hatVisible ? hatGrid.height : 0

            property real cellSize: width / imgW
            width: win.width
            height: cellSize * imgH

            rows: imgH
            columns: imgW

            Repeater {
                model: imgW * imgH

                delegate: Rectangle {
                    width: pixelGrid.cellSize
                    height: pixelGrid.cellSize

                    property int gridX: index % imgW
                    property int gridY: Math.floor(index / imgW)
                    property int realIndex: gridY * imgW + (flip ? (imgW - 1 - gridX) : gridX)

                    color: {
                        let c = pixelData[realIndex]

                        switch (c) {
                            case "#ff00ff00": return clrwin.color1
                            case "#ff00bf00": return clrwin.color2
                            case "#ff000000": return clrwin.color3
                            case "#ffffffff": return clrwin.color4
                            default: return c
                        }
                    }
                }
            }
        }

        Grid {
            id: hatGrid
            visible: hatVisible
            x: 0
            y: 0

            property real cellSize: pixelGrid.width / imgW

            width: cellSize * hatW
            height: cellSize * hatH

            rows: hatH
            columns: hatW

            Repeater {
                model: hatW * hatH

                delegate: Rectangle {
                    width: hatGrid.cellSize
                    height: hatGrid.cellSize

                    property int gridX: index % hatW
                    property int gridY: Math.floor(index / hatW)
                    property int realIndex: gridY * hatW + (flip ? (hatW - 1 - gridX) : gridX)

                    color: {
                       if (hatPixelData === null || hatID === -1) return "#000"
                       let c = hatPixelData[realIndex]
                       if (!c || c === "#00000000") return "transparent"
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

                if (e.key === Qt.Key_G && !wayland) {
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

    Advanced {
        id: advwin
    }
}
