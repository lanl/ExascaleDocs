#!/bin/sh

set -v

tar -xzf mpe.tar.gz
cd mpe-1.9.1
./configure --x-includes=/usr/X11R6/include --x-libraries=/usr/X11R6/lib --enable-mpe_graphics=yes --disable-f77 --enable-viewers=no --enable-slog2=no --with-mpicc=mpicc #> configure.out 2>&1

# These following lines fix the mpe code. The first fix is so that
# mpe will compile with openmpi. Openmpi has combined the mpio.h
# header with the regular mpi.h header, so the mpio.h include is
# no longer necessary. The second is to fix what looks like a
# leftover debug statement that prints the strings to standard
# out as well as the X-display.

mv src/log_wrap.c src/log_wrap.c.orig
sed -e '1,$s!#include "mpio.h"!//#include "mpio.h"!' src/log_wrap.c.orig > src/log_wrap.c
mv src/mpe_graphics.c src/mpe_graphics.c.orig
sed -e '962,962s!^  !//!' src/mpe_graphics.c.orig > src/mpe_graphics.c

make #>make.out 2>&1
# Need to do as root -- sudo make install
#make install

