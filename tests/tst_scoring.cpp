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

#include <QtTest>
#include <QSignalSpy>
#include <QAbstractItemModelTester>

#include "scoring.h"
#include "engine.h"
#include "scoremodel.h"

using Scoring::Category;

Q_DECLARE_METATYPE(Category)

class TestScoring : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void init();

    // Scoring
    void score_data();
    void score();
    void displayName();
    void upperBonus();
    void invalidDice();

    // Engine
    void initialState();
    void rollsPerTurn();
    void holdKeepsDice();
    void holdNotAllowedBeforeFirstRoll();
    void allHeldCannotRoll();
    void rolledSignal();
    void scoreAfterFirstRoll();
    void gameInProgress();
    void cannotScoreTwiceOrBeforeRolling();
    void cannotScoreInvalidCategory();
    void upperBonusAndTotal();
    void fullGame();
    void newGameResets();
    void highScoreOrder();

    // ScoreModel
    void scoreModel();

private:
    static void playAll(Engine &engine, const QList<int> &dice);
};

void TestScoring::initTestCase()
{
    // keep high scores of the test run away from the real settings
    QStandardPaths::setTestModeEnabled(true);
    QCoreApplication::setOrganizationName("myatzy-tests");
    QCoreApplication::setApplicationName("tst_scoring");
}

void TestScoring::init()
{
    QSettings().clear();
}

void TestScoring::score_data()
{
    QTest::addColumn<Category>("category");
    QTest::addColumn<QList<int>>("dice");
    QTest::addColumn<int>("expected");

    // upper section
    QTest::newRow("ones")          << Category::Ones   << QList<int>{1, 1, 2, 3, 1} << 3;
    QTest::newRow("ones none")     << Category::Ones   << QList<int>{2, 3, 4, 5, 6} << 0;
    QTest::newRow("twos")          << Category::Twos   << QList<int>{2, 2, 2, 2, 5} << 8;
    QTest::newRow("threes")        << Category::Threes << QList<int>{3, 1, 3, 6, 6} << 6;
    QTest::newRow("fours")         << Category::Fours  << QList<int>{4, 4, 4, 4, 4} << 20;
    QTest::newRow("fives")         << Category::Fives  << QList<int>{5, 1, 2, 3, 4} << 5;
    QTest::newRow("sixes")         << Category::Sixes  << QList<int>{6, 6, 6, 1, 1} << 18;

    // pair: highest pair counts
    QTest::newRow("pair")          << Category::Pair << QList<int>{3, 3, 1, 2, 4} << 6;
    QTest::newRow("pair highest")  << Category::Pair << QList<int>{3, 3, 5, 5, 1} << 10;
    QTest::newRow("pair from 3")   << Category::Pair << QList<int>{6, 6, 6, 1, 2} << 12;
    QTest::newRow("pair none")     << Category::Pair << QList<int>{1, 2, 3, 4, 6} << 0;

    // two pairs: must be two different faces
    QTest::newRow("two pairs")         << Category::TwoPairs << QList<int>{2, 2, 5, 5, 1} << 14;
    QTest::newRow("two pairs + three") << Category::TwoPairs << QList<int>{2, 2, 5, 5, 5} << 14;
    QTest::newRow("two pairs four")    << Category::TwoPairs << QList<int>{4, 4, 4, 4, 1} << 0;
    QTest::newRow("two pairs yatzy")   << Category::TwoPairs << QList<int>{4, 4, 4, 4, 4} << 0;
    QTest::newRow("two pairs one")     << Category::TwoPairs << QList<int>{4, 4, 1, 2, 3} << 0;

    QTest::newRow("three of kind")      << Category::ThreeKind << QList<int>{4, 4, 4, 1, 2} << 12;
    QTest::newRow("three from yatzy")   << Category::ThreeKind << QList<int>{6, 6, 6, 6, 6} << 18;
    QTest::newRow("three none")         << Category::ThreeKind << QList<int>{4, 4, 1, 1, 2} << 0;

    QTest::newRow("four of kind")       << Category::FourKind << QList<int>{2, 2, 2, 2, 6} << 8;
    QTest::newRow("four from yatzy")    << Category::FourKind << QList<int>{5, 5, 5, 5, 5} << 20;
    QTest::newRow("four none")          << Category::FourKind << QList<int>{2, 2, 2, 6, 6} << 0;

    // straights: order of dice does not matter
    QTest::newRow("small straight")     << Category::SmallStraight << QList<int>{5, 3, 1, 4, 2} << 15;
    QTest::newRow("small not big")      << Category::SmallStraight << QList<int>{2, 3, 4, 5, 6} << 0;
    QTest::newRow("small with dup")     << Category::SmallStraight << QList<int>{1, 2, 3, 4, 4} << 0;
    QTest::newRow("big straight")       << Category::BigStraight << QList<int>{6, 2, 5, 3, 4} << 20;
    QTest::newRow("big not small")      << Category::BigStraight << QList<int>{1, 2, 3, 4, 5} << 0;

    // full house: exactly 3 + 2 of different faces
    QTest::newRow("full house")         << Category::FullHouse << QList<int>{2, 2, 6, 6, 6} << 22;
    QTest::newRow("full house low 3")   << Category::FullHouse << QList<int>{1, 1, 1, 6, 6} << 15;
    QTest::newRow("full house yatzy")   << Category::FullHouse << QList<int>{3, 3, 3, 3, 3} << 0;
    QTest::newRow("full house four")    << Category::FullHouse << QList<int>{3, 3, 3, 3, 2} << 0;
    QTest::newRow("full house no pair") << Category::FullHouse << QList<int>{3, 3, 3, 1, 2} << 0;

    QTest::newRow("chance")             << Category::Chance << QList<int>{1, 2, 3, 4, 6} << 16;
    QTest::newRow("chance max")         << Category::Chance << QList<int>{6, 6, 6, 6, 6} << 30;

    QTest::newRow("yatzy")              << Category::Yatzy << QList<int>{1, 1, 1, 1, 1} << 50;
    QTest::newRow("yatzy none")         << Category::Yatzy << QList<int>{6, 6, 6, 6, 5} << 0;

    QTest::newRow("invalid category")   << Category::Invalid << QList<int>{6, 6, 6, 6, 6} << 0;
}

