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
import QtQuick.Controls.Basic

// Round button with a "hamburger" icon drawn with rectangles, so it does not
// depend on the glyphs of the installed fonts.
Button {
    id: button
    implicitWidth: 48
    implicitHeight: 48
    Accessible.name: qsTr("Menu")

    contentItem: Item {
        Column {
            anchors.centerIn: parent
            spacing: 5

            Repeater {
                model: 3

                Rectangle {
                    width: 22
                    height: 3
                    radius: 1.5
                    color: Style.textOnFelt
                }
            }
        }
    }

    background: Rectangle {
        radius: width / 2
        color: Style.textOnFelt
        opacity: button.down ? 0.25 : button.hovered ? 0.12 : 0.0
    }
}
