import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }

        ToolButton {
            id: selectButton
            anchors.centerIn: parent
            text: "Roll'em"
            enabled: engine.gameState === 0 || engine.gameState === 1 || engine.gameState === 2
            onClicked: {
                mainPage.roll()
            }
        }
    }

    QueryDialog {
        id: scoreDialog
        titleText: qsTr("Top 3 scores")
        message: engine.highScores
        acceptButtonText: "ok"
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("New game")
                onClicked: {
                    engine.newGame()
                }
            }
            MenuItem {
                text: qsTr("High scores")
                onClicked: {
                    scoreDialog.open()
                }
            }
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    aboutDialog.open()
                }
            }
        }
    }

    QueryDialog {
        id: aboutDialog
        titleText: qsTr("myatzy v1.0")
        message: qsTr("by Timo Härkönen\ntimop.harkonen@gmail.com\n\n" +
                      "The game's objective is to get different hands by throwing the dices three times.\n" +
                      "For ones, twos, threes, etc. the goal is to get as many of the named numbers as possible." +
                      " You'll get a 50 point bonus if the cumulative score of those is 63 or above. " +
                      "You get a yatzy by having any number five times. Yatzy gives you 50 points. " +
                      "Small straight is 1-5, big is 2-6, full house is three and two of a kind. " +
                      "Chance counts all the dice scores together." +
                        "\n\nFor more information about yatzy, see\nhttp://en.wikipedia.org/wiki/Yatzy"
                      )
        acceptButtonText: "ok"
    }

    Component.onCompleted: {
        theme.inverted = true
    }
}
