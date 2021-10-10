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

#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>

/* TODO: find and remove unused code */

class Engine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dice1 READ dice1 WRITE setDice1 NOTIFY dice1Changed)
    Q_PROPERTY(int dice2 READ dice2 WRITE setDice2 NOTIFY dice2Changed)
    Q_PROPERTY(int dice3 READ dice3 WRITE setDice3 NOTIFY dice3Changed)
    Q_PROPERTY(int dice4 READ dice4 WRITE setDice4 NOTIFY dice4Changed)
    Q_PROPERTY(int dice5 READ dice5 WRITE setDice5 NOTIFY dice5Changed)
    Q_PROPERTY(int ones READ ones WRITE setOnes NOTIFY onesChanged)
    Q_PROPERTY(int twos READ twos WRITE setTwos NOTIFY twosChanged)
    Q_PROPERTY(int threes READ threes WRITE setThrees NOTIFY threesChanged)
    Q_PROPERTY(int fours READ fours WRITE setFours NOTIFY foursChanged)
    Q_PROPERTY(int fives READ fives WRITE setFives NOTIFY fivesChanged)
    Q_PROPERTY(int sixes READ sixes WRITE setSixes NOTIFY sixesChanged)
    Q_PROPERTY(int upbonus READ upbonus WRITE setUpbonus NOTIFY upbonusChanged)
    Q_PROPERTY(int pair READ pair WRITE setPair NOTIFY pairChanged)
    Q_PROPERTY(int twoPairs READ twoPairs WRITE setTwoPairs NOTIFY twoPairsChanged)
    Q_PROPERTY(int threeKind READ threeKind WRITE setThreeKind NOTIFY threeKindChanged)
    Q_PROPERTY(int fourKind READ fourKind WRITE setFourKind NOTIFY fourKindChanged)
    Q_PROPERTY(int smallStraight READ smallStraight WRITE setSmallStraight NOTIFY smallStraightChanged)
    Q_PROPERTY(int bigStraight READ bigStraight WRITE setBigStraight NOTIFY bigStraightChanged)
    Q_PROPERTY(int fullHouse READ fullHouse WRITE setFullHouse NOTIFY fullHouseChanged)
    Q_PROPERTY(int chance READ chance WRITE setChance NOTIFY chanceChanged)
    Q_PROPERTY(int yatzy READ yatzy WRITE setYatzy NOTIFY yatzyChanged)
    Q_PROPERTY(int total READ total WRITE setTotal NOTIFY totalChanged)
    Q_PROPERTY(bool clickable READ clickable WRITE setClickable NOTIFY clickableChanged)
    Q_PROPERTY(QString topLabel READ topLabel WRITE setTopLabel NOTIFY topLabelChanged)
    Q_PROPERTY(bool diceSelect READ diceSelect WRITE setDiceSelect NOTIFY diceSelectChanged)
    Q_PROPERTY(int gameState READ gameState WRITE setGameState NOTIFY gameStateChanged)
    Q_PROPERTY(QString highScores READ highScores WRITE setHighScores NOTIFY highScoresChanged)

public:
    explicit Engine(QObject *parent = 0);
    Q_INVOKABLE void rollDice(int diceNo);
    Q_INVOKABLE void skipRoll();
    Q_INVOKABLE void forward();
    Q_INVOKABLE void handleScoreButtonClick(const QString &hand);
    Q_INVOKABLE void newGame();
    Q_INVOKABLE int highScoreFromSettings(int place);
    int dice1() const { return m_dice1; }
    int dice2() const { return m_dice2; }
    int dice3() const { return m_dice3; }
    int dice4() const { return m_dice4; }
    int dice5() const { return m_dice5; }
    int ones() const { return m_ones; }
    int twos() const { return m_twos; }
    int threes() const { return m_threes; }
    int fours() const { return m_fours; }
    int fives() const { return m_fives; }
    int sixes() const { return m_sixes; }
    int pair() const { return m_pair; }
    int twoPairs() const { return m_twopairs; }
    int threeKind() const { return m_threekind; }
    int fourKind() const { return m_fourkind; }
    int smallStraight() const { return m_smallstraight; }
    int bigStraight() const { return m_bigstraight; }
    int fullHouse() const { return m_fullhouse; }
    int chance() const { return m_chance; }
    int yatzy() const { return m_yatsy; }
    int upbonus() const { return m_upBonus; }
    int total() const { return m_total; }
    int clickable() const { return m_clickable; }
    QString topLabel() const { return m_topLabel; }
    bool diceSelect() const { return m_diceSelect; }
    int gameState() const { return m_gameState; }
    QString highScores() const { return m_highScores; }

signals:
    void dice1Changed(const int val);
    void dice2Changed(const int val);
    void dice3Changed(const int val);
    void dice4Changed(const int val);
    void dice5Changed(const int val);
    void onesChanged(const int val);
    void twosChanged(const int val);
    void threesChanged(const int val);
    void foursChanged(const int val);
    void fivesChanged(const int val);
    void sixesChanged(const int val);
    void pairChanged(const int val);
    void twoPairsChanged(const int val);
    void threeKindChanged(const int val);
    void fourKindChanged(const int val);
    void smallStraightChanged(const int val);
    void bigStraightChanged(const int val);
    void fullHouseChanged(const int val);
    void chanceChanged(const int val);
    void yatzyChanged(const int val);
    void upbonusChanged(const int val);
    void totalChanged(const int val);
    void clickableChanged(bool val);
    void topLabelChanged(const QString &txt);
    void diceSelectChanged(bool areThey);
    void displayMessage(const QString &msg);
    void resetSelections();
    void gameStateChanged(const int state);
    void newGameTriggered();
    void highScoresChanged(const QString &txt);

public slots:
    void setDice1(const int val);
    void setDice2(const int val);
    void setDice3(const int val);
    void setDice4(const int val);
    void setDice5(const int val);
    void setOnes(const int val);
    void setTwos(const int val);
    void setThrees(const int val);
    void setFours(const int val);
    void setFives(const int val);
    void setSixes(const int val);
    void setPair(const int val);
    void setTwoPairs(const int val);
    void setThreeKind(const int val);
    void setFourKind(const int val);
    void setSmallStraight(const int val);
    void setBigStraight(const int val);
    void setFullHouse(const int val);
    void setChance(const int val);
    void setYatzy(const int val);
    void setUpbonus(const int val);
    void setTotal(const int val);
    void setClickable(bool val);
    void setTopLabel(const QString &txt);
    void setDiceSelect(bool areThey);
    void setGameState(const int state);
    void setHighScores(const QString &txt);

private:
    int countSameFaces(const int face);
    void highScoreToSettings(int place, int value);
    void checkHighScores();

private:
    int m_dice1;
    int m_dice2;
    int m_dice3;
    int m_dice4;
    int m_dice5;

    // hands - upper section
    int m_sixes;
    int m_fives;
    int m_fours;
    int m_threes;
    int m_twos;
    int m_ones;

    int m_upBonus;

    // hands lower section
    int m_pair;
    int m_twopairs;
    int m_threekind;
    int m_fourkind;
    int m_smallstraight;
    int m_fullhouse;
    int m_bigstraight;
    int m_chance;
    int m_yatsy; // 50
    
    int m_total;

    bool m_clickable;
    QString m_topLabel;
    bool m_diceSelect;
    int m_turnCount;
    int m_gameState;
    bool m_secondTry;
    QString m_highScores;
};

#endif // ENGINE_H
