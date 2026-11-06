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

#include "engine.h"
#include "scoring.h"
#include <QDateTime>
#include <QSettings>
#include <QRandomGenerator>

Engine::Engine(QObject *parent) :
    QObject(parent)
{
    m_clickable = false;
    m_dice1 = 1;
    m_dice2 = 2;
    m_dice3 = 3;
    m_dice4 = 4;
    m_dice5 = 5;
    m_ones = 0;
    m_twos = 0;
    m_threes = 0;
    m_fours = 0;
    m_fives = 0;
    m_sixes = 0;
    m_upBonus = 0;
    m_pair = 0;
    m_twopairs = 0;
    m_threekind = 0;
    m_fourkind = 0;
    m_fullhouse = 0;
    m_smallstraight = 0;
    m_bigstraight = 0;
    m_chance = 0;
    m_yatsy = 0;
    m_total = 0;
    m_topLabel = tr("Roll the dice (1/3)");
    m_diceSelect = false;
    m_turnCount = 1;
    m_gameState = 0;
    m_secondTry = false;
    setHighScores("");
}

void Engine::newGame()
{
    setOnes(0);
    setTwos(0);
    setThrees(0);
    setFours(0);
    setFives(0);
    setSixes(0);
    setUpbonus(0);
    setPair(0);
    setTwoPairs(0);
    setThreeKind(0);
    setFourKind(0);
    setFullHouse(0);
    setSmallStraight(0);
    setBigStraight(0);
    setChance(0);
    setYatzy(0);
    setTotal(0);
    setTopLabel(tr("Roll the dice (1/3)"));
    m_turnCount = 1;
    setGameState(0);
    emit newGameTriggered();
}

void Engine::rollDice(int diceNo)
{
    switch(diceNo) {
    case 1:
        setDice1(QRandomGenerator::global()->bounded(1, 7));
        break;
    case 2:
        setDice2(QRandomGenerator::global()->bounded(1, 7));
        break;
    case 3:
        setDice3(QRandomGenerator::global()->bounded(1, 7));
        break;
    case 4:
        setDice4(QRandomGenerator::global()->bounded(1, 7));
        break;
    case 5:
        setDice5(QRandomGenerator::global()->bounded(1, 7));
        break;
    default:
        break;
    }
}

void Engine::skipRoll()
{
    emit resetSelections();
    setTopLabel(tr("Select hand"));
    setGameState(3);
}

void Engine::forward()
{
    if(m_gameState == 0) {
        setTopLabel(tr("Select dice to keep and roll (2/3)"));
        setGameState(1);
    }
    else if(m_gameState == 1) {
        setTopLabel(tr("Select dice to keep and roll (3/3)"));
        setGameState(2);
    }
    else if(m_gameState == 2) {
        emit resetSelections();
        setTopLabel(tr("Select hand"));
        setGameState(3);
    }
}

void Engine::setGameState(const int state)
{
    if(state != m_gameState) {
        m_gameState = state;
        emit gameStateChanged(m_gameState);
    }
}

void Engine::handleScoreButtonClick(const QString &hand)
{
    using Scoring::Category;

    const Category category = Scoring::categoryFromName(hand);
    if(category == Category::Invalid) {
        // e.g. the Bonus row: not a playable hand, must not consume a turn
        return;
    }

    const QList<int> dice = { m_dice1, m_dice2, m_dice3, m_dice4, m_dice5 };
    const int points = Scoring::score(category, dice);

    switch(category) {
    case Category::Ones: setOnes(points); break;
    case Category::Twos: setTwos(points); break;
    case Category::Threes: setThrees(points); break;
    case Category::Fours: setFours(points); break;
    case Category::Fives: setFives(points); break;
    case Category::Sixes: setSixes(points); break;
    case Category::Pair: setPair(points); break;
    case Category::TwoPairs: setTwoPairs(points); break;
    case Category::ThreeKind: setThreeKind(points); break;
    case Category::FourKind: setFourKind(points); break;
    case Category::SmallStraight: setSmallStraight(points); break;
    case Category::BigStraight: setBigStraight(points); break;
    case Category::FullHouse: setFullHouse(points); break;
    case Category::Chance: setChance(points); break;
    case Category::Yatzy: setYatzy(points); break;
    case Category::Invalid: break;
    }

    m_turnCount++;
    setUpbonus(0);
    setTotal(0);

    if(m_turnCount > TotalTurns) {
        setTopLabel(tr("Game over"));
        setGameState(4);
        checkHighScores();
    }
    else {
        setGameState(0);
        setTopLabel(tr("Roll the dice (1/3)"));
    }
}

void Engine::setDice1(const int val)
{
    if(val != m_dice1) {
        m_dice1 = val;
        emit dice1Changed(m_dice1);
    }
}

void Engine::setDice2(const int val)
{
    if(val != m_dice2) {
        m_dice2 = val;
        emit dice2Changed(m_dice2);
    }
}

void Engine::setDice3(const int val)
{
    if(val != m_dice3) {
        m_dice3 = val;
        emit dice3Changed(m_dice3);
    }
}

void Engine::setDice4(const int val)
{
    if(val != m_dice4) {
        m_dice4 = val;
        emit dice4Changed(m_dice4);
    }
}

void Engine::setDice5(const int val)
{
    if(val != m_dice5) {
        m_dice5 = val;
        emit dice5Changed(m_dice5);
    }
}

