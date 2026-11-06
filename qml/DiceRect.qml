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

pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: rootItem
    readonly property int dieSize: 80
    readonly property int spacing: 10

    implicitHeight: dieSize
    implicitWidth: dieSize * 5 + spacing * 4

    Row {
        id: diceRow
        spacing: rootItem.spacing

        Repeater {
            model: Engine.dice.length

            Dice {
                required property int index
                width: rootItem.dieSize
                height: rootItem.dieSize
                diceValue: Engine.dice[index]
                held: Engine.held[index]
                holdable: Engine.canHold
                inactive: Engine.rollCount === 0
                onClicked: Engine.toggleHold(index)
            }
        }
    }
}
