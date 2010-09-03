#include "mapview.h"
#include <GL/gl.h>
#include <boost/assign/list_of.hpp>
#include <map>

using namespace std;
using namespace boost::assign;

static GLfloat tile_ambient[] = { 0.5f, 0.0f, 0.0f, 1.0f };
static GLfloat tile_diffuse[] = { 0.0f, 0.5f, 0.0f, 1.0f };
static GLfloat tile_specular[] = { 0.0f, 0.0f, 1.0f, 1.0f };
static GLfloat tile_emission[] = { 0.1f, 0.1f, 0.1f, 1.0f };

static float tile_size = 10.0f;
static map<Tile::Type, int> tile_height = map_list_of
    (Tile::WATER, 0)
    (Tile::LOW,  10)
    (Tile::HIGH, 20);

MapView::MapView(Map& map): _map(map), _scroll_x(100), _scroll_y(100) {
}

void MapView::scroll(float dx, float dy) {
    _scroll_x += dx;
    _scroll_y += dy;
}

static inline int height(Tile *t) {
    return tile_height[t->type()];
}

void MapView::draw_tiles(unsigned int dticks) {
    glPushMatrix();
    glTranslatef(-_scroll_x, 0.0f, -_scroll_y);

    glMaterialfv(GL_FRONT, GL_AMBIENT, tile_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, tile_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, tile_specular);
    glMaterialfv(GL_FRONT, GL_EMISSION, tile_emission);

    for (unsigned int y = 0; y < (_map.h() - 1); ++y) {
        for (unsigned int x = 0; x < (_map.w() - 1); ++x) {
            Tile *t1 = _map.tile(x, y);
            Tile *t2 = _map.tile(x, y + 1);
            Tile *t3 = _map.tile(x + 1, y + 1);
            Tile *t4 = _map.tile(x + 1, y);
            if (t1 && t2 && t3 && t4) {
                glDisable(GL_LIGHTING);

                glDepthFunc(GL_LESS);
                glPolygonMode(GL_FRONT, GL_FILL);
                glBegin(GL_TRIANGLE_STRIP);
                glColor3f(0.0f, 0.0f, 0.0f);
                glVertex3f(x * tile_size, height(t1), y * tile_size);
                glVertex3f(x * tile_size, height(t2), (y + 1) * tile_size);
                glVertex3f((x + 1) * tile_size, height(t4), y * tile_size);
                glVertex3f((x + 1) * tile_size, height(t3), (y + 1) * tile_size);
                glEnd();

                glDepthFunc(GL_LEQUAL);

                glPolygonMode(GL_FRONT, GL_LINE);
                glBegin(GL_TRIANGLE_STRIP);

                glColor3f(height(t1) / 10.0f, 0.0f, 10.0f - height(t1) / 10.0f);
                glVertex3f(x * tile_size, height(t1) + 0.1f, y * tile_size);

                glColor3f(height(t2) / 10.0f, 0.0f, 10.0f - height(t2) / 10.0f);
                glVertex3f(x * tile_size, height(t2) + 0.1f, (y + 1) * tile_size);

                glColor3f(height(t4) / 10.0f, 0.0f, 10.0f - height(t4) / 10.0f);
                glVertex3f((x + 1) * tile_size, height(t4) + 0.1f, y * tile_size);

                glColor3f(height(t3) / 10.0f, 0.0f, 10.0f - height(t3) / 10.0f);
                glVertex3f((x + 1) * tile_size, height(t3) + 0.1f, (y + 1) * tile_size);

                glEnd();

                glEnable(GL_LIGHTING);
            }
        }
    }
    glPopMatrix();
}

void MapView::draw_water(unsigned int dticks) {
    glPushMatrix();
    glTranslatef(-_scroll_x, 0.0f, -_scroll_y);
    glDisable(GL_LIGHTING);
    glDepthFunc(GL_LESS);
    glPolygonMode(GL_FRONT, GL_FILL);
    glColor3f(0.1f, 0.0f, 0.6f);
    static float water_height = 5.0f;
    float water_width = _map.w() * tile_size;
    float water_breadth = _map.h() * tile_size;
    glBegin(GL_QUADS);
    glVertex3f(0.0f, water_height, 0.0f);
    glVertex3f(0.0f, water_height, water_breadth);
    glVertex3f(water_width, water_height, water_breadth);
    glVertex3f(water_width, water_height, 0.0f);
    glEnd();
    glPopMatrix();
}

void MapView::draw(unsigned int dticks) {
    draw_water(dticks);
    draw_tiles(dticks);
}
