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

    GameView {
        id: mainPage
        width: appWindow.width
        height: appWindow.height

        MouseArea {
            anchors.fill: parent
            enabled: gameMenu.visible
            onClicked: gameMenu.visible = false
        }

        MenuIconButton {
            id: menuButton
            objectName: "menuButton"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 16
            visible: !gameMenu.visible
            onClicked: gameMenu.visible = true
        }
    }

    Rectangle {
        id: dimmer
        anchors.fill: parent
        color: Style.dim
        visible: popupRect.visible || gameMenu.visible
    }

    GameMenu {
        id: gameMenu
        visible: false
        anchors.centerIn: parent
    }

    Rectangle {
        id: popupRect
        width: appWindow.width - 80
        height: 120
        anchors.centerIn: parent
        radius: Style.radiusLarge
        color: Style.paper
        visible: false

        Text {
            id: popupText
            anchors.centerIn: parent
            color: Style.ink
            font.pointSize: 18
            font.bold: true
        }

        Connections {
            target: Engine
            function onDisplayMessage(msg) {
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
