#include "engine.h"
#include <QDateTime>
#include <QSettings>

Engine::Engine(QObject *parent) :
    QObject(parent)
{
    qsrand(QDateTime::currentMSecsSinceEpoch());
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
    m_topLabel = "roll the dice";
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
    setChance(0);
    setTotal(0);
    setTopLabel("roll the dice (1/3)");
    m_turnCount = 1;
    setGameState(0);
    emit newGameTriggered();
}

void Engine::rollDice(int diceNo)
{
    switch(diceNo) {
    case 1:
        setDice1(qrand() % 6 + 1);
        break;
    case 2:
        setDice2(qrand() % 6 + 1);
        break;
    case 3:
        setDice3(qrand() % 6 + 1);
        break;
    case 4:
        setDice4(qrand() % 6 + 1);
        break;
    case 5:
        setDice5(qrand() % 6 + 1);
        break;
    default:
        break;
    }
}

void Engine::skipRoll()
{
    emit resetSelections();
    setTopLabel("select hand");
    setGameState(3);
}

void Engine::forward()
{
    if(m_gameState == 0) {
        setTopLabel("select dices to keep and roll (2/3)");
        setGameState(1);
    }
    else if(m_gameState == 1) {
        setTopLabel("select dices to keep and roll (3/3)");
        setGameState(2);
    }
    else if(m_gameState == 2) {
        emit resetSelections();
        setTopLabel("select hand");
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
    m_turnCount++;
    QList<int> list;
    list << 0 << 0 << 0 << 0 << 0 << 0 << 0;
    list[m_dice1]++;
    list[m_dice2]++;
    list[m_dice3]++;
    list[m_dice4]++;
    list[m_dice5]++;

    if(hand == "ones") {
        setOnes(countSameFaces(1));
        setUpbonus(0);
    }
    else if(hand == "twos") {
        setTwos(countSameFaces(2));
        setUpbonus(0);
    }
    else if(hand == "threes") {
        setThrees(countSameFaces(3));
        setUpbonus(0);
    }
    else if(hand == "fours") {
        setFours(countSameFaces(4));
        setUpbonus(0);
    }
    else if(hand == "fives") {
        setFives(countSameFaces(5));
        setUpbonus(0);
    }
    else if(hand == "sixes") {
        setSixes(countSameFaces(6));
        setUpbonus(0);
    }
    else if(hand == "chance") {
        int tmp = m_dice1 + m_dice2 + m_dice3 + m_dice4 + m_dice5;
        setChance(tmp);
    }
    else if(hand == "yatzy") {
        int tmp = 0;
        for(int i = 6; i > 0; i--) {
            if(list.at(i) == 5) {
                tmp = 50;
                break;
            }
        }
        setYatzy(tmp);
    }
    else if(hand == "pair") {
        int tmp = 0;
        for(int i = 6; i > 0; i--) {
            if(list.at(i) >= 2) {
                tmp = i * 2;
                break;
            }
        }
        setPair(tmp);
    }
    else if(hand == "twoPairs") {
        int pair1 = 0;
        int pair2 = 0;

        for(int i = 6; i > 0; i--) {
            if(list.at(i) >= 2) {
                if(pair1 == 0) {
                    pair1 = i;
                }
                else {
                    pair2 = i;
                    break;
                }
            }
        }

        if(pair1 > 0 && pair2 > 0) {
            setTwoPairs(2 * pair1 + 2 * pair2);
        }
        else {
            setTwoPairs(0);
        }
    }
    else if(hand == "threeKind") {
        int tmp = 0;
        for(int i = 6; i > 0; i--) {
            if(list.at(i) >= 3) {
                tmp = i * 3;
                break;
            }
        }
        setThreeKind(tmp);
    }
    else if(hand == "fourKind") {
        int tmp = 0;
        for(int i = 6; i > 0; i--) {
            if(list.at(i) >= 4) {
                tmp = i * 4;
                break;
            }
        }
        setFourKind(tmp);
    }
    else if(hand == "fullHouse") {
        int three = 0;
        int two = 0;

        for(int i = 6; i > 0; i--) {
            if(list.at(i) == 3) {
                if(three == 0) three = i;
            }
            if(list.at(i) == 2) {
                if(two == 0) two = i;
            }
            if(two > 0 && three > 0) break;
        }

        if(two > 0 && three > 0) {
            setFullHouse(two * 2 + three * 3);
        }
        else {
            setFullHouse(0);
        }
    }
    else if(hand == "smallStraight") {
        bool isIt = true;
        for(int i = 5; i > 0; i--) {
            if(list.at(i) != 1) {
                isIt = false;
                break;
            }
        }
        if(isIt) {
            setSmallStraight(15);
        }
        else {
            setSmallStraight(0);
        }
    }
    else if(hand == "bigStraight") {
        bool isIt = true;
        for(int i = 2; i < 7; i++) {
            if(list.at(i) != 1) {
                isIt = false;
                break;
            }
        }
        if(isIt) {
            setBigStraight(20);
        }
        else {
            setBigStraight(0);
        }
    }

    setTotal(0);

    if(m_turnCount == 16) {
        //game ended
        setTopLabel("game over");
        setGameState(4);
        checkHighScores();
    }
    else {
        setGameState(0);
        setTopLabel("roll the dice");
    }
}

int Engine::countSameFaces(const int face)
{
    int tmp = 0;
    if(m_dice1 == face) tmp += m_dice1;
    if(m_dice2 == face) tmp += m_dice2;
    if(m_dice3 == face) tmp += m_dice3;
    if(m_dice4 == face) tmp += m_dice4;
    if(m_dice5 == face) tmp += m_dice5;
    return tmp;
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

    int tmp = m_ones + m_twos + m_threes + m_fours + m_fives + m_sixes;
    if(tmp >= 63) {
        m_upBonus = 50;
        emit upbonusChanged(m_upBonus);
    }
    else {
        m_upBonus = 0;
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
        emit displayMessage("New high score");
    }
    else if(m_total > two) {
        highScoreToSettings(2, m_total);
        highScoreToSettings(3, two);
        setHighScores("");
        emit displayMessage("New 2nd best score");
    }
    else if(m_total > three) {
        highScoreToSettings(3, m_total);
        setHighScores("");
        emit displayMessage("New 3rd best score");
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
