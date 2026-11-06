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

// The top scores, optionally highlighting one place.
Column {
    id: list
    property int highlight: -1
    spacing: 2

    Repeater {
        model: Engine.highScores

        Rectangle {
            id: row
            required property int index
            required property int modelData

            width: list.width
            height: 34
            radius: Style.radiusSmall
            color: index === list.highlight ? Style.dieHeld : "transparent"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: (row.index + 1) + "."
                color: Style.inkMuted
                font.pointSize: 14
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                text: row.modelData > 0 ? row.modelData : "\u2013"
                color: Style.ink
                font.pointSize: 14
                font.bold: row.index === list.highlight
            }
        }
    }
}
