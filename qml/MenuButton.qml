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

// Rounded text button. Primary buttons use the accent color.
Button {
    id: button
    property bool secondary: false

    implicitWidth: Math.max(140, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: 48
    leftPadding: 24
    rightPadding: 24
    font.pointSize: 14
    font.bold: true

    contentItem: Text {
        text: button.text
        font: button.font
        color: Style.textOnAccent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: height / 2
        color: button.secondary ? (button.down ? Style.secondaryPressed : Style.secondary)
                                : (button.down ? Style.accentPressed : Style.accent)
        opacity: button.enabled ? 1.0 : 0.4
    }
}
