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

Rectangle {
    id: baseRect
    implicitWidth: 420
    implicitHeight: 410
    border.width: 2
    border.color: Style.highlightColor
    color: Style.scoreCardColor
    radius: 15

    Component {
        id: scoreDelegate

        ScoreButton {
            name: model.name
            score: model.score
            played: model.played
            enabled: engine.canScore && !model.played
            onClicked: engine.scoreCategory(model.category)
        }
    }

    Row {
        id: sections
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            Repeater {
                model: engine.upperSection
                delegate: scoreDelegate
            }

            ScoreButton {
                name: qsTr("Bonus")
                score: engine.upperBonus
                played: true
                strikeoutWhenPlayed: false
                enabled: false
            }
        }

        Column {
            Repeater {
                model: engine.lowerSection
                delegate: scoreDelegate
            }
        }
    }

    Text {
        text: qsTr("Total: %1").arg(engine.total)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        color: Style.pageTextColor
        font.bold: true
    }
}
