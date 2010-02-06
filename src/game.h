#ifndef GAME_H
#define GAME_H 1

#include "player.h"
#include "map.h"
#include "projectile.h"
#include "building.h"
#include "util.h"
#include <string>
#include <list>
#include <vector>
#include <algorithm>

class Game {

    private: // types
        typedef std::vector<Player *> PlayerArray;
        typedef std::vector<Building *> BuildingArray;
        typedef std::vector<Projectile *> ProjectileArray;

    public: // constructors

        Game(); 
        virtual ~Game();

    public:

        void think(unsigned int);
        void create_player(); // TODO: params
        void create_building(std::string type); // TODO: position, owner
        void create_projectile(std::string type); // TODO: position, angle, power, owner, source building
        void load_map(std::string name);
        void generate_map();

        Map *map();
        Building *building(Building::ID id);
        Projectile *projectile(Projectile::ID id);

//    private: // uncopyable

//        Game(const Game& game) {}

//    private: // data

        // Composition
        //
        // Game is responsible for creating and destroying this memory. Try to
        // make it the only thing in the program that has this responsibility.

        Map *_map; // pointer because it may be unloaded
        PlayerArray _players;
        BuildingArray _buildings;
        ProjectileArray _projectiles;
};

#endif
