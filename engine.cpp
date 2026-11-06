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
#include "scoremodel.h"

#include <QRandomGenerator>
#include <QSettings>

#include <algorithm>

using Scoring::Category;

Engine::Engine(QObject *parent) :
    QObject(parent),
    m_dice{1, 2, 3, 4, 5},
    m_held{},
    m_scores{},
    m_upperSection(new ScoreModel(this, Category::Ones, Scoring::UpperCategoryCount, this)),
    m_lowerSection(new ScoreModel(this, Category::Pair,
                                  Scoring::CategoryCount - Scoring::UpperCategoryCount, this))
{
    loadHighScores();
}

void Engine::newGame()
{
    m_scores.fill(std::nullopt);
    m_rollCount = 0;
    clearHolds();

    emit diceChanged();
    emit scoresChanged();
    emit turnChanged();

    if(m_highScoreRank != -1) {
        m_highScoreRank = -1;
        emit highScoresChanged();
    }
}

void Engine::roll()
{
    if(!canRoll())
        return;

    QList<bool> rerolled;
    for(int i = 0; i < DiceCount; i++) {
        rerolled << !m_held[i];
        if(!m_held[i])
            m_dice[i] = QRandomGenerator::global()->bounded(1, 7);
    }
    m_rollCount++;

    // holding dice after the last roll has no meaning
    if(m_rollCount == MaxRolls)
        clearHolds();

    emit diceChanged();
    emit turnChanged();
    emit rolled(rerolled);
}

void Engine::toggleHold(int index)
{
    if(!canHold() || index < 0 || index >= DiceCount)
        return;

    m_held[index] = !m_held[index];
    emit diceChanged();
    emit turnChanged(); // canRoll depends on the holds
}

bool Engine::canScoreCategory(int category) const
{
    return category >= 0 && category < Scoring::CategoryCount && canScore()
        && !isPlayed(static_cast<Category>(category));
}

bool Engine::scoreCategory(int category)
{
    if(!canScoreCategory(category))
        return false;

    const Category cat = static_cast<Category>(category);

    m_scores[category] = potentialScore(cat);
    m_rollCount = 0;
    clearHolds();

    emit diceChanged();
    emit scoresChanged();
    emit turnChanged();

    if(gameOver())
        updateHighScores();

    return true;
}

QList<int> Engine::dice() const
{
    return QList<int>(m_dice.begin(), m_dice.end());
}

QList<bool> Engine::held() const
{
    return QList<bool>(m_held.begin(), m_held.end());
}

bool Engine::canRoll() const
{
    if(gameOver() || m_rollCount >= MaxRolls)
        return false;

    // rerolling with every die held would just waste a roll
    const bool allHeld = std::all_of(m_held.begin(), m_held.end(), [](bool h) { return h; });
    return !allHeld;
}

bool Engine::gameInProgress() const
{
    if(gameOver())
        return false;
    return m_rollCount > 0 || std::any_of(m_scores.begin(), m_scores.end(),
                                          [](const std::optional<int> &s) { return s.has_value(); });
}

bool Engine::canHold() const
{
    return !gameOver() && m_rollCount > 0 && m_rollCount < MaxRolls;
}

bool Engine::canScore() const
{
    return !gameOver() && m_rollCount > 0;
}

bool Engine::gameOver() const
{
    return std::all_of(m_scores.begin(), m_scores.end(),
                       [](const std::optional<int> &s) { return s.has_value(); });
}

QString Engine::statusText() const
{
    if(gameOver())
        return tr("Game over");
    if(m_rollCount == 0)
        return tr("Roll the dice (1/%1)").arg(MaxRolls);
    if(m_rollCount < MaxRolls)
        return tr("Select dice to keep and roll (%1/%2) or select hand")
                .arg(m_rollCount + 1).arg(MaxRolls);
    return tr("Select hand");
}

int Engine::upperSum() const
{
    int sum = 0;
    for(int i = 0; i < Scoring::UpperCategoryCount; i++)
        sum += m_scores[i].value_or(0);
    return sum;
}

int Engine::upperBonus() const
{
    return Scoring::upperBonus(upperSum());
}

int Engine::total() const
{
    int sum = upperBonus();
    for(const auto &s : m_scores)
        sum += s.value_or(0);
    return sum;
}

QAbstractItemModel *Engine::upperSection() const
{
    return m_upperSection;
}

QAbstractItemModel *Engine::lowerSection() const
{
    return m_lowerSection;
}

bool Engine::isPlayed(Category category) const
{
    const int i = static_cast<int>(category);
    return i >= 0 && i < Scoring::CategoryCount && m_scores[i].has_value();
}

int Engine::scoreOf(Category category) const
{
    const int i = static_cast<int>(category);
    if(i < 0 || i >= Scoring::CategoryCount)
        return 0;
    return m_scores[i].value_or(0);
}

int Engine::potentialScore(Category category) const
{
    return Scoring::score(category, dice());
}

void Engine::setDice(const QList<int> &values)
{
    for(int i = 0; i < DiceCount && i < values.size(); i++)
        m_dice[i] = values.at(i);
    emit diceChanged();
}

void Engine::clearHolds()
{
    m_held.fill(false);
}

void Engine::loadHighScores()
{
    QSettings settings;
    m_highScores.clear();
    for(int place = 1; place <= HighScoreCount; place++)
        m_highScores << settings.value(QString("high/%1").arg(place), 0).toInt();
}

void Engine::updateHighScores()
{
    const int score = total();

    // ties do not push an older score down the list
    int place = 0;
    while(place < m_highScores.size() && score <= m_highScores.at(place))
        place++;
    if(place >= HighScoreCount) {
        if(m_highScoreRank != -1) {
            m_highScoreRank = -1;
            emit highScoresChanged();
        }
        return;
    }

    m_highScores.insert(place, score);
    while(m_highScores.size() > HighScoreCount)
        m_highScores.removeLast();

    QSettings settings;
    for(int i = 0; i < HighScoreCount; i++)
        settings.setValue(QString("high/%1").arg(i + 1), m_highScores.at(i));

    m_highScoreRank = place;
    emit highScoresChanged();
}
