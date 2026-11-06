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
    focus: true

    signal menuRequested()
    signal fullScreenToggleRequested()

    function rollOrNewGame() {
        if (!rollButton.enabled)
            return
        if (Engine.gameOver)
            Engine.newGame()
        else
            Engine.roll()
    }

    Keys.onPressed: (event) => {
        switch (event.key) {
        case Qt.Key_Space:
            mainPage.rollOrNewGame()
            break
        case Qt.Key_1:
        case Qt.Key_2:
        case Qt.Key_3:
        case Qt.Key_4:
        case Qt.Key_5:
            if (!diceRect.rolling)
                Engine.toggleHold(event.key - Qt.Key_1)
            break
        case Qt.Key_Up:
            scoreCard.moveVertical(-1)
            break
        case Qt.Key_Down:
            scoreCard.moveVertical(1)
            break
        case Qt.Key_Left:
        case Qt.Key_Right:
            scoreCard.switchSection()
            break
        case Qt.Key_Return:
        case Qt.Key_Enter:
            scoreCard.scoreCursor()
            break
        case Qt.Key_M:
        case Qt.Key_F1:
            mainPage.menuRequested()
            break
        case Qt.Key_F11:
            mainPage.fullScreenToggleRequested()
            break
        default:
            return
        }
        event.accepted = true
    }

    gradient: Gradient {
        GradientStop { position: 0.0; color: Style.feltTop }
        GradientStop { position: 1.0; color: Style.feltBottom }
    }

    // The game is laid out at a fixed design size and scaled to fit the
    // window, keeping its proportions. The felt fills the rest.
    Item {
        id: stage
        width: Style.designWidth
        height: Style.designHeight
        anchors.centerIn: parent
        scale: Style.uiScale

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
            // after the game the same button starts a new one
            text: Engine.gameOver ? qsTr("New game") : qsTr("Roll")
            rollsLeft: Engine.maxRolls - Engine.rollCount
            maxRolls: Engine.gameOver ? 0 : Engine.maxRolls
            enabled: Engine.gameOver || (Engine.canRoll && !diceRect.rolling)

            onClicked: mainPage.rollOrNewGame()
        }

        MenuIconButton {
            id: menuButton
            objectName: "menuButton"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 16
            onClicked: mainPage.menuRequested()
        }
    }
}
