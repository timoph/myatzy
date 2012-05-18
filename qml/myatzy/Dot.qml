// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

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
