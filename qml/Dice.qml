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

// A single die. Pips are laid out relative to the die size. A held die is
// lifted, outlined in the accent color and tagged.
Item {
    id: diceRoot
    property int diceValue: 1
    property bool held: false
    property bool holdable: false
    // dimmed before the first roll of a turn
    property bool inactive: false
    // the face drawn; differs from diceValue while the roll animation runs
    property int shownValue: diceValue
    readonly property bool rolling: rollAnimation.running
    signal clicked()

    // Tumbles the die for a moment before showing diceValue.
    function roll() {
        rollAnimation.duration = 450 + Math.floor(Math.random() * 300)
        rollAnimation.direction = Math.random() < 0.5 ? -1 : 1
        rollAnimation.restart()
    }

    // visible pips for each face, positions 0..8 of the 3x3 grid row by row
    readonly property var pips: [[], [4], [1, 7], [2, 4, 6], [0, 2, 6, 8], [0, 2, 4, 6, 8], [0, 2, 3, 5, 6, 8]]

    implicitWidth: 80
    implicitHeight: 80
    Accessible.role: Accessible.CheckBox
    Accessible.name: qsTr("Die showing %1").arg(diceValue)
    Accessible.checked: held

    Item {
        id: face
        width: parent.width
        height: parent.height
        y: diceRoot.held ? -8 : 0
        opacity: diceRoot.inactive ? 0.7 : 1.0

        transformOrigin: Item.Center
        Behavior on y { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
        Behavior on opacity { NumberAnimation { duration: 200 } }

        // drop shadow, longer when lifted
        Rectangle {
            anchors.fill: body
            anchors.topMargin: diceRoot.held ? 10 : 3
            anchors.bottomMargin: diceRoot.held ? -10 : -3
            radius: body.radius
            color: Style.shadow
        }

        Rectangle {
            id: body
            anchors.fill: parent
            radius: width * 0.18
            color: diceRoot.held ? Style.dieHeld : Style.die
            border.width: diceRoot.held ? 3 : 1
            border.color: diceRoot.held ? Style.accent : Style.dieEdge

            Repeater {
                model: 9

                Dot {
                    required property int index
                    readonly property real pipSize: body.width * 0.17
                    width: pipSize
                    height: pipSize
                    x: body.width * (0.25 + 0.25 * (index % 3)) - pipSize / 2
                    y: body.height * (0.25 + 0.25 * Math.floor(index / 3)) - pipSize / 2
                    empty: !(diceRoot.pips[diceRoot.shownValue] || []).includes(index)
                }
            }
        }

        Rectangle {
            id: holdTag
            anchors.horizontalCenter: body.horizontalCenter
            anchors.verticalCenter: body.bottom
            width: holdText.implicitWidth + 14
            height: holdText.implicitHeight + 4
            radius: height / 2
            color: Style.accent
            visible: diceRoot.held

            Text {
                id: holdText
                anchors.centerIn: parent
                text: qsTr("HOLD")
                font.pointSize: 8
                font.bold: true
                color: Style.textOnAccent
            }
        }
    }

    SequentialAnimation {
        id: rollAnimation
        property int duration: 600
        property int direction: 1

        ScriptAction { script: flicker.start() }

        ParallelAnimation {
            RotationAnimation {
                target: face
                from: 0
                to: 360 * rollAnimation.direction
                duration: rollAnimation.duration
                easing.type: Easing.OutCubic
            }

            SequentialAnimation {
                NumberAnimation {
                    target: face
                    property: "scale"
                    to: 0.8
                    duration: rollAnimation.duration * 0.3
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: face
                    property: "scale"
                    to: 1.0
                    duration: rollAnimation.duration * 0.7
                    easing.type: Easing.OutBack
                }
            }
        }

        ScriptAction {
            script: {
                flicker.stop()
                face.rotation = 0
                diceRoot.shownValue = Qt.binding(() => diceRoot.diceValue)
            }
        }
    }

    // random faces while tumbling
    Timer {
        id: flicker
        interval: 70
        repeat: true
        onTriggered: diceRoot.shownValue = 1 + Math.floor(Math.random() * 6)
    }

    MouseArea {
        anchors.fill: parent
        enabled: diceRoot.holdable
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: diceRoot.clicked()
    }
}
