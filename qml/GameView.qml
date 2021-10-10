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
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import "."

Rectangle {
    id: mainPage
    anchors.fill: parent
    color: Style.pageBgColor

    Column {
        id: contentColumn
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 15

        ScoreCard {
            id: scoreCard
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DiceRect {
            id: diceRect
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: topLabel
            text: engine.topLabel
            color: Style.pageTextColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MenuButton {
        id: selectButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: "\u27f3"
        fontSize: 90
        width: 90
        height: width
        transparentBackground: true
        enabled: engine.gameState === 0 || engine.gameState === 1 || engine.gameState === 2
        onClicked: {
            diceRect.roll()
        }
    }
}