void TestScoring::score()
{
    QFETCH(Category, category);
    QFETCH(QList<int>, dice);
    QFETCH(int, expected);

    QCOMPARE(Scoring::score(category, dice), expected);
}

void TestScoring::upperBonus()
{
    QCOMPARE(Scoring::upperBonus(0), 0);
    QCOMPARE(Scoring::upperBonus(62), 0);
    QCOMPARE(Scoring::upperBonus(63), 50);
    QCOMPARE(Scoring::upperBonus(105), 50);
}

void TestScoring::invalidDice()
{
    QCOMPARE(Scoring::score(Category::Chance, {1, 2, 3}), 0);
    QCOMPARE(Scoring::score(Category::Chance, {}), 0);
}

void TestScoring::displayName()
{
    QCOMPARE(Scoring::displayName(Category::Ones), QString("Ones"));
    QCOMPARE(Scoring::displayName(Category::TwoPairs), QString("Two pairs"));
    QCOMPARE(Scoring::displayName(Category::Yatzy), QString("Yatzy"));
    QVERIFY(Scoring::displayName(Category::Invalid).isEmpty());
    for (int i = 0; i < Scoring::CategoryCount; i++)
        QVERIFY(!Scoring::displayName(static_cast<Category>(i)).isEmpty());
}

// Scores every category in order with the given dice.
void TestScoring::playAll(Engine &engine, const QList<int> &dice)
{
    for (int c = 0; c < Scoring::CategoryCount; c++) {
        engine.roll();
        engine.setDice(dice);
        QVERIFY(engine.scoreCategory(c));
    }
}

