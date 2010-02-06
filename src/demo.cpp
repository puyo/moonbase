#include "point.h"
#include "util.h"
#include "game.h"
#include <string>
#include <SDL.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>

static float demo3d_rotate = 0.0f;

GLfloat white[] = { 1.0, 1.0, 1.0, 1.0 };
GLfloat red[] = { 1.0, 0.0, 0.0, 1.0 };
GLfloat green[] = { 0.0, 1.0, 0.0, 1.0 };
GLfloat blue[] = { 0.0, 0.0, 1.0, 1.0 };

void draw_axes(void){
    static float len = 10.0f;
    glDisable(GL_LIGHTING);
    glPushMatrix();
        glColor3f(1.0, 0.0, 0.0);
        glMaterialfv(GL_FRONT, GL_EMISSION, red);
        glBegin(GL_LINES);
            glVertex3f(0, 0, 0);
            glVertex3f(len, 0, 0);
        glEnd();

        glColor3f(0.0, 1.0, 0.0);
        glMaterialfv(GL_FRONT, GL_EMISSION, green);
        glBegin(GL_LINES);
            glVertex3f(0, 0, 0);
            glVertex3f(0, len, 0);
        glEnd();

        glColor3f(0.0, 0.0, 1.0);
        glMaterialfv(GL_FRONT, GL_EMISSION, blue);
        glBegin(GL_LINES);
            glVertex3f(0, 0, 0);
            glVertex3f(0, 0, len);
        glEnd();
    glPopMatrix();
    glEnable(GL_LIGHTING);
}

void draw_cube(void){
    //log("draw_cube");

    glPushMatrix(); // Start to draw something in the empty room.
    glLoadIdentity();

    // move it away from the centre
    glTranslatef(0.0f, 0.0f, -2.0f);

    printf("rotate = %f\n", demo3d_rotate);
    glRotatef(demo3d_rotate, 1.0f, 0.0f, 0.0f);
    glRotatef(demo3d_rotate, 0.0f, 1.0f, 0.0f);
    glRotatef(demo3d_rotate, 0.0f, 0.0f, 1.0f);

    // spin
    //glRotatef32i(floattof32(demo3d_rotate/2.0f), 0, 1, 0);
    //glRotatef32i(floattof32(demo3d_rotate/3.0f), 0, 0, 1);

    GLfloat ambient[] = { 0.5f, 0.5f, 0.5f, 0.5f };
    GLfloat diffuse[] = { 0.5f, 0.5f, 0.5f, 0.5f };
    GLfloat specular[] = { 0.5f, 0.5f, 0.5f, 0.5f };
    GLfloat emission[] = { 0.5f, 0.5f, 0.5f, 0.5f };

    glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
    glMaterialfv(GL_FRONT, GL_EMISSION, emission);
    glutSolidCube(0.5f);

    glPopMatrix(); //Stop to draw something in the empty room.
}

static void demo3d_move() {
    //log("demo3d_move");

    int cur_time;
    static int last_time;
    int delta;
    cur_time = SDL_GetTicks();
    delta = cur_time - last_time;
    last_time = cur_time;

    demo3d_rotate += float(delta)/10.0f;

    while (demo3d_rotate >= 360.0f){
        demo3d_rotate -= 360.0f;
    }
    while (demo3d_rotate < 0.0f){
        demo3d_rotate += 360.0f;
    }
}

void demo3d_display(void) {
    //log("demo3d_display");

    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    //draw_axes();
    //draw_cube();
/*
    glPointSize(10);

    glDisable(GL_LIGHTING);
    glBegin(GL_POINTS);
    glColor3f(1.0, 0.0, 0.0);
    glVertex3f(3, 0, 0);
    glColor3f(1.0, 1.0, 0.0);
    glVertex3f(0, 3, 0);
    glColor3f(0.0f, 0.0f, 1.0f);
    glVertex3f(0, 0, 3);
    glEnd();
    glEnable(GL_LIGHTING);
    */

    //SDL_GL_SwapBuffers();
}

static void demo3d_init(void) {
    //log("demo3d_init");

    // NB: glFrustrum and gluPerspective are fucking broken in libnds 1.11,
    // which is what PAlib comes with might be okay because we probably want an
    // ortho perspective anyway...
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(90, 1.3, 0.1, 100);
    //glOrtho(left, right, bottom, top, znear, zfar)
    //glOrtho(-2.0 * SCREEN_WIDTH / SCREEN_HEIGHT, 
            //2.0 * SCREEN_WIDTH / SCREEN_HEIGHT,
            ////-2, 2,
            //0.1, 100);


    // Camera

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // eye <x,y,z>, target <x,y,z>, up <x,y,z>
    gluLookAt(3, 3, 3,
            0, 0, 0,
            0, 1, 0);

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHT1);
    glEnable(GL_LIGHT2);
    glEnable(GL_LIGHT3);
    glEnable(GL_DEPTH_TEST);

    glShadeModel(GL_SMOOTH);

    //glPolygonMode(GL_FRONT, GL_LINE); // wireframe mode

    GLfloat lightpos0[] = { 3.0, 3.0, 3.0 };
    GLfloat lightpos1[] = { 3.0, 0.0, 0.0 };
    GLfloat lightpos2[] = { 0.0, 3.0, 0.0 };
    GLfloat lightpos3[] = { 0.0, 0.0, 3.0 };

    glLightfv(GL_LIGHT0, GL_POSITION, lightpos0);
    glLightfv(GL_LIGHT1, GL_POSITION, lightpos1);
    glLightfv(GL_LIGHT2, GL_POSITION, lightpos2);
    glLightfv(GL_LIGHT3, GL_POSITION, lightpos3);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, red);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, green);
    glLightfv(GL_LIGHT3, GL_DIFFUSE, blue);
}

void demo3d(void) {
    //log("demo3d");

    demo3d_init();
    demo3d_rotate = 0.0f;

    int done = 0;
    SDL_Event event;
    while (!done) {
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    done = 1;
                    break;
                case SDL_KEYDOWN:
                    if (event.key.keysym.sym == SDLK_q)
                        done = 1;
                    if (event.key.keysym.sym == SDLK_LEFT)
                        demo3d_rotate += 10;
                    if (event.key.keysym.sym == SDLK_RIGHT)
                        demo3d_rotate -= 10;
                    break;
            }
        }

        demo3d_move();
        //demo3d_display();
    }
}
