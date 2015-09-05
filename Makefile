all: qix

qix.o:
	dmd -c -ofqix.o -debug -g -w -version=qix -version=Have_qix -version=Have_derelict_sdl2 -version=Have_derelict_util -Isource/ -I/home/andy/.dub/packages/derelict-sdl2-1.9.7/source/ -I/home/andy/.dub/packages/derelict-util-2.0.3/source/ source/billiardball.d source/mousey.d source/qix.d source/ringbuffer.d source/ttfD3Experiment.d source/vortex.d


qix: qix.o
	dmd -ofqix qix.o /home/andy/.dub/packages/derelict-sdl2-1.9.7/lib/libDerelictSDL2.a /home/andy/.dub/packages/derelict-util-2.0.3/lib/libDerelictUtil.a -L--no-as-needed -L-ldl -g


clean:
	rm qix
	rm qix.o
