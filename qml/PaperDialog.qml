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

// Modal dialog in the paper style: a title, free content and a button row.
Popup {
    id: dialog
    property string title: ""
    default property alias content: body.data
    property alias buttons: buttonRow.data

    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(parent ? parent.width - 48 : 420, 420)
    modal: true
    dim: true
    padding: 24
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Overlay.modal: Rectangle {
        color: Style.dim
    }

    background: Rectangle {
        radius: Style.radiusLarge
        color: Style.paper
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.92; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; to: 0.0; duration: 100 }
    }

    contentItem: Column {
        spacing: 20

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: dialog.title
            visible: text.length > 0
            color: Style.ink
            font.pointSize: 22
            font.bold: true
        }

        Column {
            id: body
            width: parent.width
            spacing: 12
        }

        Row {
            id: buttonRow
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
        }
    }
}
