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
import QtQuick.Controls 2.0
import "."

Button {
    id: button
    property string name: ""
    property int score: 0
    property bool played: false
    property bool strikeoutWhenPlayed: true

    text: played ? score : enabled ? "\u25cb" : ""
    font.strikeout: played && strikeoutWhenPlayed
    font.pointSize: 16

    contentItem: Row {
        spacing: 0
        Text {
            width: 140
            text: button.name
            font: button.font
            color: Style.scoreButtonTextColor
            verticalAlignment: Text.AlignVCenter
            clip: true
        }

        Text {
            width: 30
            text: button.text
            font.pointSize: 16
            color: Style.scoreButtonTextColor
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        implicitWidth: 170
        implicitHeight: 40
        color: Style.scoreButtonColor
    }
}