void TestScoring::initialState()
{
    Engine engine;
    QCOMPARE(engine.dice().size(), Engine::DiceCount);
    QCOMPARE(engine.held(), QList<bool>(Engine::DiceCount, false));
    QCOMPARE(engine.rollCount(), 0);
    QVERIFY(engine.canRoll());
    QVERIFY(!engine.canHold());
    QVERIFY(!engine.canScore());
    QVERIFY(!engine.gameOver());
    QCOMPARE(engine.total(), 0);
    QCOMPARE(engine.highScores(), QList<int>({0, 0, 0}));
    QCOMPARE(engine.highScoreRank(), -1);
    QVERIFY(!engine.gameInProgress());
}

void TestScoring::rollsPerTurn()
{
    Engine engine;
    QSignalSpy diceSpy(&engine, &Engine::diceChanged);

    for (int i = 1; i <= Engine::MaxRolls; i++) {
        QVERIFY(engine.canRoll());
        engine.roll();
        QCOMPARE(engine.rollCount(), i);
        for (int d : engine.dice())
            QVERIFY(d >= 1 && d <= 6);
    }
    QCOMPARE(diceSpy.count(), Engine::MaxRolls);

    QVERIFY(!engine.canRoll());
    QVERIFY(!engine.canHold());
    QVERIFY(engine.canScore());
    engine.roll(); // ignored
    QCOMPARE(engine.rollCount(), Engine::MaxRolls);
}

void TestScoring::holdKeepsDice()
{
    Engine engine;
    engine.roll();
    engine.setDice({1, 2, 3, 4, 5});
    engine.toggleHold(0);
    engine.toggleHold(4);
    QCOMPARE(engine.held(), QList<bool>({true, false, false, false, true}));

    // held dice never change, however many times we roll
    for (int i = 0; i < 50; i++) {
        Engine e;
        e.roll();
        e.setDice({1, 2, 3, 4, 5});
        e.toggleHold(0);
        e.toggleHold(4);
        e.roll();
        QCOMPARE(e.dice().first(), 1);
        QCOMPARE(e.dice().last(), 5);
    }

    engine.toggleHold(0);
    QCOMPARE(engine.held().first(), false);

    // holds are cleared after the last roll and after scoring
    engine.roll();
    QCOMPARE(engine.held(), QList<bool>({false, false, false, false, true}));
    engine.roll();
    QCOMPARE(engine.held(), QList<bool>(Engine::DiceCount, false));
}

void TestScoring::holdNotAllowedBeforeFirstRoll()
{
    Engine engine;
    engine.toggleHold(0);
    QCOMPARE(engine.held().first(), false);

    engine.roll();
    engine.toggleHold(-1);
    engine.toggleHold(Engine::DiceCount);
    QCOMPARE(engine.held(), QList<bool>(Engine::DiceCount, false));
}

void TestScoring::allHeldCannotRoll()
{
    Engine engine;
    engine.roll();
    for (int i = 0; i < Engine::DiceCount; i++)
        engine.toggleHold(i);
    QVERIFY(!engine.canRoll());
    engine.roll();
    QCOMPARE(engine.rollCount(), 1);

    engine.toggleHold(2);
    QVERIFY(engine.canRoll());
}

void TestScoring::rolledSignal()
{
    Engine engine;
    QSignalSpy spy(&engine, &Engine::rolled);

    engine.roll();
    QCOMPARE(spy.count(), 1);
    QCOMPARE(spy.at(0).at(0).value<QList<bool>>(), QList<bool>(Engine::DiceCount, true));

    engine.toggleHold(1);
    engine.toggleHold(3);
    engine.roll();
    engine.roll(); // last roll clears the holds, the signal still tells what was thrown
    QCOMPARE(spy.count(), 3);
    const QList<bool> expected = {true, false, true, false, true};
    QCOMPARE(spy.at(1).at(0).value<QList<bool>>(), expected);
    QCOMPARE(spy.at(2).at(0).value<QList<bool>>(), expected);

    engine.roll(); // not allowed any more
    QCOMPARE(spy.count(), 3);
}

