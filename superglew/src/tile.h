#ifndef TILE_H
#define TILE_H 1

#include <cstdlib>
#include "building.h"

class Map;

class Tile {
    public:
        typedef enum { WATER, LOW, HIGH } Type;
        static const unsigned ntypes = 3;
    public:
        Tile(Map& map);
    public:
        Type type() const { return _type; }
        void set_type(Type value) { _type = value; }
    private:
        Map& _map;
        Type _type;
        bool _resources; //! whether this tile has energy resources
        Building::ID _building_id; //! which building is on this tile
};

#endif
