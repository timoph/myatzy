import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Window {
    id: appWindow
    width: 480
    height: 800

    title: "Myatzy"

    MainPage {
        id: mainPage
    }

    visibility: Window.Windowed

    RowLayout {
        spacing: 10
        anchors.top: mainPage.bottom
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: ngButton
            text: "new game"
            onClicked: engine.newGame()
        }

        Button {
            id: hsButton
            text: "Highscores"
            onClicked: messageRect.showMessage(qsTr("Top 3 scores"), engine.highScores)
        }

        Button {
            id: aboutButton
            text: "About"
            onClicked: messageRect.showMessage(qsTr("Myatzy"),
                                               qsTr("The game's objective is to get different hands by throwing the dices three times.\n" +
                                                                     "For ones, twos, threes, etc. the goal is to get as many of the named numbers as possible.\n\n" +
                                                                     " You'll get a 50 point bonus if the cumulative score of those is 63 or above.\n\n " +
                                                                     "You get a yatzy by having any number five times. Yatzy gives you 50 points. \n\n" +
                                                                     "Small straight is 1-5, big is 2-6, full house is three and two of a kind.\n\n " +
                                                                     "Chance counts all the dice scores together.\n\n" +
                                                                       "\n\nFor more information about yatzy, see\nhttp://en.wikipedia.org/wiki/Yatzy"
                                                                     ))
        }

        Button {
            id: quitButton
            text: "Quit"
            onClicked: Qt.quit()
        }
    }

    Rectangle {
        id: messageRect
        width: parent.width
        height: parent.height
        visible: false

        function showMessage(titleString, messageString) {
            messageRect.visible = true;
            baseText.text = messageString;
            titleText.text = titleString;
        }

        function hideMessage() {
            messageRect.visible = false;
        }

        Text {
            id: titleText
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: ""
        }

        TextArea {
            id: baseText
            anchors.top: titleText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 40
            text: ""
        }

        Button {
            id: okButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            text: "ok"
            onClicked: messageRect.hideMessage();
        }
    }
}
