#include "demo.h"
#include "point.h"
#include "util.h"
#include "game.h"
#include "map.h"
#include "mapview.h"
#include "video.h"
#include <string>
#include <GL/glut.h>

#define SCREEN_WIDTH 1024
#define SCREEN_HEIGHT 768

typedef enum {
    mode_normal_exit, //< Normal exit
    mode_fatal_error, //< Unrecoverable error
    mode_logo, //< Startup developer logo
    mode_menu, //< Main game menu
    mode_lobby, //< Game lobby
    mode_game_loading, //< Game loading/waiting screen
    mode_game, //< Game screen
    mode_after_game, //< Post game screen,  scoreboard
} game_mode;

static std::string fatal_error;
static unsigned char next_game_mode;
static Video *video = NULL;

//! Allow any module to set the last error
void set_fatal_error(std::string err) {
    fatal_error = err;
}

//! Set next game mode. This will determine which game mode will be started
//after the current mode ends.
void set_next_game_mode(game_mode mode) {
    next_game_mode = mode;
}

static void draw_axes(void){
    static float len = 30.0f;
    glDisable(GL_LIGHTING);
    glPushMatrix();
        glColor3f(1.0, 0.0, 0.0); // x = red
        glBegin(GL_LINES);
            glVertex3f(0, 0, 0);
            glVertex3f(len, 0, 0);
        glEnd();

        glColor3f(0.0, 1.0, 0.0); // y = green
        glBegin(GL_LINES);
            glVertex3f(0, 0, 0);
            glVertex3f(0, len, 0);
        glEnd();

        glColor3f(0.0, 0.0, 1.0); // z = blue
        glBegin(GL_LINES);
            glVertex3f(0, 0, 0);
            glVertex3f(0, 0, len);
        glEnd();
    glPopMatrix();
    glEnable(GL_LIGHTING);
}

//! Initialise video
void init_screen(int *argc, char **argv) {
    video = new Video();
    video->init(SCREEN_WIDTH, SCREEN_HEIGHT);

    glViewport(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);  // "virtual" size
    glClearDepth(0x7FFF);
}

void logo_loop(void) {
    log("logo_loop");
    // TODO
    set_next_game_mode(mode_menu);
}

void error(void) {
    logf("ERROR: %s", fatal_error.c_str());
}

void menu_loop(void) {
    log("menu_loop");
    // TODO
    set_next_game_mode(mode_game);
}

void load_game_loop(Game& game) {
    log("load_game_loop");
    game.generate_map();
    set_next_game_mode(mode_game);
}

void game_loop(Game& game) {
    log("game_loop");

    // For now...
    game.generate_map();
    Map *map = game.map();

    if (map == NULL) {
        set_fatal_error("cannot enter game loop until game map is loaded");
        set_next_game_mode(mode_fatal_error);
        return;
    }

    // Set up viewport etc.
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(90, 1.3, 0.1f, 1000.0f);

    // Camera
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    // eye <x,y,z>, target <x,y,z>, up <x,y,z>
    gluLookAt(50.0, 50.0, 50.0,
            0, 0, 0,
            0, 1, 0);

    //glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_DEPTH_TEST);
    glShadeModel(GL_SMOOTH);

    glPolygonMode(GL_FRONT, GL_LINE); // wireframe mode
    glPolygonMode(GL_BACK, GL_POINT); // wireframe mode

    GLfloat lightpos0[] = { 3.0, 10.0, 2.0 };
    GLfloat lightcol[] = { 1.0, 1.0, 0.8, 1.0 }; // yellowy light

    glLightfv(GL_LIGHT0, GL_POSITION, lightpos0);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, lightcol);

    MapView map_view(*map);
    map_view.scroll(map->w() * 5.0f, map->h() * 5.0f);
    SDL_Event event;
    bool done = 0;
    unsigned int last_ticks = 0;
    log("game_loop: entering loop");
    float dx = 0, dy = 0;
    float scroll_speed = 2.0f;
    do {
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    done = 1;
                    break;
                case SDL_KEYDOWN:
                    if (event.key.keysym.sym == SDLK_q ||
                            event.key.keysym.sym == SDLK_ESCAPE)
                        done = 1;
                    if (event.key.keysym.sym == SDLK_LEFT) 
                        dx = -scroll_speed;
                    if (event.key.keysym.sym == SDLK_RIGHT)
                        dx = scroll_speed;
                    if (event.key.keysym.sym == SDLK_UP)
                        dy = -scroll_speed;
                    if (event.key.keysym.sym == SDLK_DOWN)
                        dy = scroll_speed;
                    break;
                case SDL_KEYUP:
                    if (event.key.keysym.sym == SDLK_LEFT) 
                        dx = 0;
                    if (event.key.keysym.sym == SDLK_RIGHT)
                        dx = 0;
                    if (event.key.keysym.sym == SDLK_UP)
                        dy = 0;
                    if (event.key.keysym.sym == SDLK_DOWN)
                        dy = 0;
            }
        }
        map_view.scroll(dx, dy);

        unsigned int ticks = (unsigned int)SDL_GetTicks();
        unsigned int dticks = ticks - last_ticks;
        last_ticks = ticks;

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        draw_axes();

        GLfloat ambient[] = { 1.0f, 1.0f, 1.0f, 1.0f };
        GLfloat diffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
        GLfloat specular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
        GLfloat emission[] = { 0.0f, 0.0f, 0.0f, 1.0f };

        glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
        glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
        glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
        glMaterialfv(GL_FRONT, GL_EMISSION, emission);
        glutSolidCube(3.0f);

        game.think(dticks);

        map_view.draw(dticks);

        SDL_GL_SwapBuffers();

    } while (!done);

    //set_next_game_mode(mode_menu);
    set_next_game_mode(mode_normal_exit);
}

// ----------------------------------------------------------------------------

int main(int argc, char **argv) {
    // Initial state
    set_next_game_mode(mode_logo);

    // Don't let fatal_error point to a random memory location
    fatal_error = "no fatal error defined";

    init_screen(&argc, argv);

    Game game;

    for(;;) {
        logf("next_game_mode == %d", next_game_mode);
        switch (next_game_mode) {
            case mode_normal_exit:
                return 0;
            case mode_fatal_error:
                error();
                return 1;
            case mode_game:
                game_loop(game);
                break;
            case mode_logo:
                logo_loop();
                break;
            case mode_menu:
                menu_loop();
                break;
            default:
                logf("Mode not handled: %d", next_game_mode);
                return 0;
        }
    }

    return 0;
}
