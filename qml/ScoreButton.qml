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

// One row of the score card: hand name on the left, score on the right.
// Before a hand is played it previews what the current dice would give.
Button {
    id: button
    property string name: ""
    property int score: 0
    property bool played: false
    property int potential: 0
    // show the potential score of an unplayed row
    property bool preview: false
    // optional extra text shown before the value, e.g. bonus progress
    property string detail: ""
    property bool strikeoutWhenPlayed: true
    // highlighted by the keyboard cursor
    property bool keyboardFocus: false

    readonly property bool showsPreview: !played && preview
    readonly property string valueText: played ? String(score) : showsPreview ? String(potential) : ""

    implicitHeight: 40
    leftPadding: 12
    rightPadding: 12
    font.pointSize: 16
    hoverEnabled: true
    focusPolicy: Qt.NoFocus

    contentItem: Item {
        implicitHeight: nameText.implicitHeight

        Text {
            id: nameText
            anchors.left: parent.left
            anchors.right: detailText.left
            anchors.rightMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            text: button.name
            font.pointSize: button.font.pointSize
            font.bold: button.font.bold
            font.strikeout: button.played && button.strikeoutWhenPlayed
            color: button.played && button.strikeoutWhenPlayed ? Style.inkMuted : Style.ink
            elide: Text.ElideRight
        }

        Text {
            id: detailText
            anchors.right: valueText.left
            anchors.rightMargin: text ? 8 : 0
            anchors.baseline: nameText.baseline
            text: button.detail
            font.pointSize: button.font.pointSize * 0.7
            color: Style.inkMuted
        }

        Text {
            id: valueText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(implicitWidth, 30)
            horizontalAlignment: Text.AlignRight
            text: button.valueText
            font.pointSize: button.font.pointSize
            font.bold: button.font.bold || button.played
            color: !button.showsPreview ? Style.ink
                 : button.potential > 0 ? Style.inkPreview
                 : Style.inkPreviewZero
        }
    }

    // draw the ruled line under the row
    property bool ruled: true

    background: Rectangle {
        radius: 6
        color: button.enabled && (button.down || button.hovered || button.keyboardFocus)
               ? Style.paperHover : "transparent"
        border.width: button.keyboardFocus ? 2 : 0
        border.color: Style.accent

        Rectangle {
            visible: button.ruled
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Style.hairline
            color: Style.paperLine
        }
    }
}
