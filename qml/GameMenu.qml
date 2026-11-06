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

// Rules, high scores and starting a new game.
PaperDialog {
    id: menu
    title: qsTr("Myatzy")

    // Starts a new game, asking first if that would throw one away.
    function requestNewGame() {
        if (Engine.gameInProgress) {
            confirmDialog.open()
        } else {
            Engine.newGame()
            menu.close()
        }
    }

    Text {
        width: parent.width
        wrapMode: Text.WordWrap
        color: Style.ink
        font.pointSize: 10
        lineHeight: 1.15
        textFormat: Text.StyledText
        text: qsTr("Collect the best hand for each row of the score card. You have three rolls per turn " +
                   "and can hold any dice between them. You can score a hand after any roll.<br><br>" +
                   "<b>Ones to Sixes</b> count the dice showing that number. 63 or more in total gives a " +
                   "bonus of 50 points.<br>" +
                   "<b>Small straight</b> is 1-5 (15 points), <b>big straight</b> 2-6 (20 points), " +
                   "<b>full house</b> three and two of a kind.<br>" +
                   "<b>Chance</b> is the sum of all dice and <b>Yatzy</b>, five of a kind, gives 50 points.")
    }

    Text {
        text: qsTr("High scores")
        color: Style.ink
        font.pointSize: 14
        font.bold: true
    }

    HighScoreList {
        width: parent.width
    }

    buttons: [
        MenuButton {
            text: qsTr("Close")
            secondary: true
            onClicked: menu.close()
        },
        MenuButton {
            objectName: "newGameButton"
            text: qsTr("New game")
            onClicked: menu.requestNewGame()
        }
    ]

    PaperDialog {
        id: confirmDialog
        title: qsTr("New game?")

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("The current game will be lost.")
            color: Style.ink
            font.pointSize: 12
        }

        buttons: [
            MenuButton {
                text: qsTr("Cancel")
                secondary: true
                onClicked: confirmDialog.close()
            },
            MenuButton {
                objectName: "confirmNewGameButton"
                text: qsTr("New game")
                onClicked: {
                    Engine.newGame()
                    confirmDialog.close()
                    menu.close()
                }
            }
        ]
    }
}
