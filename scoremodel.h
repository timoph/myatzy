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

#ifndef SCOREMODEL_H
#define SCOREMODEL_H

#include <QAbstractListModel>

#include "scoring.h"

class Engine;

// Read-only list model of a consecutive range of score card categories,
// e.g. the upper or lower section. The data lives in the Engine.
class ScoreModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        CategoryRole = Qt::UserRole + 1, // Scoring::Category as int
        NameRole,                        // translated display name
        ScoreRole,                       // recorded score, 0 if not played
        PlayedRole,                      // has the category been scored
        PotentialRole                    // score the current dice would give
    };

    ScoreModel(const Engine *engine, Scoring::Category first, int count, QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    void refresh();

    const Engine *m_engine;
    int m_first;
    int m_count;
};

#endif // SCOREMODEL_H
