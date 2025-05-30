
CC = clang
CFLAGS = -O3 -I ./snes -I ./zip

WINDRES = windres

execname = lakesnes
sdlflags = `sdl2-config --cflags --libs`

appname = LakeSnes.app
appexecname = lakesnes_app
appsdlflags = -framework SDL2 -F sdl2 -rpath @executable_path/../Frameworks

winexecname = lakesnes.exe

cfiles = snes/snes_spc.c snes/snes_dsp.c snes/snes_apu.c snes/snes_cpu.c snes/snes_dma.c snes/snes_ppu.c snes/snes_cart.c snes/snes_cx4.c snes/snes_input.c snes/snes_statehandler.c snes/snes.c snes/snes_other.c \
 zip/zip.c tracing.c main.c
hfiles = snes/spc.h snes/dsp.h snes/apu.h snes/cpu.h snes/dma.h snes/ppu.h snes/cart.h snes/cx4.h snes/input.h snes/statehandler.h snes/snes.h \
 zip/zip.h zip/miniz.h tracing.h

.PHONY: all clean

all: $(execname)

$(execname): $(cfiles) $(hfiles)
	$(CC) $(CFLAGS) -o $@ $(cfiles) $(sdlflags)  -DTARGET_GNW -DLINUX_EMU

$(appexecname): $(cfiles) $(hfiles)
	$(CC) $(CFLAGS) -o $@ $(cfiles) $(appsdlflags) -D SDL2SUBDIR

$(appname): $(appexecname)
	rm -rf $(appname)
	mkdir -p $(appname)/Contents/MacOS
	mkdir -p $(appname)/Contents/Frameworks
	mkdir -p $(appname)/Contents/Resources
	cp -R sdl2/SDL2.framework $(appname)/Contents/Frameworks/
	cp $(appexecname) $(appname)/Contents/MacOS/$(appexecname)
	cp resources/appicon.icns $(appname)/Contents/Resources/
	cp resources/PkgInfo $(appname)/Contents/
	cp resources/Info.plist $(appname)/Contents/

$(winexecname): $(cfiles) $(hfiles)
	$(WINDRES) resources/win.rc -O coff -o win.res
	$(CC) $(CFLAGS) -o $@ $(cfiles) win.res $(sdlflags)

clean:
	rm -f $(execname) $(appexecname) $(winexecname) win.res
	rm -rf $(appname)
