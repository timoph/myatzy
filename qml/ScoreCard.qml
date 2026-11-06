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

Item {
    id: baseRect
    // false while the dice are rolling, so the result is not given away early
    property bool interactive: true
    // category highlighted for keyboard play, -1 when none
    property int cursor: -1

    readonly property int upperCount: 6
    readonly property int categoryCount: 15

    function sectionStart(category) { return category < upperCount ? 0 : upperCount }
    function sectionLength(category) { return category < upperCount ? upperCount : categoryCount - upperCount }

    function firstPlayable() {
        for (let c = 0; c < categoryCount; c++) {
            if (Engine.canScoreCategory(c))
                return c
        }
        return -1
    }

    // Moves the cursor up (-1) or down (1) within its section, skipping played rows.
    function moveVertical(step) {
        if (!Engine.canScoreCategory(cursor)) {
            cursor = firstPlayable()
            return
        }
        const start = sectionStart(cursor)
        const length = sectionLength(cursor)
        let row = cursor - start
        for (let i = 0; i < length; i++) {
            row = (row + step + length) % length
            if (Engine.canScoreCategory(start + row)) {
                cursor = start + row
                return
            }
        }
    }

    // Moves the cursor to the nearest playable row of the other section.
    function switchSection() {
        if (!Engine.canScoreCategory(cursor)) {
            cursor = firstPlayable()
            return
        }
        const row = cursor - sectionStart(cursor)
        const start = cursor < upperCount ? upperCount : 0
        const length = cursor < upperCount ? categoryCount - upperCount : upperCount
        for (let d = 0; d < length; d++) {
            for (const r of [row - d, row + d]) {
                if (r >= 0 && r < length && Engine.canScoreCategory(start + r)) {
                    cursor = start + r
                    return
                }
            }
        }
    }

    function scoreCursor() {
        if (interactive && Engine.scoreCategory(cursor))
            cursor = -1
    }
    implicitWidth: 460
    implicitHeight: sections.implicitHeight + 2 * sections.anchors.margins

    // drop shadow
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: -4
        radius: Style.radiusLarge
        color: Style.shadow
    }

    Rectangle {
        anchors.fill: parent
        radius: Style.radiusLarge
        color: Style.paper
    }

    // divider between the upper and lower section
    Rectangle {
        x: sections.x + sections.columnWidth + sections.spacing / 2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 14
        width: Style.hairline
        color: Style.paperLine
    }

    Component {
        id: scoreDelegate

        ScoreButton {
            id: scoreRow
            // filled from the model roles of the same names
            required property int category
            required name
            required score
            required played
            required potential

            width: parent ? parent.width : 0
            preview: Engine.canScore && baseRect.interactive
            enabled: Engine.canScore && baseRect.interactive && !played
            keyboardFocus: enabled && category === baseRect.cursor
            onClicked: {
                baseRect.cursor = -1
                Engine.scoreCategory(scoreRow.category)
            }
        }
    }

    Row {
        id: sections
        anchors.fill: parent
        anchors.margins: 10
        spacing: 16

        readonly property real columnWidth: (width - spacing) / 2

        Column {
            width: sections.columnWidth

            Repeater {
                model: Engine.upperSection
                delegate: scoreDelegate
            }

            ScoreButton {
                width: parent.width
                name: qsTr("Bonus")
                detail: Engine.upperBonus > 0 ? "" : qsTr("%1 / 63").arg(Engine.upperSum)
                score: Engine.upperBonus
                played: true
                strikeoutWhenPlayed: false
                enabled: false
                ruled: false
            }

            // keeps the total level with the last row of the lower section
            Item {
                width: parent.width
                height: 40
            }

            ScoreButton {
                width: parent.width
                name: qsTr("Total")
                score: Engine.total
                played: true
                strikeoutWhenPlayed: false
                enabled: false
                ruled: false
                font.bold: true
            }
        }

        Column {
            width: sections.columnWidth

            Repeater {
                model: Engine.lowerSection
                delegate: scoreDelegate
            }
        }
    }
}
