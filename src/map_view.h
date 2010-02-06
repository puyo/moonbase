#ifndef MAPVIEW_H
#define MAPVIEW_H

#include "map.h"
#include "util.h"
#include <GL/gl.h>

class map_view {

    public: // constructors

        map_view(Map& map);

    public:

        void draw(unsigned int dticks);

        void scroll(float dx, float dy);

    private: // data

        Map& _map;
        float _scroll_x;
        float _scroll_y;
        GLuint _dl;
};

#endif

