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
import QtQuick.Window 2.2

Window {
    id: appWindow
    flags: Qt.Window
    minimumHeight: 650
    minimumWidth: 500
    maximumHeight: minimumHeight
    maximumWidth: minimumWidth
    visible: true

    title: "Myatzy"

    GameView {
        id: mainPage
        width: appWindow.width
        height: appWindow.height

        MouseArea {
            anchors.fill: parent
            enabled: gameMenu.visible
            onClicked: gameMenu.visible = false
        }

        MenuButton {
            id: menuButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            drawBorders: false
            transparentBackground: true
            fontSize: 40
            visible: !gameMenu.visible
            onClicked: gameMenu.visible = true
            width: 50
            height: width
            text: "\u2699"
        }
    }

    Rectangle {
        id: dimmer
        anchors.fill: parent
        color: Style.pageBgColor
        opacity: 0.9
        visible: popupRect.visible | gameMenu.visible
    }

    GameMenu {
        id: gameMenu
        visible: false
        anchors.centerIn: parent
    }

    Rectangle {
        id: popupRect
        width: appWindow.width
        anchors.centerIn: parent
        border.width: 2
        border.color: Style.highlightColor
        visible: false
        height: 150

        Text {
            id: popupText
            anchors.centerIn: parent
        }

        Connections {
            target: engine
            onDisplayMessage: {
                popupText.text = msg
                popupRect.visible = true
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: popupRect.visible
        onClicked: popupRect.visible = false
    }
}
