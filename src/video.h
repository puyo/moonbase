#ifndef VIDEO_H
#define VIDEO_H 1

#include <SDL/SDL.h>
#include <SDL/SDL_opengl.h>

int video_init(int width, int height, int bpp=0, bool fullscreen=false);

#endif

