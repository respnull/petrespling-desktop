import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "."

Window {
    id: clrwin
    visible: false
    width: 400
    height: 320
    title: "Customize"
    flags: Qt.WindowStaysOnTopHint
    color: "#000"

    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    property color color1: "#00FF00"
    property color color2: "#00BF00"
    property color color3: "#000000"
    property color color4: "#FFFFFF"
    property int hat: 8

    Column {
        anchors.centerIn: parent
        spacing: 16

        Row {
            spacing: 10
            Rectangle { width: 40; height: 40; color: clrwin.color1; border.color: "#444" }
            Rectangle { width: 40; height: 40; color: clrwin.color2; border.color: "#444" }
            Rectangle { width: 40; height: 40; color: clrwin.color3; border.color: "#444" }
            Rectangle { width: 40; height: 40; color: clrwin.color4; border.color: "#444" }
            Rectangle {
                width: 40
                height: 40
                color: "#222"
                border.color: "#444"

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    smooth: false

                    source: [
                        "qrc:/wizard.png",
                        "qrc:/construction.png",
                        "qrc:/siren.png",
                        "qrc:/king.png",
                        "qrc:/halo.png",
                        "qrc:/long.png",
                        "qrc:/birthday.png",
                        "qrc:/traffic.png",
                        "qrc:/none.png"
                    ][win.hatID !== -1 ? win.hatID - 101 : 8]
                }
            }
        }

        ComboBox {
            id: slotSelector
            model: ["Outline", "Fill", "Highlight", "Pupil", "Accessory"]
        }

        Column {
            id: clrm
            visible: slotSelector.currentIndex !== 4
            spacing: 10

            Row {
                spacing: 10
                Slider {
                    id: rs
                    width: 256
                    from: 0; to: 255
                    onValueChanged: {
                        preview.color = Qt.rgba(rs.value/255, gs.value/255, bs.value/255, 1)
                        var r = Math.round(rs.value).toString(16).padStart(2,"0").toUpperCase()
                        var g = Math.round(gs.value).toString(16).padStart(2,"0").toUpperCase()
                        var b = Math.round(bs.value).toString(16).padStart(2,"0").toUpperCase()
                        hexInput.text = "#" + r + g + b
                    }
                }
                Label {
                    text: Math.round(rs.value).toString()
                    width: 30
                    font.pixelSize: 12
                    color: "#f00"
                }
            }
            Row {
                spacing: 10
                Slider {
                    id: gs
                    width: 256
                    from: 0; to: 255
                    value: 255
                    onValueChanged: {
                        preview.color = Qt.rgba(rs.value/255, gs.value/255, bs.value/255, 1)
                        var r = Math.round(rs.value).toString(16).padStart(2,"0").toUpperCase()
                        var g = Math.round(gs.value).toString(16).padStart(2,"0").toUpperCase()
                        var b = Math.round(bs.value).toString(16).padStart(2,"0").toUpperCase()
                        hexInput.text = "#" + r + g + b
                    }
                }
                Label {
                    text: Math.round(gs.value).toString()
                    width: 30
                    font.pixelSize: 12
                    color: "#0f0"
                }
            }
            Row {
                spacing: 10
                Slider {
                    id: bs
                    width: 256
                    from: 0; to: 255
                    onValueChanged: {
                        preview.color = Qt.rgba(rs.value/255, gs.value/255, bs.value/255, 1)
                        var r = Math.round(rs.value).toString(16).padStart(2,"0").toUpperCase()
                        var g = Math.round(gs.value).toString(16).padStart(2,"0").toUpperCase()
                        var b = Math.round(bs.value).toString(16).padStart(2,"0").toUpperCase()
                        hexInput.text = "#" + r + g + b
                    }
                }
                Label {
                    text: Math.round(bs.value).toString()
                    width: 30
                    color: "#00f"
                }
            }

            Row {
                spacing: 10
                Rectangle {
                    id: preview
                    width: 60; height: 30
                    color: "#0f0"
                    border.color: "#444"
                }
                TextField {
                    id: hexInput
                    text: "#00FF00"
                    width: 100
                    placeholderText: "#RRGGBB"
                    color: "#888"
                    inputMethodHints: Qt.ImhPreferUppercase | Qt.ImhNoPredictiveText
                    onEditingFinished: {
                        var txt = hexInput.text.trim()
                        if (!txt.startsWith("#")) txt = "#" + txt
                        if (txt.match(/^#([0-9A-Fa-f]{6})$/)) {
                            preview.color = txt
                            var r = parseInt(txt.substr(1,2),16)
                            var g = parseInt(txt.substr(3,2),16)
                            var b = parseInt(txt.substr(5,2),16)
                            rs.value = r
                            gs.value = g
                            bs.value = b
                        }
                    }
                }
            }
        }

        Grid {
            id: hats
            visible: slotSelector.currentIndex === 4
            columns: 5
            spacing: 10

            Repeater {
                model: [
                    "qrc:/wizard.png",
                    "qrc:/construction.png",
                    "qrc:/siren.png",
                    "qrc:/king.png",
                    "qrc:/halo.png",
                    "qrc:/long.png",
                    "qrc:/birthday.png",
                    "qrc:/traffic.png",
                    "qrc:/none.png",
                ]

                delegate: Rectangle {
                    width: 50
                    height: 50
                    border.color: clrwin.hat === index ? "#44f" : "#444"
                    border.width: clrwin.hat === index ? 3 : 1
                    color: "#222"

                    Image {
                        anchors.fill: parent
                        source: modelData
                        fillMode: Image.PreserveAspectFit
                        smooth: false
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            clrwin.hat = index
                            console.log("Selected:", modelData)
                        }
                    }
                }
            }
        }

        Row {
            spacing: 10
            Button {
                text: "Apply"
                onClicked: {
                    switch (slotSelector.currentIndex) {
                        case 0: clrwin.color1 = preview.color; break;
                        case 1: clrwin.color2 = preview.color; break;
                        case 2: clrwin.color3 = preview.color; break;
                        case 3: clrwin.color4 = preview.color; break;
                    }

                    var morehats = [
                        { id: 101, p: pixelData_101 },
                        { id: 102, p: pixelData_102 },
                        { id: 103, p: pixelData_103 },
                        { id: 104, p: pixelData_104 },
                        { id: 105, p: pixelData_105 },
                        { id: 106, p: pixelData_106 },
                        { id: 107, p: pixelData_107 },
                        { id: 108, p: pixelData_108 },
                        { id: -1, p: null },
                    ]

                    var hat = morehats[clrwin.hat]
                    if (hat) {
                        win.hatID = hat.id
                        win.hatPixelData = hat.p
                        win.hatH = (hat.id === 102 || hat.id === 104 || hat.id === 105) ? 8 : 16

                        let hval = win.width * (1.5 + 0.5 * ((win.hatH - 8) / 8))
                        if (hat.id === -1) {
                            win.hatVisible = false;
                            hval = win.width
                        } else { win.hatVisible = true; }

                        win.minimumWidth = win.width
                        win.minimumHeight = hval
                        win.maximumWidth = win.width
                        win.maximumHeight = hval
                        win.width = win.width
                        win.height = hval
                    }
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
                text: "Exit"
                onClicked: clrwin.visible = false
                contentItem: Text {
                    text: parent.text
                    color: "#888"
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Button {
                text: "Reset"
                enabled: {
                    return color1 !== "#00FF00" ||
                        color2 !== "#00BF00" ||
                        color3 !== "#000000" ||
                        color4 !== "#FFFFFF"
                }

                onClicked: {
                    color1 = "#00FF00"
                    color2 = "#00BF00"
                    color3 = "#000000"
                    color4 = "#FFFFFF"

                    hat.id = -1
                    hat.p = null
                    win.hatID = -1
                    win.hatPixelData = null
                    win.hatH = (hat.id === 102 || hat.id === 104 || hat.id === 105) ? 8 : 16

                    let hval = win.width * (1.5 + 0.5 * ((win.hatH - 8) / 8))
                    hat.id = -1
                    win.hatVisible = false;
                    hval = win.width

                    win.minimumWidth = win.width
                    win.minimumHeight = hval
                    win.maximumWidth = win.width
                    win.maximumHeight = hval
                    win.width = win.width
                    win.height = hval
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
    }
}
