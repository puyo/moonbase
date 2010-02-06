#ifndef TILE_H
#define TILE_H 1

#include <cstdlib>

class Map; // forward declaration

class Tile {

#define GROUND 0

#define B_NONE 0

    public: // constructors

        Tile(Map& map);

    public:

        unsigned int height() const {
            return _height;
        }

        void set_height(unsigned int value) {
            _height = value;
        }
    private: // data

        Map& _map;
        unsigned int _height; //! determines the texture to use (?) is this feature creep? (gak)
        bool _resources; //! whether this tile has resources
        unsigned int _building; //! which building is on this tile
};

#endif
