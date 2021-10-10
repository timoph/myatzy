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
import "."
pragma Singleton

Item {
    readonly property string menuBgColor: "#000000"
    readonly property string pageBgColor: "#000000"
    readonly property string pageTextColor: "#ffffff"
    readonly property string highlightColor: "#800080"
    readonly property string diceSelectedColor: "#989898"
    readonly property string diceDefaultColor: "#dedede"
    readonly property string dotColor: "#000000"
    readonly property string emptyDotColor: "#00000000"
    readonly property string msgTextColor: "#000000"
    readonly property string scoreButtonColor: "#111"
    readonly property string scoreCardColor: "#111"
    readonly property string scoreCardTextColor: "#ffffff"
    readonly property string scoreButtonTextColor: "#fff"
    readonly property string buttonTextColor: "#ffffff"
    readonly property string buttonColor: "#555555"
    readonly property string buttonBorderColor: "#000"
}
