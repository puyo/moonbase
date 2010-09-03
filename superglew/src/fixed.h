#ifndef FIXED_H
#define FIXED_H 1

typedef u16 fixed; // or whateva

#define INT2FIXED(x) ((x) << 8)
#define FIXED2INT(x) ((x) >> 8)

#endif
