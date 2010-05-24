bin_PROGRAMS = moonbase moonbased

AM_CPPFLAGS = -isystem /usr/include/OGRE -ansi -pedantic -Wall -pedantic-errors -Wno-unused
AM_LDFLAGS = @BOOST_SIGNALS_LIBS@

moonbase_CPPFLAGS = $(AM_CPPFLAGS) @OGRE_CFLAGS@ @OIS_CFLAGS@
moonbase_LDFLAGS = $(AM_LDFLAGS) @OGRE_LIBS@ @OIS_LIBS@ @IL_LIBS@ @ILU_LIBS@ @ODE_LIBS@

moonbased_LDFLAGS = $(AM_LDFLAGS) @ODE_LIBS@

CLEANFILES = *~

COMMON_SOURCES = \
				   Game.cpp \
				   GameObject.cpp \
				   Player.cpp \
				   Map.cpp

moonbase_SOURCES = $(COMMON_SOURCES) \
				   client-main.cpp

moonbased_SOURCES = $(COMMON_SOURCES) \
				   server-main.cpp
