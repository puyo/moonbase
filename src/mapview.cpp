#include "mapview.h"
#include <GL/gl.h>

static GLfloat tile_ambient[] = { 0.5f, 0.0f, 0.0f, 1.0f };
static GLfloat tile_diffuse[] = { 0.0f, 0.5f, 0.0f, 1.0f };
static GLfloat tile_specular[] = { 0.0f, 0.0f, 1.0f, 1.0f };
static GLfloat tile_emission[] = { 0.1f, 0.1f, 0.1f, 1.0f };

static float tile_size = 10.0f;

MapView::MapView(Map& map): _map(map), _scroll_x(100), _scroll_y(100) {
}

void MapView::scroll(float dx, float dy) {
    _scroll_x += dx;
    _scroll_y += dy;
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
            //logf("%d", t->height());
            if (t1 && t2 && t3 && t4) {
                glDisable(GL_LIGHTING);

                glDepthFunc(GL_LESS);
                glPolygonMode(GL_FRONT, GL_FILL);
                glBegin(GL_TRIANGLE_STRIP);
                glColor3f(0.0f, 0.0f, 0.0f);
                glVertex3f(x * tile_size, t1->height(), y * tile_size);
                glVertex3f(x * tile_size, t2->height(), (y + 1) * tile_size);
                glVertex3f((x + 1) * tile_size, t4->height(), y * tile_size);
                glVertex3f((x + 1) * tile_size, t3->height(), (y + 1) * tile_size);
                glEnd();

                glDepthFunc(GL_LEQUAL);

                glPolygonMode(GL_FRONT, GL_LINE);
                glBegin(GL_TRIANGLE_STRIP);

                glColor3f(t1->height() / 10.0f, 0.0f, 10.0f - t1->height() / 10.0f);
                glVertex3f(x * tile_size, t1->height() + 0.1f, y * tile_size);

                glColor3f(t2->height() / 10.0f, 0.0f, 10.0f - t2->height() / 10.0f);
                glVertex3f(x * tile_size, t2->height() + 0.1f, (y + 1) * tile_size);

                glColor3f(t4->height() / 10.0f, 0.0f, 10.0f - t4->height() / 10.0f);
                glVertex3f((x + 1) * tile_size, t4->height() + 0.1f, y * tile_size);

                glColor3f(t3->height() / 10.0f, 0.0f, 10.0f - t3->height() / 10.0f);
                glVertex3f((x + 1) * tile_size, t3->height() + 0.1f, (y + 1) * tile_size);

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
