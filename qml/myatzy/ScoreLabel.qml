import QtQuick 2.10

Rectangle {
    id: rootRect
    height: 62
    width: 200
    color: "#000000"
    property string text: ""
    property bool bold: false
    property bool spacing: false
    smooth: true

    Text {
        text: rootRect.spacing ? "     " + rootRect.text : " " + rootRect.text
        color: "#dedede"
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 24
        font.bold: rootRect.bold
    }
}
