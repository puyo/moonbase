#include "video.h"
#include "util.h"
#include <GL/gl.h>
#include <cstdio>

int Video::init(int width, int height, int bpp, bool fullscreen) {
    int video_flags;
    int rgb_size[3];
    int value;

    if( SDL_Init( SDL_INIT_EVERYTHING ) < 0 ) {
        logf("Couldn't initialize SDL: %s\n", SDL_GetError());
        SDL_Quit();
        exit(1);
    }

    /* See if we should detect the display depth */
    if ( bpp == 0 ) {
        if ( SDL_GetVideoInfo()->vfmt->BitsPerPixel <= 8 ) {
            bpp = 8;
        } else {
            bpp = 16;  /* More doesn't seem to work */
        }
    }

    /* Set the flags we want to use for setting the video mode */
    video_flags = SDL_DOUBLEBUF | SDL_OPENGL;

    if (fullscreen) 
        video_flags |= SDL_FULLSCREEN;
    
    /* Initialize the display */
    switch (bpp) {
        case 8:
        rgb_size[0] = 3;
        rgb_size[1] = 3;
        rgb_size[2] = 2;
        break;
        case 15:
        case 16:
        rgb_size[0] = 5;
        rgb_size[1] = 5;
        rgb_size[2] = 5;
        break;
            default:
        rgb_size[0] = 8;
        rgb_size[1] = 8;
        rgb_size[2] = 8;
        break;
    }
    SDL_GL_SetAttribute( SDL_GL_RED_SIZE, rgb_size[0] );
    SDL_GL_SetAttribute( SDL_GL_GREEN_SIZE, rgb_size[1] );
    SDL_GL_SetAttribute( SDL_GL_BLUE_SIZE, rgb_size[2] );
    SDL_GL_SetAttribute( SDL_GL_DEPTH_SIZE, 16 );
    SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );

// fullscreenantialiasing, disabled for now
//            if ( fsaa ) {
//                SDL_GL_SetAttribute( SDL_GL_MULTISAMPLEBUFFERS, 1 );
//                SDL_GL_SetAttribute( SDL_GL_MULTISAMPLESAMPLES, fsaa );
//            }
//

// dont know what this is
//            if ( accel ) {
//                SDL_GL_SetAttribute( SDL_GL_ACCELERATED_VISUAL, 1 );
//            }

// vsync?
//            if ( sync ) {
//                SDL_GL_SetAttribute( SDL_GL_SWAP_CONTROL, 1 );
//            } else {
//                SDL_GL_SetAttribute( SDL_GL_SWAP_CONTROL, 0 );
//            }
//

    if ( SDL_SetVideoMode( width, height, bpp, video_flags ) == NULL ) {
        logf("Couldn't set 300x300 GL video mode: %s\n", SDL_GetError());
        SDL_Quit();
        exit(1);
    }
    SDL_WM_SetCaption("Moonbase", "moonbase");

    logf("Screen BPP: %d", SDL_GetVideoSurface()->format->BitsPerPixel);
    logf("GL vendor: %s", glGetString(GL_VENDOR));
    logf("GL renderer: %s", glGetString(GL_RENDERER));
    logf("GL version: %s", glGetString(GL_VERSION));
    //logf("Extensions : %s\n", glGetString(GL_EXTENSIONS));

    SDL_GL_GetAttribute( SDL_GL_RED_SIZE, &value );
    logf("SDL_GL_RED_SIZE: requested %d, got %d", rgb_size[0],value);
    SDL_GL_GetAttribute( SDL_GL_GREEN_SIZE, &value );
    logf("SDL_GL_GREEN_SIZE: requested %d, got %d", rgb_size[1],value);
    SDL_GL_GetAttribute( SDL_GL_BLUE_SIZE, &value );
    logf("SDL_GL_BLUE_SIZE: requested %d, got %d", rgb_size[2],value);
    SDL_GL_GetAttribute( SDL_GL_DEPTH_SIZE, &value );
    logf("SDL_GL_DEPTH_SIZE: requested %d, got %d", bpp, value );
    SDL_GL_GetAttribute( SDL_GL_DOUBLEBUFFER, &value );
    logf("SDL_GL_DOUBLEBUFFER: requested 1, got %d", value);

//            if ( fsaa ) {
//                SDL_GL_GetAttribute( SDL_GL_MULTISAMPLEBUFFERS, &value );
//                log(va("SDL_GL_MULTISAMPLEBUFFERS: requested 1, got %d\n", value ));
//                SDL_GL_GetAttribute( SDL_GL_MULTISAMPLESAMPLES, &value );
//                log(va("SDL_GL_MULTISAMPLESAMPLES: requested %d, got %d\n", fsaa, value ));
//            }
//            if ( accel ) {
//                SDL_GL_GetAttribute( SDL_GL_ACCELERATED_VISUAL, &value );
//                log(va( "SDL_GL_ACCELERATED_VISUAL: requested 1, got %d\n", value ));
//            }
//            if ( sync ) {
//                SDL_GL_GetAttribute( SDL_GL_SWAP_CONTROL, &value );
//                log(va( "SDL_GL_SWAP_CONTROL: requested 1, got %d\n", value ));
//            }

    glClearColor(0.0,0.0,0.0,0.0);

    return 1;
}
