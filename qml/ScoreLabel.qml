import QtQuick 2.3
import "."

Rectangle {
    id: rootRect
    height: 62
    width: 200
    color: Style.pageBgColor
    property string text: ""
    property bool bold: false
    property bool spacing: false
    smooth: true

    Text {
        text: rootRect.spacing ? "     " + rootRect.text : " " + rootRect.text
        color: Style.pageTextColor
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 24
        font.bold: rootRect.bold
    }
}
