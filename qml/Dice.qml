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
import "."

Item {
    property int diceValue: 1
    property bool selected: false
    property string selectedColor: selected ? Style.diceSelectedColor : Style.diceDefaultColor
    property bool selectable: engine.gameState === 1 || engine.gameState === 2
    id: diceRoot
    implicitHeight: parent.height
    implicitWidth: height
    smooth: true

    Connections {
        target: engine

        onResetSelections: {
            diceRoot.selected = false
        }
    }

    Rectangle {
        Behavior on visible { NumberAnimation { duration: 200 } }
        anchors.fill: parent
        color: selectedColor
        radius: 15
        Grid {
            anchors.centerIn: parent
            columns: 3
            rows: 3
            spacing: 10
            //top row
            Dot { empty: (diceValue !== 4 && diceValue !== 5 && diceValue !== 6) ? true : false }
            Dot { empty: (diceValue !== 2) ? true : false }
            Dot { empty: (diceValue !== 3 && diceValue !== 4 && diceValue !== 5 && diceValue !== 6) ? true : false }

            // middle row
            Dot { empty: (diceValue !== 6) ? true : false }
            Dot { empty: (diceValue !== 1 && diceValue !== 3 && diceValue !== 5) ? true : false }
            Dot { empty: (diceValue !== 6) ? true : false }

            // bottom row
            Dot { empty: (diceValue !== 3 && diceValue !== 4 && diceValue !== 5 && diceValue !== 6) ? true : false }
            Dot { empty: (diceValue !== 2) ? true : false }
            Dot { empty: (diceValue !== 4 && diceValue !== 5 && diceValue !== 6) ? true : false }
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
