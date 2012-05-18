// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

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
