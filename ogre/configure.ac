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

PKG_CHECK_MODULES(ODE, [ode >= 0.11])
AC_SUBST(ODE_CFLAGS)
AC_SUBST(ODE_LIBS)

# -----------------------------------------------
# OGRE

PKG_CHECK_MODULES(OGRE, [OGRE >= 1.7])
AC_SUBST(OGRE_CFLAGS)
AC_SUBST(OGRE_LIBS)

# -----------------------------------------------
# OIS

#PKG_CHECK_MODULES(OIS, [OIS >= 1.0])
#AC_SUBST(OIS_CFLAGS)
#AC_SUBST(OIS_LIBS)

# -------------------------------------------
# Boost

#AC_CHECK_HEADERS([boost/version.hpp],
    #[],
    #[AC_MSG_ERROR([
    #*** Couldn't find Boost.])])

# -------------------------------------------
# Boost.Signals

#AX_BOOST_BASE

#AC_CHECK_HEADERS([boost/signal.hpp],
    #[BOOST_SIGNALS_LIBS="-lboost_signals"],
    #[AC_MSG_ERROR([
    #*** Couldn't find Boost.Signals.])])
#AC_SUBST(BOOST_SIGNALS_LIBS)

# -----------------------------------------------
# Headers

AC_HEADER_STDC
AC_CHECK_HEADERS([math.h string.h limits.h stdbool.h stddef.h assert.h float.h])

# -----------------------------------------------
# Generate Makefiles

AC_OUTPUT(Makefile \
src/Makefile \
)
