CPP = g++
CXXFLAGS += -Wall -g `pkg-config --cflags sdl gl`
LDFLAGS += `pkg-config --libs sdl gl`

OBJS = game.o main.o mapview.o util.o demo.o video.o map.o tile.o

moonbase: $(OBJS)
	$(CPP) -o moonbase $(OBJS) $(LDFLAGS) 

clean:
	$(RM) moonbase
	$(RM) $(OBJS)