void TestScoring::scoreAfterFirstRoll()
{
    Engine engine;
    QSignalSpy scoresSpy(&engine, &Engine::scoresChanged);
    engine.roll();
    engine.setDice({6, 6, 6, 2, 2});
    engine.toggleHold(0);

    QCOMPARE(engine.potentialScore(Category::FullHouse), 22);
    QVERIFY(engine.scoreCategory(int(Category::FullHouse)));
    QCOMPARE(scoresSpy.count(), 1);
    QVERIFY(engine.isPlayed(Category::FullHouse));
    QCOMPARE(engine.scoreOf(Category::FullHouse), 22);
    QCOMPARE(engine.total(), 22);

    // a new turn begins
    QCOMPARE(engine.rollCount(), 0);
    QCOMPARE(engine.held(), QList<bool>(Engine::DiceCount, false));
    QVERIFY(!engine.canScore());
    QVERIFY(engine.canRoll());
}

void TestScoring::gameInProgress()
{
    Engine engine;
    QVERIFY(!engine.gameInProgress());
    engine.roll();
    QVERIFY(engine.gameInProgress());
    QVERIFY(engine.scoreCategory(int(Category::Chance)));
    QVERIFY(engine.gameInProgress()); // rollCount is 0 again, but a hand is played

    engine.newGame();
    QVERIFY(!engine.gameInProgress());

    playAll(engine, {2, 2, 2, 2, 2});
    QVERIFY(engine.gameOver());
    QVERIFY(!engine.gameInProgress());
}

void TestScoring::cannotScoreTwiceOrBeforeRolling()
{
    Engine engine;
    QVERIFY(!engine.scoreCategory(int(Category::Chance)));

    engine.roll();
    QVERIFY(engine.scoreCategory(int(Category::Chance)));
    engine.roll();
    QVERIFY(!engine.scoreCategory(int(Category::Chance)));
    QCOMPARE(engine.rollCount(), 1); // the turn goes on
}

void TestScoring::cannotScoreInvalidCategory()
{
    Engine engine;
    engine.roll();
    QVERIFY(!engine.scoreCategory(-1));
    QVERIFY(!engine.scoreCategory(Scoring::CategoryCount));
    QCOMPARE(engine.rollCount(), 1);
}

void TestScoring::upperBonusAndTotal()
{
    Engine engine;
    // three of each face: 3+6+9+12+15+18 = 63 -> bonus
    for (int face = 1; face <= 6; face++) {
        engine.roll();
        engine.setDice({face, face, face, 1 + face % 6, 1 + (face + 1) % 6});
        QVERIFY(engine.scoreCategory(face - 1));
        QCOMPARE(engine.upperBonus(), face == 6 ? 50 : 0);
    }
    QCOMPARE(engine.upperSum(), 63);
    QCOMPARE(engine.total(), 63 + 50);
}

void TestScoring::fullGame()
{
    Engine engine;
    QSignalSpy highScores(&engine, &Engine::highScoresChanged);

    playAll(engine, {6, 6, 6, 6, 6});

    QVERIFY(engine.gameOver());
    QVERIFY(!engine.canRoll());
    QVERIFY(!engine.canScore());
    QCOMPARE(engine.statusText(), QString("Game over"));
    // 30 sixes + 12 pair + 18 three + 24 four + 30 chance + 50 yatzy
    const int expected = 30 + 12 + 18 + 24 + 30 + 50;
    QCOMPARE(engine.total(), expected);
    QCOMPARE(engine.upperBonus(), 0);
    QCOMPARE(highScores.count(), 1);
    QCOMPARE(engine.highScores(), QList<int>({expected, 0, 0}));
    QCOMPARE(engine.highScoreRank(), 0);

    // persisted in the old settings format
    QCOMPARE(QSettings().value("high/1").toInt(), expected);
    QCOMPARE(Engine().highScores(), QList<int>({expected, 0, 0}));
}

