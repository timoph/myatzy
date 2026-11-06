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
    id: mainPage
    anchors.fill: parent

    gradient: Gradient {
        GradientStop { position: 0.0; color: Style.feltTop }
        GradientStop { position: 1.0; color: Style.feltBottom }
    }

    Column {
        id: contentColumn
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 16

        ScoreCard {
            id: scoreCard
            interactive: !diceRect.rolling
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DiceRect {
            id: diceRect
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: statusLabel
            width: parent.width - 40
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: Engine.statusText
            color: Style.textOnFelt
            font.pointSize: 11
        }
    }

    RollButton {
        id: rollButton
        objectName: "rollButton"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        rollsLeft: Engine.maxRolls - Engine.rollCount
        maxRolls: Engine.maxRolls
        enabled: Engine.canRoll && !diceRect.rolling

        onClicked: Engine.roll()
    }
}
