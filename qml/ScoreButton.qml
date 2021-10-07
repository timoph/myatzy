import QtQuick 2.3
import QtQuick.Controls 2.0
import "."

Button {
    id: button
    property int value: 0
    property string hand: "test hand"
    property bool played: false
    text: button.played ? value : engine.gameState === 3 ? "\u25cb" : ""
    enabled: !played && engine.gameState === 3
    font.strikeout:  played && hand !== "Bonus"
    font.pointSize: 16
    onClicked: {
        engine.handleScoreButtonClick(hand)
        played = true
    }

    contentItem: Row {
        spacing: 0
        Text {
            width: 140
            text: button.hand
            font: button.font
            color: Style.scoreButtonTextColor
            verticalAlignment: Text.AlignVCenter
            clip: true
        }

        Text {
            width: 30
            text: button.text
            font.pointSize: 16
            color: Style.scoreButtonTextColor
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        implicitWidth: 170
        implicitHeight: 40
        color: Style.scoreButtonColor
        border.width: 0 //!played && engine.gameState === 3 ? 2 : 0
        border.color: Style.scoreButtonTextColor
    }

    Connections {
        target: engine
        onNewGameTriggered: {
            if(hand != "Bonus")
                button.played = false
        }
    }
}
