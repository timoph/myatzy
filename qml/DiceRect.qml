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

import QtQuick 2.3

Item {
    id: rootItem
    implicitHeight: 80
    implicitWidth: implicitHeight * 5 + 4 * 5

    Row {
        id: diceRow
        spacing: 5
        anchors.fill: parent

        Repeater {
            model: engine.dice.length

            Dice {
                diceValue: engine.dice[index]
                held: engine.held[index]
                holdable: engine.canHold
                onClicked: engine.toggleHold(index)
            }
        }
    }
}
