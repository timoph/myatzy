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
import QtQuick.Controls 2.0
import "."

Button {
    id: button
    property int value: 0
    property string hand: "test hand"
    property bool played: false
    text: button.played ? value : engine.gameState === 3 ? "\u25cb" : ""
    enabled: !played && engine.gameState === 3
    font.strikeout:  played && hand !== "Bonus"
    font.pointSize: 16
    onClicked: {
        engine.handleScoreButtonClick(hand)
        played = true
    }

    contentItem: Row {
        spacing: 0
        Text {
            width: 140
            text: button.hand
            font: button.font
            color: Style.scoreButtonTextColor
            verticalAlignment: Text.AlignVCenter
            clip: true
        }

        Text {
            width: 30
            text: button.text
            font.pointSize: 16
            color: Style.scoreButtonTextColor
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        implicitWidth: 170
        implicitHeight: 40
        color: Style.scoreButtonColor
        border.width: 0 //!played && engine.gameState === 3 ? 2 : 0
        border.color: Style.scoreButtonTextColor
    }

    Connections {
        target: engine
        onNewGameTriggered: {
            if(hand != "Bonus")
                button.played = false
        }
    }
}
