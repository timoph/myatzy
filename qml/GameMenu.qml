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

import QtQuick 2.0
import QtQuick.Controls 2.4
import "."

Item {
    id: rootItem
    implicitHeight: parent.height - (parent.height / 5)
    implicitWidth: parent.width - (parent.width / 5)

    Rectangle {
        id: menuRect
        anchors.fill: parent
        color: Style.menuBgColor
        border.width: 4
        border.color: Style.highlightColor

        Text {
            id: titleText
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.pageTextColor
            font.pointSize: 20
            text: qsTr("Myatzy")
        }

        Text {
            id: yadaYadaText
            anchors.top: titleText.bottom
            anchors.topMargin: 5
            width: parent.width - 20
            anchors.horizontalCenter: parent.horizontalCenter
            color: Style.pageTextColor
            wrapMode: Text.WordWrap
            text: qsTr("The game's objective is to get different hands by throwing the dices three times.\n" +
                                  "For ones, twos, threes, etc. the goal is to get as many of the named numbers as possible.\n\n" +
                                  " You'll get a 50 point bonus if the cumulative score of those is 63 or above.\n\n " +
                                  "You get a yatzy by having any number five times. Yatzy gives you 50 points. \n\n" +
                                  "Small straight is 1-5, big is 2-6, full house is three and two of a kind.\n\n " +
                                  "Chance counts all the dice scores together.\n\n" +
                                  "For more information about yatzy, see\nhttp://en.wikipedia.org/wiki/Yatzy"
                                  )
        }

        Row {
            id: contentColumn
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            MenuButton {
                id: ngButton
                text: "new game"
                onClicked: {
                    engine.newGame()
                    rootItem.visible = false
                }
            }

//            Button {
//                id: hsButton
//                text: "Highscores"
//                onClicked: messageRect.showMessage(qsTr("Top 3 scores"), engine.highScores)
//            }
        }
    }
}
