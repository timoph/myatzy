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

#include <QAbstractItemModel>
#include <QList>
#include <QObject>
#include <QString>
#include <QtQml/qqmlregistration.h>

#include <array>
#include <optional>

#include "scoring.h"

class ScoreModel;

// Game state of a single player Yatzy game.
//
// A turn consists of 1..MaxRolls rolls. Dice can be held between rolls and a
// hand can be scored after any roll. The game is over when every category
// has been scored.
class Engine : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(QList<int> dice READ dice NOTIFY diceChanged)
    Q_PROPERTY(QList<bool> held READ held NOTIFY diceChanged)
    Q_PROPERTY(int rollCount READ rollCount NOTIFY turnChanged)
    Q_PROPERTY(int maxRolls READ maxRolls CONSTANT)
    Q_PROPERTY(bool canRoll READ canRoll NOTIFY turnChanged)
    Q_PROPERTY(bool canHold READ canHold NOTIFY turnChanged)
    Q_PROPERTY(bool canScore READ canScore NOTIFY turnChanged)
    Q_PROPERTY(bool gameOver READ gameOver NOTIFY turnChanged)
    Q_PROPERTY(QString statusText READ statusText NOTIFY turnChanged)
    Q_PROPERTY(int upperSum READ upperSum NOTIFY scoresChanged)
    Q_PROPERTY(int upperBonus READ upperBonus NOTIFY scoresChanged)
    Q_PROPERTY(int total READ total NOTIFY scoresChanged)
    Q_PROPERTY(QList<int> highScores READ highScores NOTIFY highScoresChanged)
    Q_PROPERTY(QAbstractItemModel *upperSection READ upperSection CONSTANT)
    Q_PROPERTY(QAbstractItemModel *lowerSection READ lowerSection CONSTANT)

public:
    static constexpr int DiceCount = 5;
    static constexpr int MaxRolls = 3;
    static constexpr int HighScoreCount = 3;

    explicit Engine(QObject *parent = nullptr);

    Q_INVOKABLE void newGame();
    Q_INVOKABLE void roll();
    Q_INVOKABLE void toggleHold(int index);
    // Scores the current dice in the given Scoring::Category.
    // Returns false if that is not allowed right now.
    Q_INVOKABLE bool scoreCategory(int category);

    QList<int> dice() const;
    QList<bool> held() const;
    int rollCount() const { return m_rollCount; }
    int maxRolls() const { return MaxRolls; }
    bool canRoll() const;
    bool canHold() const;
    bool canScore() const;
    bool gameOver() const;
    QString statusText() const;
    int upperSum() const;
    int upperBonus() const;
    int total() const;
    QList<int> highScores() const { return m_highScores; }
    QAbstractItemModel *upperSection() const;
    QAbstractItemModel *lowerSection() const;

    bool isPlayed(Scoring::Category category) const;
    // Recorded score, 0 if not played yet.
    int scoreOf(Scoring::Category category) const;
    // What the current dice would give in the category.
    int potentialScore(Scoring::Category category) const;

    // Sets the dice values directly, for tests.
    void setDice(const QList<int> &values);

signals:
    void diceChanged();
    void turnChanged();
    void scoresChanged();
    void highScoresChanged();
    void displayMessage(const QString &msg);

private:
    void clearHolds();
    void loadHighScores();
    void updateHighScores();

    std::array<int, DiceCount> m_dice;
    std::array<bool, DiceCount> m_held;
    std::array<std::optional<int>, Scoring::CategoryCount> m_scores;
    int m_rollCount = 0;
    QList<int> m_highScores;
    ScoreModel *m_upperSection;
    ScoreModel *m_lowerSection;
};

#endif // ENGINE_H
