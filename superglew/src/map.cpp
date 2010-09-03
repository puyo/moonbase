#include "map.h"
#include <ctime>
#include <cstdlib>
#include <cmath>
#include <boost/assign/list_of.hpp>
#include <vector>

using namespace std;
using namespace boost::assign;

static void smooth(Map& map) {
    int count;
    static int offsets[][2] = {
        { -1, 0 },
        { +1, 0 },
        { 0, -1 },
        { 0, +1 },
    };
    static int noffsets= 4;
    for (unsigned j = 0; j < map.h(); ++j) {
        for (unsigned i = 0; i < map.w(); ++i) {
            // if terrain around this tile is very different, then set this
            // tile to one of the terrain types around it
            Tile *t = map.tile(i, j);
            Tile::Type type = t->type();
            count = 0;
            Tile::Type alt_type;
            for (int o = 0; o < noffsets; ++o) {
                Tile::Type other_type = map.tile(
                        (i + offsets[o][0]) % map.w(), 
                        (j + offsets[o][1]) % map.h() )->type();
                if (other_type == type) {
                    count++;
                } else {
                    alt_type = other_type;
                }
            }
            if (count < 2) {
                t->set_type(alt_type);
            }
        }
    }
}

void make_fractal(Map& map, int energy, int xstep, int ystep) {
    logf("make_fractal(%d, %d)", xstep, ystep);
    for (unsigned int y = 0; y < map.h(); y += ystep) {
        for (unsigned int x = 0; x < map.h(); x += xstep) {
            // (cx,cy), the point from which to copy map properties
            unsigned int offset = random() % 2*energy;
            unsigned int cx = x + xstep*offset;
            unsigned int cy = y + ystep*offset;

            // truncate to nearest multiple of step*2 since step*2 is the
            // previous detail level calculated
            cx = (cx/(xstep*2))*xstep*2;
            cy = (cy/(ystep*2))*ystep*2;

            // wrap around to reference world as torus also guarantees we are
            // within bounds
            cx %= map.w();
            cy %= map.h();

            // copy from (cx,cy) to (x,y) with a chance of randomising
            int type = static_cast<int>(map.tile(cx, cy)->type());
            int percent_random = 10;
            if ((random() % 100) < percent_random) {
                if (random() % 2)
                    ++type;
                else
                    --type;
                if (type < 0)
                    type = 0;
                else if (type >= (int)Tile::ntypes)
                    type = Tile::ntypes - 1;
            }
            map.tile(x, y)->set_type(static_cast<Tile::Type>(type));
        }
    }
    bool done = true;
    int xs = 1, ys = 1;
    if (xstep > 1) {
        xs = xstep/2;
        done = false;
    }
    if (ystep > 1) {
        ys = ystep/2;
        done = false;
    }
    if (!done)
        make_fractal(map, energy - 1, xs, ys);
}

Map::Map(Game& game): _game(game), _w(0), _h(0) {
    log("Map::Map");

    _w = 32;
    _h = 32;
    _tiles.resize(_w * _h);

    // generate a random map

    static vector<Tile::Type> seed_types = list_of
        (Tile::WATER)
        (Tile::WATER)
        (Tile::LOW)
        (Tile::LOW)
        (Tile::LOW)
        (Tile::HIGH) 
        (Tile::HIGH);

    for (unsigned int y = 0; y < _h; ++y) {
        for (unsigned int x = 0; x < _w; ++x) {
            Tile *t = new Tile(*this);
            t->set_type(seed_types[random() % seed_types.size()]);
            _tiles[_w * y + x] = t;
        }
    }
    srandom(0); // always do random map 0, so we can compare versions
    make_fractal(*this, 7, _w / 4, _h / 4);
    smooth(*this);
}

