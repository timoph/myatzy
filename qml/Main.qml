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

Window {
    id: appWindow
    color: Style.feltBottom
    flags: Qt.Window
    minimumHeight: 650
    minimumWidth: 500
    maximumHeight: minimumHeight
    maximumWidth: minimumWidth
    visible: true

    title: "Myatzy"

    readonly property bool gameOver: Engine.gameOver
    onGameOverChanged: {
        if (gameOver)
            gameOverDialog.open()
    }

    GameView {
        id: mainPage
        width: appWindow.width
        height: appWindow.height
        onMenuRequested: gameMenu.open()

        MenuIconButton {
            id: menuButton
            objectName: "menuButton"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 16
            onClicked: gameMenu.open()
        }
    }

    // give the keyboard back to the game when a dialog closes
    GameMenu {
        id: gameMenu
        onClosed: mainPage.forceActiveFocus()
    }

    GameOverDialog {
        id: gameOverDialog
        onClosed: mainPage.forceActiveFocus()
    }
}
