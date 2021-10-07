import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import "."

Rectangle {
    id: mainPage
    anchors.fill: parent
    color: Style.pageBgColor

    Column {
        id: contentColumn
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 15

        ScoreCard {
            id: scoreCard
            anchors.horizontalCenter: parent.horizontalCenter
        }

        DiceRect {
            id: diceRect
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: topLabel
            text: engine.topLabel
            color: Style.pageTextColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    MenuButton {
        id: selectButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        text: "\u27f3"
        fontSize: 90
        width: 90
        height: width
        transparentBackground: true
        enabled: engine.gameState === 0 || engine.gameState === 1 || engine.gameState === 2
        onClicked: {
            diceRect.roll()
        }
    }
}