void Engine::setOnes(const int val)
{
    if(m_ones != val) {
        m_ones = val;
        emit onesChanged(m_ones);
    }
}

void Engine::setTwos(const int val)
{
    if(m_twos != val) {
        m_twos = val;
        emit twosChanged(m_twos);
    }
}

void Engine::setThrees(const int val)
{
    if(m_threes != val) {
        m_threes = val;
        emit threesChanged(m_threes);
    }
}

void Engine::setFours(const int val)
{
    if(m_fours != val) {
        m_fours = val;
        emit foursChanged(m_fours);
    }
}

void Engine::setFives(const int val)
{
    if(m_fives != val) {
        m_fives = val;
        emit fivesChanged(m_fives);
    }
}

void Engine::setSixes(const int val)
{
    if(m_sixes != val) {
        m_sixes = val;
        emit sixesChanged(m_sixes);
    }
}

void Engine::setPair(const int val)
{
    if(m_pair != val) {
        m_pair = val;
        emit pairChanged(m_pair);
    }
}

void Engine::setTwoPairs(const int val)
{
    if(m_twopairs != val) {
        m_twopairs = val;
        emit twoPairsChanged(m_twopairs);
    }
}

void Engine::setThreeKind(const int val)
{
    if(m_threekind != val) {
        m_threekind = val;
        emit threeKindChanged(m_threekind);
    }
}

void Engine::setFourKind(const int val)
{
    if(m_fourkind != val) {
        m_fourkind = val;
        emit fourKindChanged(m_fourkind);
    }
}

void Engine::setSmallStraight(const int val)
{
    if(m_smallstraight != val) {
        m_smallstraight = val;
        emit smallStraightChanged(m_smallstraight);
    }
}

void Engine::setBigStraight(const int val)
{
    if(m_bigstraight != val) {
        m_bigstraight = val;
        emit bigStraightChanged(m_bigstraight);
    }
}

void Engine::setFullHouse(const int val)
{
    if(m_fullhouse != val) {
        m_fullhouse = val;
        emit fullHouseChanged(m_fullhouse);
    }
}

void Engine::setChance(const int val)
{
    if(m_chance != val) {
        m_chance = val;
        emit chanceChanged(m_chance);
    }
}

void Engine::setYatzy(const int val)
{
    if(m_yatsy != val) {
        m_yatsy = val;
        emit yatzyChanged(m_yatsy);
    }
}

void Engine::setUpbonus(const int val)
{
    Q_UNUSED(val)

    const int bonus = Scoring::upperBonus(m_ones + m_twos + m_threes + m_fours + m_fives + m_sixes);
    if(bonus != m_upBonus) {
        m_upBonus = bonus;
        emit upbonusChanged(m_upBonus);
    }
}

void Engine::setTotal(const int val)
{
    Q_UNUSED(val)
    int tmp = m_ones + m_twos + m_threes + m_fours + m_fives + m_sixes +
            m_pair + m_twopairs + m_threekind + m_fourkind + m_smallstraight +
            m_bigstraight + m_fullhouse + m_chance + m_yatsy + m_upBonus;

    if(tmp != m_total) {
        m_total = tmp;
        emit totalChanged(m_total);
    }
}

void Engine::setClickable(bool val)
{
    if(val != m_clickable) {
        m_clickable = val;
        emit clickableChanged(m_clickable);
    }
}

void Engine::setTopLabel(const QString &txt)
{
    if(m_topLabel != txt) {
        m_topLabel = txt;
        emit topLabelChanged(m_topLabel);
    }
}

void Engine::setDiceSelect(bool areThey)
{
    if(m_diceSelect != areThey) {
        m_diceSelect = areThey;
        emit diceSelectChanged(m_diceSelect);
    }
}

int Engine::highScoreFromSettings(int place)
{
    QSettings settings;
    return settings.value(QString("high/%1").arg(place), 0).toInt();
}

void Engine::highScoreToSettings(int place, int value)
{
    QSettings settings;
    settings.setValue(QString("high/%1").arg(place), value);
}

void Engine::checkHighScores()
{
    int one = highScoreFromSettings(1);
    int two = highScoreFromSettings(2);
    int three = highScoreFromSettings(3);

    if(m_total > one) {
        highScoreToSettings(1, m_total);
        highScoreToSettings(2, one);
        highScoreToSettings(3, two);
        setHighScores("");
        emit displayMessage(tr("New high score"));
    }
    else if(m_total > two) {
        highScoreToSettings(2, m_total);
        highScoreToSettings(3, two);
        setHighScores("");
        emit displayMessage(tr("New 2nd best score"));
    }
    else if(m_total > three) {
        highScoreToSettings(3, m_total);
        setHighScores("");
        emit displayMessage(tr("New 3rd best score"));
    }
}

void Engine::setHighScores(const QString &txt)
{
    Q_UNUSED(txt)
    int one = highScoreFromSettings(1);
    int two = highScoreFromSettings(2);
    int three = highScoreFromSettings(3);

    QString scores = QString("1.\t%1\n2.\t%2\n3.\t%3").arg(one)
            .arg(two)
            .arg(three);

    if(scores != m_highScores) {
        m_highScores = scores;
        emit highScoresChanged(m_highScores);
    }
}
