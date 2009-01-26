#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <GL/gl.h>
#include <GL/glu.h>
#include <GL/glut.h>

#include <glib.h>

#define WIDTH 1680
#define HEIGHT 1024

GLuint texture;
GLuint shader;
GLuint p;

guint generationRate = 1;

gboolean increasing = TRUE;

void display(void)
{
	int i;

	glUseProgram(p);

	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, texture);


	glBegin(GL_QUADS);
	glTexCoord2f(0.0, 0.0);
	glVertex2f(0.0, 0.0);
	glTexCoord2f(1, 0.0);
	glVertex2f(WIDTH, 0.0);
	glTexCoord2f(1,1);
	glVertex2f(WIDTH, HEIGHT);
	glTexCoord2f(0, 1);
	glVertex2f(0.0, HEIGHT);
	glEnd();

	glDisable(GL_TEXTURE_2D);
	
	glUseProgram(0);
	glBegin(GL_QUADS);

	if (g_random_int_range(0, 100) == 3)
	{
		gint size = g_random_int_range(0, 50)*g_random_double_range(0, 1);
		int x = random() % WIDTH;
		int y = random() % HEIGHT;
		
		
		glColor4f(0.0, 0.0,1.0, 1.0);
		glVertex2f(x, y);
		glVertex2f(x, y + size);
		glVertex2f(x + size, y + size);
		glVertex2f(x + size, y);
	}
	else if (g_random_int_range(0, 2000) == 3)
	{
		for (i = 0; i < 45; i++)
		{
			gint size = g_random_int_range(0, 100)*g_random_double_range(0, 1);
			int x = random() % WIDTH;
			int y = random() % HEIGHT;
			
			
			glColor4f(0.0, 0.0,1.0, 1.0);
			glVertex2f(x, y);
			glVertex2f(x, y + size);
			glVertex2f(x + size, y + size);
			glVertex2f(x + size, y);
		}
	}
	glEnd();
	

	glReadBuffer(GL_BACK);
	glCopyTexSubImage2D(GL_TEXTURE_2D,
						0,
						0,
						0,
						0,
						0,
						WIDTH,
						HEIGHT);

	glutSwapBuffers();

	


}

void timer(int unused)
{
	glutPostRedisplay();
	glutTimerFunc(25, timer, 0);
}

void reshape(int w, int h)
{
	glClear(GL_COLOR_BUFFER_BIT);
	glViewport(0, 0, (GLsizei) w, (GLsizei) h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0.0, (GLdouble) w, 0.0, (GLdouble) h);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

void load_shader (void)
{
	gchar * contents;
	
	g_file_get_contents("./life.glsl", &contents, NULL, NULL);
	
	shader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(shader, 1, &contents, NULL);
	free(contents);
	
	glCompileShader(shader);
	
	p = glCreateProgram();
	glAttachShader(p,shader);
	glLinkProgram(p);
	glUseProgram(p);

}

void init (void)
{
	guint i;
	guchar * data = g_malloc0(WIDTH * HEIGHT * 3);

	g_random_set_seed(time(NULL));

	for (i = 0; i < WIDTH * HEIGHT * 3; i+=3)
	{
		gint color = g_random_int_range(0, 2)*255;
		data[i+2] = (guchar)color;
	}

	glBindTexture( GL_TEXTURE_2D, texture );

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, WIDTH, HEIGHT, 0,
				 GL_RGB, GL_UNSIGNED_BYTE, data);
	
	load_shader();
}

int main(int argc, char ** argv)
{
	glutInit(&argc, argv);

    glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowSize (WIDTH, HEIGHT);
	
	glutCreateWindow("Life");

    init();

    glutReshapeFunc (reshape);
	glutDisplayFunc(display);
	glutTimerFunc(20, timer, 0);

    glutMainLoop();
}


