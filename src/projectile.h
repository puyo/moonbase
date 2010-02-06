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

        Projectile(Game& game, ID id, Player::ID owner, std::string lua_filename): _game(&game), _lua_filename(lua_filename), _energy_cost(1) {
            // TODO: load and evaluate lua file
            //
            // Lua defines properties such as cost, on_hit (damage?), on_miss
            // (create a building?)
        }

    public:

    private: // data

        Game *_game;
        ID _id;
        std::string _lua_filename;
        Player::ID _owner;
        Building::ID _source;
        unsigned int _energy_cost;
        V3D _pos;
        V3D _vel;
};

#endif
