#ifndef MAP_H
#define MAP_H 1

#include "tile.h"
#include "util.h"
#include <string>
#include <vector>
#include <algorithm>

class Game; // forward declaration

class Map {
    private: // types

        typedef std::vector<Tile *> TileArray;

    public: // constructors

        Map(Game& game);

        virtual ~Map() {
            std::for_each(_tiles.begin(), _tiles.end(), delete_object());
        }

    public:

        unsigned int w() const {
            return _w;
        }

        unsigned int h() const {
            return _h;
        }

        Tile *tile(unsigned int x, unsigned int y){
            return _tiles[_w * y + x];
        }

    private: // data

        Game& _game; // back reference
        unsigned int _w; // width in tiles
        unsigned int _h; // height in tiles
        TileArray _tiles;

    private: // uncopyable

        Map(const Map& map): _game(map._game) {
            // copy constructor
        }
};

#endif

