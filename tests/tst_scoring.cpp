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

#include "scoring.h"
#include "engine.h"

using Scoring::Category;

Q_DECLARE_METATYPE(Category)

class TestScoring : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();

    void score_data();
    void score();
    void categoryFromName();
    void upperBonus();
    void invalidDice();

    void engineBonusRowDoesNotConsumeTurn();
    void engineGameEndsAfterFifteenHands();
    void engineNewGameResetsScores();

private:
    static void setDice(Engine &engine, const QList<int> &dice);
    static const QStringList allHands;
};

const QStringList TestScoring::allHands = {
    "Ones", "Twos", "Threes", "Fours", "Fives", "Sixes",
    "Pair", "Two pairs", "Three of kind", "Four of kind",
    "Small straight", "Big straight", "Full house", "Chance", "Yatzy"
};

void TestScoring::initTestCase()
{
    // keep high scores of the test run away from the real settings
    QStandardPaths::setTestModeEnabled(true);
    QCoreApplication::setOrganizationName("myatzy-tests");
    QCoreApplication::setApplicationName("tst_scoring");
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

void TestScoring::categoryFromName()
{
    for (int i = 0; i < allHands.size(); i++)
        QCOMPARE(Scoring::categoryFromName(allHands.at(i)), static_cast<Category>(i));

    QCOMPARE(Scoring::categoryFromName("Bonus"), Category::Invalid);
    QCOMPARE(Scoring::categoryFromName(""), Category::Invalid);
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

void TestScoring::setDice(Engine &engine, const QList<int> &dice)
{
    engine.setDice1(dice.at(0));
    engine.setDice2(dice.at(1));
    engine.setDice3(dice.at(2));
    engine.setDice4(dice.at(3));
    engine.setDice5(dice.at(4));
}

void TestScoring::engineBonusRowDoesNotConsumeTurn()
{
    Engine engine;
    engine.newGame();
    setDice(engine, {6, 6, 6, 6, 6});

    // The Bonus row used to become clickable after a new game and
    // ended the game one hand too early. It must be ignored.
    engine.handleScoreButtonClick("Bonus");
    QCOMPARE(engine.total(), 0);

    for (int i = 0; i < allHands.size() - 1; i++) {
        engine.handleScoreButtonClick(allHands.at(i));
        QVERIFY2(engine.gameState() != 4, qPrintable(QString("game ended after %1 hands").arg(i + 1)));
    }
    engine.handleScoreButtonClick(allHands.last());
    QCOMPARE(engine.gameState(), 4);
}

void TestScoring::engineGameEndsAfterFifteenHands()
{
    Engine engine;
    engine.newGame();
    QSignalSpy messages(&engine, &Engine::displayMessage);

    // all sixes: sixes 30, upper sum 30 -> no bonus
    setDice(engine, {6, 6, 6, 6, 6});
    for (const QString &hand : allHands)
        engine.handleScoreButtonClick(hand);

    QCOMPARE(engine.gameState(), 4);
    // 30 sixes + 12 pair + 18 three + 24 four + 30 chance + 50 yatzy
    QCOMPARE(engine.total(), 30 + 12 + 18 + 24 + 30 + 50);
    QCOMPARE(engine.upbonus(), 0);
    QCOMPARE(messages.count(), 1);
    QCOMPARE(engine.highScoreFromSettings(1), engine.total());
}

void TestScoring::engineNewGameResetsScores()
{
    Engine engine;
    engine.newGame();

    // upper section worth 3 of each: 3+6+9+12+15+18 = 63 -> bonus
    for (int face = 1; face <= 6; face++) {
        setDice(engine, {face, face, face, 1 + face % 6, 1 + (face + 1) % 6});
        engine.handleScoreButtonClick(allHands.at(face - 1));
    }
    QCOMPARE(engine.upbonus(), 50);
    QCOMPARE(engine.total(), 63 + 50);

    engine.newGame();
    QCOMPARE(engine.total(), 0);
    QCOMPARE(engine.upbonus(), 0);
    QCOMPARE(engine.sixes(), 0);
    QCOMPARE(engine.gameState(), 0);
}

QTEST_GUILESS_MAIN(TestScoring)

#include "tst_scoring.moc"
