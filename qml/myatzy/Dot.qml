import QtQuick 2.10

Rectangle {
    property bool empty: false
    property string emptyColor: "#dedede"
    id: dot
    width: 10
    height: 10
    radius: 90
    smooth: true
    color: empty ? emptyColor : "#000000"
}
