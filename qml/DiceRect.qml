/*
 Myatzy - a version of the dice game Yatzy
 Copyright (C) 2021 Timo Härkönen

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
