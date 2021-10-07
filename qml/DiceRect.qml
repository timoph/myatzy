import QtQuick 2.0

Item {
    id: rootItem
    implicitHeight: 80
    implicitWidth: implicitHeight * 5 + 4 * 5

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

    Row {
        id: diceRow
        spacing: 5
        anchors.fill: parent
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
}
