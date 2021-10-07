import QtQuick 2.3
import "."

Rectangle {
    property bool empty: false
    id: dot
    width: 10
    height: 10
    radius: 90
    smooth: true
    color: empty ? Style.emptyDotColor : Style.dotColor
}
