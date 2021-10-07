import QtQuick 2.0
import "."

Rectangle {
    id: baseRect
    implicitWidth: 420
    implicitHeight: 360
    border.width: 2
    border.color: Style.highlightColor
    color: Style.scoreCardColor
    radius: 15

    Grid {
        id: scoreGrid
        anchors.centerIn: parent
        columns: 2
        clip: true

        ScoreButton {
            hand: "Ones"
            value: engine.ones
        }

        ScoreButton {
            hand: "Two pairs"
            value: engine.twoPairs
        }

        ScoreButton {
            hand: "Twos"
            value: engine.twos
        }

        ScoreButton {
            hand: "Three of kind"
            value: engine.threeKind
        }

        ScoreButton {
            hand: "Threes"
            value: engine.threes
        }

        ScoreButton {
            hand: "Four of kind"
            value: engine.fourKind
        }

        ScoreButton {
            hand: "Fours"
            value: engine.fours
        }

        ScoreButton {
            hand: "Small straight"
            value: engine.smallStraight
        }

        ScoreButton {
            hand: "Fives"
            value: engine.fives
        }

        ScoreButton {
            hand: "Big straight"
            value: engine.bigStraight
        }

        ScoreButton {
            hand: "Sixes"
            value: engine.sixes
        }

        ScoreButton {
            hand: "Full house"
            value: engine.fullHouse
        }

        ScoreButton {
            hand: "Bonus"
            played: true
            text: engine.upbonus
        }

        ScoreButton {
            hand: "Yatzy"
            value: engine.yatzy
        }

        ScoreButton {
            hand: "Pair"
            value: engine.pair
        }

        ScoreButton {
            hand: "Chance"
            value: engine.chance
        }
    }

    Text {
        text: "Total: " + engine.total
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: scoreGrid.horizontalCenter
        color: Style.pageTextColor
        font.bold: true
    }
}
