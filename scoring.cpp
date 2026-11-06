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

#include "scoring.h"

#include <QCoreApplication>

#include <array>

namespace Scoring {

namespace {

// counts[face] = number of dice showing face (index 0 unused)
std::array<int, 7> faceCounts(const QList<int> &dice)
{
    std::array<int, 7> counts{};
    for (int d : dice) {
        if (d >= 1 && d <= 6)
            counts[d]++;
    }
    return counts;
}

// Highest face with at least n dice, scored as face * n; 0 if none.
int ofAKind(const std::array<int, 7> &counts, int n)
{
    for (int face = 6; face >= 1; face--) {
        if (counts[face] >= n)
            return face * n;
    }
    return 0;
}

bool isStraight(const std::array<int, 7> &counts, int first)
{
    for (int face = first; face < first + 5; face++) {
        if (counts[face] != 1)
            return false;
    }
    return true;
}

} // namespace

QString displayName(Category category)
{
    static const char *const names[CategoryCount] = {
        QT_TRANSLATE_NOOP("Scoring", "Ones"),
        QT_TRANSLATE_NOOP("Scoring", "Twos"),
        QT_TRANSLATE_NOOP("Scoring", "Threes"),
        QT_TRANSLATE_NOOP("Scoring", "Fours"),
        QT_TRANSLATE_NOOP("Scoring", "Fives"),
        QT_TRANSLATE_NOOP("Scoring", "Sixes"),
        QT_TRANSLATE_NOOP("Scoring", "Pair"),
        QT_TRANSLATE_NOOP("Scoring", "Two pairs"),
        QT_TRANSLATE_NOOP("Scoring", "Three of kind"),
        QT_TRANSLATE_NOOP("Scoring", "Four of kind"),
        QT_TRANSLATE_NOOP("Scoring", "Small straight"),
        QT_TRANSLATE_NOOP("Scoring", "Big straight"),
        QT_TRANSLATE_NOOP("Scoring", "Full house"),
        QT_TRANSLATE_NOOP("Scoring", "Chance"),
        QT_TRANSLATE_NOOP("Scoring", "Yatzy"),
    };
    const int i = static_cast<int>(category);
    if (i < 0 || i >= CategoryCount)
        return QString();
    return QCoreApplication::translate("Scoring", names[i]);
}

bool isUpperSection(Category category)
{
    return static_cast<int>(category) >= 0
        && static_cast<int>(category) < UpperCategoryCount;
}

int score(Category category, const QList<int> &dice)
{
    if (dice.size() != 5)
        return 0;

    const auto counts = faceCounts(dice);

    switch (category) {
    case Category::Ones:
    case Category::Twos:
    case Category::Threes:
    case Category::Fours:
    case Category::Fives:
    case Category::Sixes: {
        const int face = static_cast<int>(category) - static_cast<int>(Category::Ones) + 1;
        return counts[face] * face;
    }
    case Category::Pair:
        return ofAKind(counts, 2);
    case Category::TwoPairs: {
        // Two different pairs; four of a kind does not count.
        int total = 0;
        int pairs = 0;
        for (int face = 6; face >= 1 && pairs < 2; face--) {
            if (counts[face] >= 2) {
                total += face * 2;
                pairs++;
            }
        }
        return pairs == 2 ? total : 0;
    }
    case Category::ThreeKind:
        return ofAKind(counts, 3);
    case Category::FourKind:
        return ofAKind(counts, 4);
    case Category::SmallStraight:
        return isStraight(counts, 1) ? 15 : 0;
    case Category::BigStraight:
        return isStraight(counts, 2) ? 20 : 0;
    case Category::FullHouse: {
        // Exactly three of one face and two of another; yatzy does not count.
        int three = 0;
        int two = 0;
        for (int face = 1; face <= 6; face++) {
            if (counts[face] == 3)
                three = face;
            else if (counts[face] == 2)
                two = face;
        }
        return (three && two) ? three * 3 + two * 2 : 0;
    }
    case Category::Chance: {
        int sum = 0;
        for (int d : dice)
            sum += d;
        return sum;
    }
    case Category::Yatzy:
        return ofAKind(counts, 5) ? 50 : 0;
    case Category::Invalid:
        break;
    }
    return 0;
}

int upperBonus(int upperSum)
{
    return upperSum >= UpperBonusThreshold ? UpperBonus : 0;
}

} // namespace Scoring
