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

#include "scoremodel.h"
#include "engine.h"

using Scoring::Category;

ScoreModel::ScoreModel(const Engine *engine, Category first, int count, QObject *parent) :
    QAbstractListModel(parent),
    m_engine(engine),
    m_first(static_cast<int>(first)),
    m_count(count)
{
    // potential scores follow the dice, played state and scores the score card
    connect(engine, &Engine::diceChanged, this, &ScoreModel::refresh);
    connect(engine, &Engine::scoresChanged, this, &ScoreModel::refresh);
}

int ScoreModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_count;
}

QVariant ScoreModel::data(const QModelIndex &index, int role) const
{
    if(!checkIndex(index, CheckIndexOption::IndexIsValid | CheckIndexOption::ParentIsInvalid))
        return QVariant();

    const Category category = static_cast<Category>(m_first + index.row());

    switch(role) {
    case Qt::DisplayRole:
    case NameRole:
        return Scoring::displayName(category);
    case CategoryRole:
        return static_cast<int>(category);
    case ScoreRole:
        return m_engine->scoreOf(category);
    case PlayedRole:
        return m_engine->isPlayed(category);
    case PotentialRole:
        return m_engine->potentialScore(category);
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ScoreModel::roleNames() const
{
    return {
        {CategoryRole, "category"},
        {NameRole, "name"},
        {ScoreRole, "score"},
        {PlayedRole, "played"},
        {PotentialRole, "potential"},
    };
}

void ScoreModel::refresh()
{
    if(m_count > 0)
        emit dataChanged(index(0), index(m_count - 1));
}
