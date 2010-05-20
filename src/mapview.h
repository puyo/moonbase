#ifndef MAPVIEW_H
#define MAPVIEW_H

#include "map.h"
#include "util.h"
#include <SDL/SDL_opengl.h>

class MapView {
    public:
        MapView(Map& map);
    public:
        void draw(unsigned int dticks);
        void scroll(float dx, float dy);
    private:
        void draw_tiles(unsigned int dticks);
        void draw_water(unsigned int dticks);
    private:
        Map& _map;
        float _scroll_x;
        float _scroll_y;
        GLuint _dl;
};

#endif

