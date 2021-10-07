import QtQuick 2.0
import "."

Rectangle {
    anchors.fill: parent

    Connections {
        target: engine

        onDisplayMessage: {
            info.show(msg)
        }
    }

    function roll() {
        if(!dice1.selected)
            engine.rollDice(1)
        if(!dice2.selected)
            engine.rollDice(2)
        if(!dice3.selected)
            engine.rollDice(3)
        if(!dice4.selected)
            engine.rollDice(4)
        if(!dice5.selected)
            engine.rollDice(5)

        engine.forward()
    }

    Text {
        id: topLabel
        text: engine.topLabel
        color: Style.pageTextColor
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Grid {
        id: diceGrid
        spacing: 15
        columns: 5
        rows: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topLabel.bottom
        anchors.topMargin: 20
        Dice {
            id: dice1
            diceValue: engine.dice1
        }
        Dice {
            id: dice2
            diceValue: engine.dice2
        }
        Dice {
            id: dice3
            diceValue: engine.dice3
        }
        Dice {
            id: dice4
            diceValue: engine.dice4
        }
        Dice {
            id: dice5
            diceValue: engine.dice5
        }
    }

    Grid {
        id: scoreGrid
        rows: 8
        columns: 2
        width: parent.width / 2
        anchors.top: diceGrid.bottom
        anchors.topMargin: 50

        ScoreLabel {
            text: "ones"
        }

        ScoreButton {
            hand: "ones"
            //anchors.right: parent.right
            value: engine.ones
        }

        ScoreLabel {
            text: "twos"
        }

        ScoreButton {
            hand: "twos"
            //anchors.right: parent.right
            value: engine.twos
        }

        ScoreLabel {
            text: "threes"
        }

        ScoreButton {
            hand: "threes"
            //anchors.right: parent.right
            value: engine.threes
        }

        ScoreLabel {
            text: "fours"
        }

        ScoreButton {
            hand: "fours"
            //anchors.right: parent.right
            value: engine.fours
        }

        ScoreLabel {
            text: "fives"
        }

        ScoreButton {
            hand: "fives"
            //anchors.right: parent.right
            value: engine.fives
        }

        ScoreLabel {
            text: "sixes"
        }

        ScoreButton {
            hand: "sixes"
            //anchors.right: parent.right
            value: engine.sixes
        }

        ScoreLabel {
            text: "bonus"
        }

        ScoreButton {
            hand: "bonus"
            played: true
            text: engine.upbonus
            //anchors.right: parent.right
        }

        ScoreLabel {
            text: "pair"
        }

        ScoreButton {
            hand: "pair"
            //anchors.right: parent.right
            value: engine.pair
        }
    }

    Grid {
        id: score2Grid
        rows: 8
        columns: 2
        width: parent.width / 2 - 5
        anchors.left: scoreGrid.right
        anchors.leftMargin: 5
        anchors.top: diceGrid.bottom
        anchors.topMargin: 50

        ScoreLabel {
            text: "two pairs"
        }

        ScoreButton {
            hand: "twoPairs"
            //anchors.right: parent.right
            value: engine.twoPairs
        }

        ScoreLabel {
            text: "three of kind"
        }

        ScoreButton {
            hand: "threeKind"
            //anchors.right: parent.right
            value: engine.threeKind
        }

        ScoreLabel {
            text: "four of kind"
        }

        ScoreButton {
            hand: "fourKind"
            //anchors.right: parent.right
            value: engine.fourKind
        }

        ScoreLabel {
            text: "small straight"
        }

        ScoreButton {
            hand: "smallStraight"
            //anchors.right: parent.right
            value: engine.smallStraight
        }

        ScoreLabel {
            text: "big straight"
        }

        ScoreButton {
            hand: "bigStraight"
            //anchors.right: parent.right
            value: engine.bigStraight
        }

        ScoreLabel {
            text: "full house"
        }

        ScoreButton {
            hand: "fullHouse"
            //anchors.right: parent.right
            value: engine.fullHouse
        }

        ScoreLabel {
            text: "yatzy"
        }

        ScoreButton {
            hand: "yatzy"
            //anchors.right: parent.right
            value: engine.yatzy
        }

        ScoreLabel {
            text: "chance"
        }

        ScoreButton {
            hand: "chance"
            //anchors.right: parent.right
            value: engine.chance
        }

    }

    Row {
        id: totalRow
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        ScoreLabel {
            text: "Total:"
            bold: true
        }

        ScoreLabel {
            text: engine.total
            bold: true
        }
    }

//    Button {
//        id: rollButton
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.bottom: parent.bottom
//        text: "Roll'em"
//        enabled: engine.gameState === 0 || engine.gameState === 1

//        onClicked: {
//            if(!dice1.selected)
//                engine.rollDice(1)
//            if(!dice2.selected)
//                engine.rollDice(2)
//            if(!dice3.selected)
//                engine.rollDice(3)
//            if(!dice4.selected)
//                engine.rollDice(4)
//            if(!dice5.selected)
//                engine.rollDice(5)

//            engine.forward()
//        }
//    }

    Rectangle {
        id: info
        anchors.centerIn: parent
        width: parent.width
        height: 150
        color: "#98fb98"
        opacity: 0.9
        visible: false

        Timer {
            id: infoTimer
            interval: 2000
            running: false

            onTriggered: {
                info.visible = false
                infoTimer.stop()
            }
        }

        function show(message) {
            msgText.text = message
            info.visible = true
            infoTimer.start()
        }

        Text {
            id: msgText
            color: "#020202"
            anchors.centerIn: parent
            text: ""
            font.pixelSize: 24
            font.bold: true
        }

        MouseArea {
            id: infoMouse
            anchors.fill: parent

            onClicked: {
                info.visible = false
                infoTimer.stop()
            }
        }
    }

}
