import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import "."

Rectangle {
    id: mainPage
    width: 480
    height: 700

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

        if(dice1.selected && dice2.selected && dice3.selected && dice4.selected && dice5.selected)
            engine.skipRoll()
        else
            engine.forward()
    }

    Label {
        id: topLabel
        text: engine.topLabel
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Grid {
        id: diceGrid
        spacing: 15
        columns: 5
        rows: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: topLabel.bottom
        anchors.topMargin: 10
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
        columns: 4
        width: diceGrid.width
        anchors.top: diceGrid.bottom
        anchors.topMargin: 10

        ScoreLabel {
            text: "ones"
            width: 80
        }

        ScoreButton {
            hand: "ones"
            value: engine.ones
        }

        ScoreLabel {
            text: "two pairs"
            spacing: true
        }

        ScoreButton {
            hand: "twoPairs"
            value: engine.twoPairs
        }

        ScoreLabel {
            text: "twos"
            width: 80
        }

        ScoreButton {
            hand: "twos"
            value: engine.twos
        }

        ScoreLabel {
            text: "three of kind"
            spacing: true
        }

        ScoreButton {
            hand: "threeKind"
            value: engine.threeKind
        }

        ScoreLabel {
            text: "threes"
            width: 80
        }

        ScoreButton {
            hand: "threes"
            value: engine.threes
        }

        ScoreLabel {
            text: "four of kind"
            spacing: true
        }

        ScoreButton {
            hand: "fourKind"
            value: engine.fourKind
        }

        ScoreLabel {
            text: "fours"
            width: 80
        }

        ScoreButton {
            hand: "fours"
            value: engine.fours
        }

        ScoreLabel {
            text: "small straight"
            spacing: true
        }

        ScoreButton {
            hand: "smallStraight"
            value: engine.smallStraight
        }

        ScoreLabel {
            text: "fives"
            width: 80
        }

        ScoreButton {
            hand: "fives"
            value: engine.fives
        }

        ScoreLabel {
            text: "big straight"
            spacing: true
        }

        ScoreButton {
            hand: "bigStraight"
            value: engine.bigStraight
        }

        ScoreLabel {
            text: "sixes"
            width: 80
        }

        ScoreButton {
            hand: "sixes"
            value: engine.sixes
        }

        ScoreLabel {
            text: "full house"
            spacing: true
        }

        ScoreButton {
            hand: "fullHouse"
            value: engine.fullHouse
        }

        ScoreLabel {
            text: "bonus"
            width: 80
        }

        ScoreButton {
            hand: "bonus"
            played: true
            text: engine.upbonus
        }

        ScoreLabel {
            text: "yatzy"
            spacing: true
        }

        ScoreButton {
            hand: "yatzy"
            value: engine.yatzy
        }

        ScoreLabel {
            text: "pair"
            width: 80
        }

        ScoreButton {
            hand: "pair"
            value: engine.pair
        }

        ScoreLabel {
            text: "chance"
            spacing: true
        }

        ScoreButton {
            hand: "chance"
            value: engine.chance
        }
    }

    Button {
        id: selectButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: scoreGrid.bottom
        anchors.topMargin: 20
        text: "Roll'em"
        enabled: engine.gameState === 0 || engine.gameState === 1 || engine.gameState === 2
        onClicked: {
            mainPage.roll()
        }
    }

    Row {
        id: totalRow
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Label {
            text: "Total:"
            font.bold: true
        }

        Label {
            text: engine.total
            font.bold: true
        }
    }

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
            color: Style.msgTextColor
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
