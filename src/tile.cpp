#include "tile.h"
#include "util.h"

Tile::Tile(Map& map): _map(map), _height(GROUND), _resources(false), _building(B_NONE) {
    //log("Tile::Tile");
}
