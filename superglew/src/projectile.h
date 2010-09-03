#ifndef PROJECTILE_H
#define PROJECTILE_H 1

#include "v3d.h"
#include "player.h"
#include "building.h"
#include <string>

class Game;

class Projectile {
    public:
        typedef unsigned int ID;
    public:
        Projectile(Game& game, ID id, Player::ID owner): 
            _game(game), 
            _id(id),
            _owner(owner),
            _energy_cost(1) { }
    private:
        Game& _game;
        ID _id;
        Player::ID _owner;
        Building::ID _source;
        unsigned int _energy_cost;
        V3D _pos;
        V3D _vel;
};

#endif
