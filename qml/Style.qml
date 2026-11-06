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

pragma Singleton

import QtQuick

// Colors and shared metrics. A green card table with a paper score sheet.
QtObject {
    // the table
    readonly property color feltTop: "#1f6e52"
    readonly property color feltBottom: "#0c3326"
    readonly property color textOnFelt: "#f3ead3"
    readonly property color textOnFeltMuted: "#a7c2b4"
    readonly property color shadow: "#59000000"

    // buttons and highlights
    readonly property color accent: "#f2b84b"
    readonly property color accentPressed: "#d99a2b"
    readonly property color textOnAccent: "#3a2a07"
    readonly property color secondary: "#e8dfc8"
    readonly property color secondaryPressed: "#d6caab"

    // the score sheet
    readonly property color paper: "#f7f2e5"
    readonly property color paperLine: "#e4dac2"
    readonly property color paperHover: "#ede2c6"
    readonly property color ink: "#2b2721"
    readonly property color inkMuted: "#a39a86"
    readonly property color inkPreview: "#2f6db3"
    readonly property color inkPreviewZero: "#c3b9a3"

    // dice
    readonly property color die: "#fffdf8"
    readonly property color dieEdge: "#d9d2c0"
    readonly property color dieHeld: "#ffe7a8"
    readonly property color pip: "#24211c"

    // dialogs
    readonly property color dim: "#99000000"

    // size the game is laid out in, and the factor it is scaled with to fit
    // the window (set by the main window)
    readonly property int designWidth: 500
    readonly property int designHeight: 650
    property real uiScale: 1.0
    // Thickness of one physical pixel in design units. A line exactly one
    // pixel thick always covers one pixel row, wherever the scaling puts it;
    // a 1 unit line would cover one or two rows depending on its position.
    readonly property real hairline: 1 / uiScale

    readonly property int radiusLarge: 16
    readonly property int radiusSmall: 8
}
