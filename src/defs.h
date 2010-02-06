
// ----------------------------------------------------------------------------
// OpenGL <-> libnds cross platform definitions
//
// The idea is to program for the (more limited) libnds but allow compilation
// against Mesa by defining all the hokey libnds versions using their PC OpenGL
// counterparts. Therefore while compiling on the PC, many mappings to specific
// sized data types such as v10, v16, f32, will be avoided by using
// floats/doubles in their place.

#ifndef DEFS_H
#define DEFS_H 1

#ifdef USE_NDS

#include <PA9.h>

inline void glNormal3v10(v10 x, v10 y, v10 z) { glNormal(NORMAL_PACK(x, y, z)); }
inline void glFlushNDS(uint32 mode) { glFlush(mode); }

#else

// Define the libnds OpenGL API using real OpenGL

#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>

#define SCREEN_HEIGHT 192
#define SCREEN_WIDTH  256

#ifdef v16
#undef v16
#endif

#ifdef u8
#undef u8
#endif

#ifdef u32
#undef u32
#endif

typedef float v10;
typedef float v16;
typedef float f32;
typedef unsigned char u8;
typedef unsigned int u32;
typedef char int8;
typedef short int16;
typedef int int32;
typedef unsigned short rgb; /*!< \brief Holds a color value. 1bit alpha, 5bits red, 5bits green, 5bits blue. */
typedef signed long s32;

inline void glNormal3v10(v10 x, v10 y, v10 z) { glNormal3f(x, y, z); }
inline v10 floattov10(float x) { return x; }
inline v16 floattov16(float x) { return x; }
inline f32 floattof32(float x) { return x; }
inline v16 inttov16(int x) { return (v16)x; }
inline v10 inttov10(int x) { return (v10)x; }
inline f32 inttof32(int x) { return (f32)x; }
inline void glVertex3v16(v16 x, v16 y, v16 z) { glVertex3f(x, y, z); }
inline void glTranslate3f32(f32 x, f32 y, f32 z) { glTranslatef(x, y, z); }
inline void glOrthof32(f32 left, f32 right, f32 bottom, f32 top, f32 znear, f32 zfar) { glOrtho(left, right, bottom, top, znear, zfar); }
inline void glPopMatrix(int32 n){ for(int32 i = 0; i != n; ++i){ glPopMatrix(); } }
inline void glRotatef32i(f32 angle, int32 x, int32 y, int32 z) { glRotatef(angle, x, y, z); }
inline void gluLookAtf32(f32 eyex, f32 eyey, f32 eyez, f32 lookatx, f32 lookaty, f32 lookatz, f32 upx, f32 upy, f32 upz) { gluLookAt(eyex, eyey, eyez, lookatx, lookaty, lookatz, upx, upy, upz); }

#define RGB15(r,g,b)  ((r)|((g)<<5)|((b)<<10))
#define RGB5(r,g,b)  ((r)|((g)<<5)|((b)<<10))
#define RGB8(r,g,b)  (((r)>>3)|(((g)>>3)<<5)|(((b)>>3)<<10))

#define BLUE(rgb) (((rgb) >> 10) & 0x1f)
#define GREEN(rgb) (((rgb) >> 5) & 0x1f)
#define RED(rgb) (((rgb) >> 0) & 0x1f)

inline float *unpackRGB(rgb col, float params[4]) { 
    params[0] = (col & 0x1f)/31.0f;
    params[1] = ((col >> 5) & 0x1f)/31.0f;
    params[2] = ((col >> 10) & 0x1f)/31.0f;
    params[3] = 1.0;
    return params;
}
inline void glMaterialf(GLenum pname, rgb color) { float params[4]; glMaterialfv(GL_FRONT, pname, unpackRGB(color, params)); }
inline void glFlushNDS(u32 mode) { glFlush(); }
inline void glLight(int id, rgb color, v10 x, v10 y, v10 z) {
    float params[4];
    params[0] = x;
    params[1] = y;
    params[3] = z;
    glLightfv(id, GL_POSITION, params);
    glLightfv(id, GL_DIFFUSE, unpackRGB(color, params));
}

#endif

void start_frame(void) {
#ifdef USE_NDS
    // NDS clears the screen automatically?
#else
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
#endif
}

void end_frame(void) {
#ifdef USE_NDS
    PA_WaitForVBL();
#endif
}

#endif

