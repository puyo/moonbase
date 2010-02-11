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
    public:
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
    private:
        typedef std::vector<Player *> PlayerArray;
        typedef std::vector<Building *> BuildingArray;
        typedef std::vector<Projectile *> ProjectileArray;
    private:
        Game(const Game& game) {} // uncopyable
    private:
        Map *_map; // may be unloaded
        PlayerArray _players;
        BuildingArray _buildings;
        ProjectileArray _projectiles;
};

#endif
