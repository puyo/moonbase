#include "tile.h"
#include "util.h"

Tile::Tile(Map& map): _map(map), _type(WATER), _resources(false), _building_id(0) {
    //log("Tile::Tile");
}
