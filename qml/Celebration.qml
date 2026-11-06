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

// Confetti burst with a "Yatzy!" banner. Does not take any input.
Item {
    id: celebration
    property int pieceCount: 70
    readonly property var colors: [Style.accent, Style.inkPreview, "#e4572e", "#76b041", Style.die]

    // Throws the confetti up from the given point of this item.
    function burst(originX, originY) {
        for (let i = 0; i < pieces.count; i++)
            (pieces.itemAt(i) as ConfettiPiece).launch(originX, originY)
        banner.show()
    }

    component ConfettiPiece: Rectangle {
        id: piece
        property real startX: 0
        property real startY: 0
        property real endX: 0
        property real peakY: 0
        property int flightTime: 1500

        width: 7 + Math.random() * 6
        height: width * (0.4 + Math.random() * 0.6)
        radius: Math.random() < 0.3 ? width / 2 : 1
        color: celebration.colors[Math.floor(Math.random() * celebration.colors.length)]
        visible: flight.running
        antialiasing: true

        function launch(ox, oy) {
            startX = ox + (Math.random() - 0.5) * 300
            startY = oy + (Math.random() - 0.5) * 30
            endX = startX + (Math.random() - 0.5) * 260
            peakY = oy - 180 - Math.random() * 260
            flightTime = 1300 + Math.random() * 900
            flight.restart()
        }

        ParallelAnimation {
            id: flight

            NumberAnimation {
                target: piece; property: "x"
                from: piece.startX; to: piece.endX
                duration: piece.flightTime
            }

            SequentialAnimation {
                NumberAnimation {
                    target: piece; property: "y"
                    from: piece.startY; to: piece.peakY
                    duration: piece.flightTime * 0.35
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: piece; property: "y"
                    to: celebration.height + 20
                    duration: piece.flightTime * 0.65
                    easing.type: Easing.InQuad
                }
            }

            NumberAnimation {
                target: piece; property: "rotation"
                from: 0; to: (Math.random() < 0.5 ? -1 : 1) * (360 + Math.random() * 720)
                duration: piece.flightTime
            }
        }
    }

    Repeater {
        id: pieces
        model: celebration.pieceCount
        delegate: ConfettiPiece {}
    }

    Text {
        id: banner
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -60
        text: qsTr("Yatzy!")
        color: Style.accent
        style: Text.Outline
        styleColor: Style.textOnAccent
        font.pointSize: 64
        font.bold: true
        opacity: 0
        scale: 0

        function show() {
            bannerAnimation.restart()
        }

        SequentialAnimation {
            id: bannerAnimation

            ParallelAnimation {
                NumberAnimation { target: banner; property: "opacity"; from: 0; to: 1; duration: 150 }
                NumberAnimation {
                    target: banner; property: "scale"
                    from: 0.3; to: 1.0
                    duration: 450
                    easing.type: Easing.OutBack
                    easing.overshoot: 2.5
                }
            }
            PauseAnimation { duration: 900 }
            ParallelAnimation {
                NumberAnimation { target: banner; property: "opacity"; to: 0; duration: 400 }
                NumberAnimation { target: banner; property: "scale"; to: 1.3; duration: 400 }
            }
        }
    }
}
