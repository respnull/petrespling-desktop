import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "."

Window {
    id: clrwin
    visible: false
    width: 400
    height: 320
    title: "Paint"
    flags: Qt.WindowStaysOnTopHint
    color: "#000"

    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    property color color1: "#00FF00"
    property color color2: "#00BF00"
    property color color3: "#000000"
    property color color4: "#FFFFFF"

    Column {
        anchors.centerIn: parent
        spacing: 16

        Row {
            spacing: 10
            Rectangle { width: 40; height: 40; color: clrwin.color1; border.color: "#444" }
            Rectangle { width: 40; height: 40; color: clrwin.color2; border.color: "#444" }
            Rectangle { width: 40; height: 40; color: clrwin.color3; border.color: "#444" }
            Rectangle { width: 40; height: 40; color: clrwin.color4; border.color: "#444" }
        }

        ComboBox {
            id: slotSelector
            model: ["Outline", "Fill", "Highlight", "Pupil"]
        }

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
                    if (!txt.startsWith("#")) {
                        txt = "#" + txt
                    }
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
