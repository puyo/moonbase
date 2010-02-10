#ifndef PROJECTILE_H
#define PROJECTILE_H 1

#include "v3d.h"
#include "player.h"
#include "building.h"
#include <string>

class Game; // forward declaration

class Projectile {
    public: // types

        typedef unsigned int ID;

    public: // constructors

        Projectile(Game& game, ID id, Player::ID owner): 
            _game(game), 
            _energy_cost(1) { }

    public:

    private: // data

        Game& _game;
        ID _id;
        Player::ID _owner;
        Building::ID _source;
        unsigned int _energy_cost;
        V3D _pos;
        V3D _vel;
};

#endif
