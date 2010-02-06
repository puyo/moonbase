#include "map_view.h"
#include <GL/gl.h>

MapView::MapView(Map& map): _map(map), _scroll_x(0), _scroll_y(0) {
    _dl = glGenLists(1);
    glNewList(_dl, GL_COMPILE);

    static float tile_size = 10.0f;

    GLfloat ambient[] = { 0.5f, 0.0f, 0.0f, 1.0f };
    GLfloat diffuse[] = { 0.0f, 0.5f, 0.0f, 1.0f };
    GLfloat specular[] = { 0.0f, 0.0f, 1.0f, 1.0f };
    GLfloat emission[] = { 0.1f, 0.1f, 0.1f, 1.0f };

    glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
    glMaterialfv(GL_FRONT, GL_EMISSION, emission);

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

    glEndList();
}

void MapView::scroll(float dx, float dy) {
    _scroll_x += dx;
    _scroll_y += dy;
}

void MapView::draw(unsigned int dticks) {
    glPushMatrix();
    glTranslatef(-_scroll_x, 0.0f, -_scroll_y);
    glCallList(_dl);
    glPopMatrix();
}
