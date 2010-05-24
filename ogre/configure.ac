# $Id$
# Process this file with Autoconf to create configure

define([MOONBASE_VERSION],[0.1.0])
# x.y.z where release procedure is:
#   - Increment z.
#   - If interfaces have changed destroying backwards compatibility,
#     increment y and set z to 0.
#   - If the library seems quite different now, increment x and set y
#     and z to 0. (subjective / marketing version number)

# -----------------------------------------------
# Init

AC_PREREQ(2.61)

AC_INIT([Moonbase],MOONBASE_VERSION,[moonbase@puyo.cjb.net],[moonbase])
AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE([1.10 foreign -Wall -Werror dist-bzip2])
AC_CONFIG_HEADER(src/config.h)
AC_REVISION([$Revision$])

# -----------------------------------------------
# Programs

AC_PROG_CC
AC_PROG_CXX
AC_PROG_CPP
AC_LANG_CPLUSPLUS
AC_REQUIRE_CPP

# -----------------------------------------------
# Math library (non-UNIX platforms)

AC_CHECK_HEADERS(math.h)
AC_CHECK_LIB(m, pow,
    [M_LIBS="-lm"],
    [AC_MSG_ERROR([*** libm not found.])]
    )
AC_SUBST(M_LIBS)

# -----------------------------------------------
# ODE (Open Dynamics Engine)

AC_CHECK_HEADERS(ode/ode.h)
AC_CHECK_LIB(ode, [dWorldStep],
             [ODE_LIBS="-lode"],
             [AC_MSG_ERROR([
              *** Could not find ODE.
              ])])
AC_SUBST(ODE_LIBS)

# -----------------------------------------------
# DevIL Image Library

AC_CHECK_LIB(IL, [ilInit],
    [IL_LIBS="-lIL"],
    [AC_MSG_ERROR([*** Could not find DevIL. Get it at http://openil.sourceforge.net/.])])
AC_SUBST(IL_LIBS)

AC_CHECK_LIB(ILU, [iluFlipImage],
    [ILU_LIBS="-lILU"],
    [AC_MSG_ERROR([*** Could not find DevIL. Get it at http://openil.sourceforge.net/.])])
AC_SUBST(ILU_LIBS)

# -----------------------------------------------
# OIS

PKG_CHECK_MODULES(OIS, [OIS >= 1.0.0],
    [],
    [AC_MSG_ERROR([
*** Couldn't find OIS or tests failed:
*** $OIS_PKG_ERRORS
])])

# -----------------------------------------------
# Ogre3D

PKG_CHECK_MODULES(OGRE, OGRE)
AC_SUBST(OGRE_CFLAGS)
AC_SUBST(OGRE_LIBS)

# -------------------------------------------
# Boost

AC_CHECK_HEADERS([boost/version.hpp],
    [],
    [AC_MSG_ERROR([
    *** Couldn't find Boost.])])

#AC_CHECK_LIB(boost_signals, ,
    #[],
    #[AC_MSG_ERROR([*** Could not find Boost.Signals library.])])

# -------------------------------------------
# Boost.Signals

AC_CHECK_HEADERS([boost/signal.hpp],
    [BOOST_SIGNALS_LIBS="-lboost_signals"],
    [AC_MSG_ERROR([
    *** Couldn't find Boost.Signals.])])
AC_SUBST(BOOST_SIGNALS_LIBS)

# -----------------------------------------------
# Headers

AC_HEADER_STDC
AC_CHECK_HEADERS([math.h string.h limits.h stdbool.h stddef.h assert.h float.h])

# -----------------------------------------------
# Generate Makefiles

AC_OUTPUT(Makefile \
src/Makefile \
)