void TestScoring::newGameResets()
{
    Engine engine;
    playAll(engine, {6, 6, 6, 6, 6});
    QVERIFY(engine.gameOver());

    QCOMPARE(engine.highScoreRank(), 0);
    engine.newGame();
    QVERIFY(!engine.gameOver());
    QCOMPARE(engine.highScoreRank(), -1);
    QCOMPARE(engine.total(), 0);
    QCOMPARE(engine.upperBonus(), 0);
    QCOMPARE(engine.rollCount(), 0);
    for (int c = 0; c < Scoring::CategoryCount; c++)
        QVERIFY(!engine.isPlayed(static_cast<Category>(c)));
    QVERIFY(engine.canRoll());
}

void TestScoring::highScoreOrder()
{
    Engine engine;
    QList<int> ranks;

    const auto game = [&](int face) {
        engine.newGame();
        playAll(engine, {face, face, face, face, face});
        ranks << engine.highScoreRank();
        return engine.total();
    };

    const int threes = game(3);
    const int sixes = game(6);
    const int ones = game(1);
    QCOMPARE(engine.highScores(), QList<int>({sixes, threes, ones}));

    // a tie with the 3rd best score does not enter the list
    game(1);
    QCOMPARE(engine.highScores(), QList<int>({sixes, threes, ones}));

    // between: fours beat threes and push ones out
    const int fours = game(4);
    QCOMPARE(engine.highScores(), QList<int>({sixes, fours, threes}));

    QCOMPARE(ranks, QList<int>({0, 0, 2, -1, 1}));
}

void TestScoring::scoreModel()
{
    Engine engine;
    QAbstractItemModel *upper = engine.upperSection();
    QAbstractItemModel *lower = engine.lowerSection();
    QAbstractItemModelTester upperTester(upper, QAbstractItemModelTester::FailureReportingMode::QtTest);
    QAbstractItemModelTester lowerTester(lower, QAbstractItemModelTester::FailureReportingMode::QtTest);

    QCOMPARE(upper->rowCount(), 6);
    QCOMPARE(lower->rowCount(), Scoring::CategoryCount - 6);

    const QModelIndex ones = upper->index(0, 0);
    const QModelIndex yatzy = lower->index(lower->rowCount() - 1, 0);
    QCOMPARE(ones.data(ScoreModel::NameRole).toString(), QString("Ones"));
    QCOMPARE(ones.data(ScoreModel::CategoryRole).toInt(), int(Category::Ones));
    QCOMPARE(lower->index(0, 0).data(ScoreModel::CategoryRole).toInt(), int(Category::Pair));
    QCOMPARE(yatzy.data(ScoreModel::CategoryRole).toInt(), int(Category::Yatzy));

    const QHash<int, QByteArray> roles = upper->roleNames();
    QCOMPARE(roles.value(ScoreModel::NameRole), QByteArray("name"));
    QCOMPARE(roles.value(ScoreModel::PotentialRole), QByteArray("potential"));

    QSignalSpy upperChanged(upper, &QAbstractItemModel::dataChanged);
    engine.roll();
    engine.setDice({1, 1, 1, 1, 1});
    QVERIFY(upperChanged.count() >= 1);

    QCOMPARE(ones.data(ScoreModel::PotentialRole).toInt(), 5);
    QCOMPARE(yatzy.data(ScoreModel::PotentialRole).toInt(), 50);
    QCOMPARE(ones.data(ScoreModel::PlayedRole).toBool(), false);

    QVERIFY(engine.scoreCategory(int(Category::Ones)));
    QCOMPARE(ones.data(ScoreModel::PlayedRole).toBool(), true);
    QCOMPARE(ones.data(ScoreModel::ScoreRole).toInt(), 5);
    QCOMPARE(yatzy.data(ScoreModel::ScoreRole).toInt(), 0);
}

QTEST_GUILESS_MAIN(TestScoring)

#include "tst_scoring.moc"
