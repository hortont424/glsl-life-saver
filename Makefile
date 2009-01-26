all:
	gcc `pkg-config --cflags --libs glib-2.0` -lGL -lglut main.c -o life
