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
    id: diceRoot
    property int diceValue: 1
    property bool held: false
    property bool holdable: false
    // visible pips for each face, positions 0..8 of the 3x3 grid row by row
    readonly property var pips: [[], [4], [1, 7], [2, 4, 6], [0, 2, 6, 8], [0, 2, 4, 6, 8], [0, 2, 3, 5, 6, 8]]
    signal clicked()

    implicitHeight: parent.height
    implicitWidth: height
    smooth: true

    Rectangle {
        anchors.fill: parent
        color: diceRoot.held ? Style.diceSelectedColor : Style.diceDefaultColor
        radius: 15
        Grid {
            anchors.centerIn: parent
            columns: 3
            rows: 3
            spacing: 10

            Repeater {
                model: 9

                Dot {
                    required property int index
                    empty: !(diceRoot.pips[diceRoot.diceValue] || []).includes(index)
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: diceRoot.holdable
        onClicked: diceRoot.clicked()
    }
}
