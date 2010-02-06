#ifndef UTIL_H
#define UTIL_H

// functor for use with for_each
struct delete_object {
  template <typename T>
  void operator()(T *ptr) { 
      if (ptr) {
          delete ptr;
          ptr = 0;
      }
  }
};

typedef float seconds;

void log(const char *text);
void logf(const char *format, ...);

#endif

