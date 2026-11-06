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

PaperDialog {
    id: dialog
    title: qsTr("Game over")

    readonly property var rankTexts: [qsTr("New high score!"), qsTr("New 2nd best score!"),
                                      qsTr("New 3rd best score!")]

    Text {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: Engine.total
        color: Style.ink
        font.pointSize: 44
        font.bold: true
    }

    Text {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        visible: Engine.highScoreRank >= 0
        text: dialog.rankTexts[Engine.highScoreRank] || ""
        color: Style.inkPreview
        font.pointSize: 14
        font.bold: true
    }

    HighScoreList {
        width: parent.width
        highlight: Engine.highScoreRank
    }

    buttons: [
        MenuButton {
            text: qsTr("Close")
            secondary: true
            onClicked: dialog.close()
        },
        MenuButton {
            objectName: "playAgainButton"
            text: qsTr("Play again")
            onClicked: {
                Engine.newGame()
                dialog.close()
            }
        }
    ]
}
