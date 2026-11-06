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

import QtCore
import QtQuick

Window {
    id: appWindow
    color: Style.feltBottom
    flags: Qt.Window
    width: Style.designWidth
    height: Style.designHeight
    minimumWidth: Style.designWidth * 0.64
    minimumHeight: Style.designHeight * 0.64
    visible: true

    title: "Myatzy"

    readonly property bool gameOver: Engine.gameOver
    onGameOverChanged: {
        if (gameOver)
            gameOverDialog.open()
    }

    Binding {
        target: Style
        property: "uiScale"
        value: Math.min(appWindow.width / Style.designWidth, appWindow.height / Style.designHeight)
    }

    // remember the window size between runs
    Settings {
        category: "window"
        property alias width: appWindow.width
        property alias height: appWindow.height
    }

    GameView {
        id: mainPage
        anchors.fill: parent
        onMenuRequested: gameMenu.open()
        onFullScreenToggleRequested: {
            appWindow.visibility = appWindow.visibility === Window.FullScreen ? Window.Windowed
                                                                             : Window.FullScreen
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
