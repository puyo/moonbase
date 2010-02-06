CPP = g++
CXXFLAGS += -Wall -g `sdl-config --cflags`
LDFLAGS += -lGL -lGLU -lglut `sdl-config --libs` -L/usr/lib -L/usr/local/lib

OBJS = game.o main.o map_view.o util.o demo.o video.o map.o tile.o

moonbase: $(OBJS)
	$(CPP) -o moonbase $(OBJS) $(LDFLAGS) 

clean:
	$(RM) moonbase
	$(RM) $(OBJS)

