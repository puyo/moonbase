#ifndef BUILDING_H
#define BUILDING_H 1

#include "v3d.h"
#include <string>

class Game; // forward delcaration

class Building {

    public: // types

        typedef unsigned int ID;

    public: // constructors

        Building(Game& game, ID id): _game(&game), _id(id) {
        }

    public:

    private: // data

        Game *_game;
        ID _id;
        unsigned int _player;
        unsigned int _hp_total;
        unsigned int _hp_remaining;
        V3D _pos;
};

#endif
