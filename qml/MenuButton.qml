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

import QtQuick 2.0
import QtQuick.Controls 2.4
import "."

Item {
    id: base
    implicitHeight: 80
    implicitWidth: 160

    property string text: ""
    property bool drawBorders: true
    property bool transparentBackground: false
    property int fontSize: 20

    signal clicked()

    Button {
        id: button
        height: base.height
        text: base.text
        anchors.fill: parent
        font.pointSize: base.fontSize

        contentItem: Text {
            text: button.text
            font: button.font
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: enabled ? 1.0 : 0.3
            color: button.down ? Style.highlightColor : Style.buttonTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 60
            implicitHeight: 60
            border.color: Style.buttonBorderColor
            border.width: base.drawBorders ? 2 : 0
            color: Style.buttonColor
            opacity: base.transparentBackground ? 0.0 : 1.0
        }

        onClicked: base.clicked()
    }
}
