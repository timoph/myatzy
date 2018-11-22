import QtQuick 2.3

Rectangle {
    property int diceValue: 1
    property bool selected: false
    property string selectedColor: selected ? "#989898" : "#dedede"
    property bool selectable: engine.gameState === 1 || engine.gameState === 2
    id: diceRoot
    width: 80
    height: 80
    radius: 15
    smooth: true
    color: "#ababab"

    Connections {
        target: engine

        onResetSelections: {
            diceRoot.selected = false
        }
    }

    // 1
    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        visible: diceRoot.diceValue === 1
        color: selectedColor
        radius: 15
        Dot {
            anchors.centerIn: parent
        }
    }

    // 2
    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        visible: diceRoot.diceValue === 2
        color: selectedColor
        radius: 15
        Column {
            anchors.centerIn: parent
            spacing: 25
            anchors.topMargin: 20
            Dot { }
            Dot { }
        }
    }

    // 3
    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        visible: diceRoot.diceValue === 3
        color: selectedColor
        radius: 15
        Grid {
            anchors.centerIn: parent
            columns: 3
            rows: 3
            spacing: 10

            Dot {}
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot {}
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot { }
        }
    }

    // 4
    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        visible: diceRoot.diceValue === 4
        color: selectedColor
        radius: 15
        Grid {
            anchors.centerIn: parent
            rows: 2
            columns: 2
            spacing: 30
            Dot {}
            Dot {}
            Dot {}
            Dot {}
        }
    }

    // 5
    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        visible: diceRoot.diceValue === 5
        color: selectedColor
        radius: 15
        Grid {
            anchors.centerIn: parent
            columns: 3
            rows: 3
            spacing: 10
            Dot {}
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot {}
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot {}
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
            }
            Dot {}
            Dot { empty: true
                emptyColor: diceRoot.selected ? "#989898" : "#dedede"
                }
            Dot {}
        }
    }

    // 6
    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        visible: diceRoot.diceValue === 6
        color: selectedColor
        radius: 15
        Grid {
            anchors.centerIn: parent
            rows: 3
            columns: 2
            spacing: 10
            Dot {}
            Dot {}
            Dot {}
            Dot {}
            Dot {}
            Dot {}
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: diceRoot.selectable
        onClicked: {
            diceRoot.selected = !diceRoot.selected
        }
    }
}
