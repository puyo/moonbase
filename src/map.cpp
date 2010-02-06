#include "map.h"
#include <ctime>
#include <cstdlib>
#include <cmath>

void makefractal(Map& map, int energy, int xstep, int ystep) {
    logf("makefractal(%d, %d)", xstep, ystep);
    for (unsigned int y = 0; y < map.h(); y += ystep) {
        for (unsigned int x = 0; x < map.h(); x += xstep) {
            // The inner loop calculates (cx,cy)
            // this is the point from which to copy map properties

            // add random offsets
            unsigned int offset = (random() % 2 * energy);
            unsigned int cx = x + xstep * offset;
            unsigned int cy = y + ystep * offset;

            // truncate to nearest multiple of step*2
            // since step*2 is the previous detail level calculated
            cx = (cx/(xstep*2))*xstep*2;
            cy = (cy/(ystep*2))*ystep*2;

            // wrap around to reference world as torus
            // also guarantees getCell() and setCell() are within bounds
            cx %= map.w();
            cy %= map.h();

            // copy from (cx,cy) to (x,y)
            unsigned int h = map.tile(cx, cy)->height();
            unsigned int percent_random = 5;
            if (percent_random != 0) {
                h = (unsigned int)(h * 
                        (float)((100 - percent_random/2) + 
                            (random() % (percent_random+1))) /
                        100.0f);
            }
            map.tile(x, y)->set_height(h);
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
        makefractal(map, energy - 1, xs, ys);
}

Map::Map(Game& game, std::string lua_filename):
    _game(game), _lua_filename(lua_filename), _w(0), _h(0)
{
    log("Map::Map");
    // TODO: load and evaluate lua file
    _w = 128;
    _h = 128;
    _tiles.resize(_w * _h);
    for (unsigned int y = 0; y < _h; ++y) {
        for (unsigned int x = 0; x < _w; ++x) {
            Tile *t = new Tile(*this);
            t->set_height(random() % 20);
            _tiles[_w * y + x] = t;

        }
    }
    log("Map::Map: here");
    // generate a random map
    srandom(time(0));
    makefractal(*this, 7, _w / 4, _h / 4);
}
