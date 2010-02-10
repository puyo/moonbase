#include "map.h"
#include <ctime>
#include <cstdlib>
#include <cmath>

static unsigned int heights[] = { 0, 10, 10, 10, 10, 10, 10, 10, 20, 20 };
unsigned int nheights = 10;

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
            Tile *t = map.tile(i, j);
            unsigned int h = t->height();
            count = 0;
            unsigned int alt_h = 0;
            for (unsigned o = 0; o < noffsets; ++o) {
                unsigned int other_h = map.tile(
                        (i + offsets[o][0]) % map.w(), 
                        (j + offsets[o][1]) % map.h() )->height();
                if (other_h == h) {
                    count++;
                } else {
                    alt_h = other_h;
                }
            }
            if (count < 1) {
                t->set_height(alt_h);
            }
        }
    }
}

void makefractal(Map& map, int energy, int xstep, int ystep) {
    logf("makefractal(%d, %d)", xstep, ystep);
    for (unsigned int y = 0; y < map.h(); y += ystep) {
        for (unsigned int x = 0; x < map.h(); x += xstep) {
            // The inner loop calculates (cx,cy)
            // this is the point from which to copy map properties

            // add random offsets
            //unsigned int offset = random() % 2*energy;
            unsigned int offset = 1;
            unsigned int cx = x + xstep*offset;
            unsigned int cy = y + ystep*offset;

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
            int percent_random = 10;
            if ((random() % 100) < percent_random) {
                if (random() % 2)
                    h += 10.0f;
                else
                    h -= 10.0f;
                if (h < heights[0])
                    h = heights[0];
                else if (h > heights[nheights - 1])
                    h = heights[nheights - 1];
            }
            //if (percent_random != 0) {
                //h = (unsigned int)(h * 
                        //(float)((100 - percent_random/2) + 
                            //(random() % (percent_random+1))) /
                        //100.0f);
            //}
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

Map::Map(Game& game):
    _game(game), _w(0), _h(0) {
    log("Map::Map");
    _w = 64;
    _h = 64;
    _tiles.resize(_w * _h);
    for (unsigned int y = 0; y < _h; ++y) {
        for (unsigned int x = 0; x < _w; ++x) {
            Tile *t = new Tile(*this);
            //t->set_height(random() % 20);
            t->set_height(heights[random() % nheights]);
            _tiles[_w * y + x] = t;

        }
    }
    // generate a random map
    //srandom(time(0));
    srandom(0);
    makefractal(*this, 7, _w / 4, _h / 4);
    smooth(*this);
}

