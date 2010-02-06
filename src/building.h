#ifndef BUILDING_H
#define BUILDING_H 1

#include "v3d.h"
#include <string>

class Game; // forward delcaration

class Building {

    public: // types

        typedef unsigned int ID;

    public: // constructors

        Building(Game& game, ID id, std::string lua_filename): _game(&game), _id(id), _lua_filename(lua_filename) {
            // TODO: load and evaluate lua file
            //
            // Lua defines properties such as HP, HP total, a list of
            // projectiles it can fire, and callbacks like on_hit, on_destroyed
        }

    public:

    private: // data

        Game *_game;
        ID _id;
        std::string _lua_filename;
        unsigned int _player;
        unsigned int _hp_total;
        unsigned int _hp_remaining;
        V3D _pos;
};

#endif
