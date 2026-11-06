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

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic

// The big roll button. The pips show how many rolls are left this turn.
Button {
    id: button
    property int rollsLeft: 0
    property int maxRolls: 3

    implicitWidth: Math.max(200, implicitContentWidth + 64)
    implicitHeight: 64
    focusPolicy: Qt.NoFocus
    text: qsTr("Roll")
    font.pointSize: 20
    font.bold: true

    scale: down ? 0.96 : 1.0
    Behavior on scale { NumberAnimation { duration: 80 } }

    contentItem: Row {
        spacing: 14

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: button.text
            font: button.font
            color: Style.textOnAccent
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            visible: button.maxRolls > 0

            Repeater {
                model: button.maxRolls

                Rectangle {
                    required property int index
                    width: 12
                    height: 12
                    radius: 6
                    border.width: 2
                    border.color: Style.textOnAccent
                    color: index < button.rollsLeft ? Style.textOnAccent : "transparent"
                }
            }
        }
    }

    background: Item {
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 4
            radius: height / 2
            color: Style.shadow
        }

        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: button.down ? 0 : 4
            anchors.topMargin: button.down ? 4 : 0
            radius: height / 2
            color: button.down ? Style.accentPressed : Style.accent
        }
    }

    opacity: enabled ? 1.0 : 0.4
    Behavior on opacity { NumberAnimation { duration: 150 } }
}
