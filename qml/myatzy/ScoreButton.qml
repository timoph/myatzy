// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Button {
    id: rootRect
    property int value: 0
    property string hand: "test hand"
    property bool played: false
    width: 100
    height: 62
    text: rootRect.played ? value : engine.gameState === 3 ? "select" : ""
    enabled: !played && engine.gameState === 3
    onClicked: {
        engine.handleScoreButtonClick(hand)
        played = true
    }

    Connections {
        target: engine
        onNewGameTriggered: {
            if(hand != "bonus")
                rootRect.played = false
        }
    }
}
