#ifndef BUILDING_H
#define BUILDING_H 1

#include "v3d.h"
#include <string>

class Game;

class Building {
    public:
        typedef unsigned int ID;
    public:
        Building(Game& game, ID id): _game(&game), _id(id) { }
    private:
        Game *_game;
        ID _id;
        unsigned int _player;
        unsigned int _hp_total;
        unsigned int _hp_remaining;
        V3D _pos;
};

#endif
