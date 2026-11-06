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

import QtQuick

Rectangle {
    id: baseRect
    implicitWidth: 460
    implicitHeight: sections.implicitHeight + 2 * sections.anchors.margins
    border.width: 2
    border.color: Style.highlightColor
    color: Style.scoreCardColor
    radius: 15

    Component {
        id: scoreDelegate

        ScoreButton {
            id: scoreRow
            // filled from the model roles of the same names
            required property int category
            required name
            required score
            required played
            required potential

            width: parent ? parent.width : 0
            preview: Engine.canScore
            enabled: Engine.canScore && !played
            onClicked: Engine.scoreCategory(scoreRow.category)
        }
    }

    Row {
        id: sections
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        readonly property real columnWidth: (width - spacing) / 2

        Column {
            width: sections.columnWidth

            Repeater {
                model: Engine.upperSection
                delegate: scoreDelegate
            }

            ScoreButton {
                width: parent.width
                name: qsTr("Bonus")
                detail: Engine.upperBonus > 0 ? "" : qsTr("%1 / 63").arg(Engine.upperSum)
                score: Engine.upperBonus
                played: true
                strikeoutWhenPlayed: false
                enabled: false
            }

            // keeps the total level with the last row of the lower section
            Item {
                width: parent.width
                height: 40
            }

            ScoreButton {
                width: parent.width
                name: qsTr("Total")
                score: Engine.total
                played: true
                strikeoutWhenPlayed: false
                enabled: false
                font.bold: true
            }
        }

        Column {
            width: sections.columnWidth

            Repeater {
                model: Engine.lowerSection
                delegate: scoreDelegate
            }
        }
    }
}
