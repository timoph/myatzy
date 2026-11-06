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

#ifndef SCORING_H
#define SCORING_H

#include <QList>
#include <QString>

// Pure Yatzy (Scandinavian rules) scoring functions, independent of the UI.
namespace Scoring {

enum class Category {
    Ones, Twos, Threes, Fours, Fives, Sixes,
    Pair, TwoPairs, ThreeKind, FourKind,
    SmallStraight, BigStraight, FullHouse,
    Chance, Yatzy,
    Invalid
};

constexpr int UpperBonusThreshold = 63;
constexpr int UpperBonus = 50;

// Maps the hand names used in the QML score card to categories.
Category categoryFromName(const QString &name);

// Score of the given dice (five values 1..6) in the given category.
int score(Category category, const QList<int> &dice);

// Bonus for the upper section given its sum.
int upperBonus(int upperSum);

} // namespace Scoring

#endif // SCORING_H
