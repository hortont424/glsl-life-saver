//
//  GLSLifeView.m
//  GLSLife
//
//  Created by Michael Ash on 5/12/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "GLSLifeView.h"

#include <OpenGL/gl.h>
#include <OpenGL/glext.h>
#include <OpenGL/glu.h>

#include <mach/mach_time.h>

@implementation GLSLifeView

char * lifeShader = "uniform sampler2D Tex;"

"uniform float WIDTH;"
"uniform float HEIGHT;"

"const float colorstep =  1.0 / 256.0;"

"void main(void)"
"{"
"	float ones = 1.0 / WIDTH;"
"	float onet = 1.0 / HEIGHT;"

"	vec2 others[8];"
"	others[0] = vec2(0.0,onet);	"
"	others[1] = vec2(ones,onet);	"
"	others[2] = vec2(ones,0.0);	"
"	others[3] = vec2(ones,-onet);	"
"	others[4] = vec2(0.0,-onet);	"
"	others[5] = vec2(-ones,-onet);	"
"	others[6] = vec2(-ones,0.0);	"
"	others[7] = vec2(-ones,onet);	"

"	int neighbours = 0;"
"	int i;"

"	if ( texture2D(Tex, gl_TexCoord[0].st+others[0]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[1]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[2]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[3]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[4]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[5]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[6]).b > 0.9)"
"		neighbours ++;"
"	if ( texture2D(Tex, gl_TexCoord[0].st+others[7]).b > 0.9)"
"		neighbours ++;"

"	vec4 color = texture2D(Tex, gl_TexCoord[0].st);"

"	if (color.b > 0.9)"
"	{"
"		if (neighbours < 2 || neighbours > 3)		"
"			color = vec4(0.0, 0.0, 0.8, 1.0);		"
"		else if (color.b > 0.0)						"
"			color.b = color.b - colorstep;	"
"	}"
"	else"
"	{"
"		if (neighbours == 3)						"
"			color = vec4( 0.0, 0.0 , 1.0, 1.0);		"
"		else if (color.b > 0.0)"
"			color.b = color.b - colorstep;"
"	}"


"	if (color.b < 1.0)"
"	{"
"		color.r = (float(gl_TexCoord[0].r)/1.5) + float(neighbours)/16.0;"
"		color.g = ((1.0-gl_TexCoord[0].r)/1.5) + float(neighbours)/16.0;"
"	}"
"	if (neighbours == 1)"
"	{"
"		if (gl_TexCoord[0].s < 0.5)"
"			color.r = 1.0-gl_TexCoord[0].r;"
"		else"
"			color.g = gl_TexCoord[0].r - 0.2;"
"	}"

"	gl_FragColor = color;"
"}";

+ (void)initialize
{
	srandomdev();
}

- (id)initWithFrame:(NSRect)frame
{
	NSOpenGLPixelFormatAttribute attribs[] = { NSOpenGLPFADoubleBuffer, 0 };
	NSOpenGLPixelFormat *myFormat = [[NSOpenGLPixelFormat alloc]
									 initWithAttributes:attribs];
	
	self = [super initWithFrame:frame pixelFormat:myFormat];
	[myFormat release];
	
	if (self)
	{
		
	}
	
	return self;
}

- (void)dealloc
{
	glDeleteTextures(1, &tex);
	glDeleteProgramsARB(1, &shader);
	
	[super dealloc];
}

- (void)createTexture
{
	uint32_t *data = malloc(xsize * ysize * sizeof(*data));

	int i;
	for(i = 0; i < xsize * ysize; i++)
		data[i] = (random() % 100) >= 20 ? 0 : 0xFFFFFFFFUL;
	
	glBindTexture(GL_TEXTURE_2D, tex);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, [self bounds].size.width,
				 [self bounds].size.height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
	
	free(data);
}

- (void)loadShader
{
	const char *sourceC = strdup(lifeShader);
	
	shader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(shader, 1, &sourceC, NULL);
	glCompileShader(shader);
	
	p = glCreateProgram();
	
	glAttachShader(p, shader);
	glLinkProgram(p);
	glUseProgram(p);
	
	widthLoc = glGetUniformLocation(p, "WIDTH");
	heightLoc = glGetUniformLocation(p, "HEIGHT");
}

- (void)reshape
{
	if(!inited)
	{
		xsize = [self bounds].size.width;
		ysize = [self bounds].size.height;
		
		[self createTexture];
		[self loadShader];
		
		inited = YES;
		
		[NSTimer scheduledTimerWithTimeInterval:1/60.0
										 target:self
									   selector:@selector(timer)
									   userInfo:NULL
										repeats:YES];
	}
	
	glUniform1f(widthLoc, xsize);
	glUniform1f(heightLoc, ysize);
	
	glClear(GL_COLOR_BUFFER_BIT);
	glViewport(0, 0, [self bounds].size.width, [self bounds].size.height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0.0, [self bounds].size.width, 0.0, [self bounds].size.height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

- (void)timer
{
	[self setNeedsDisplay:YES];
}

- (void)drawTexture
{
	glUseProgram(p);
	
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, tex);
	
	glBegin(GL_QUADS);
	glTexCoord2f(0.0, 0.0);
	glVertex2f(0.0, 0.0);
	glTexCoord2f(1, 0.0);
	glVertex2f([self bounds].size.width, 0.0);
	glTexCoord2f(1,1);
	glVertex2f([self bounds].size.width, [self bounds].size.height);
	glTexCoord2f(0, 1);
	glVertex2f(0.0, [self bounds].size.height);
	glEnd();
	
	glDisable(GL_TEXTURE_2D);
	
	glUseProgram(0);
	
	glBegin(GL_TRIANGLES);
	if((rand() % 100) == 50)
	{
		int x = random() % xsize;
		int y = random() % ysize;
		
		glColor4f(0.0, 0.0, 1.0, 1.0);
		glVertex2f(x, y);
		glVertex2f(x, y + 80);
		glVertex2f(x + 80, y + 80);
	}
	glEnd();
	
	
	glReadBuffer(GL_BACK);
	glCopyTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, 0, 0,
						[self bounds].size.width, [self bounds].size.height);
}

- (void)step
{
	[self drawTexture];
	
	glReadBuffer(GL_BACK);
	glCopyTexSubImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, 0, 0, 0, 0, xsize, ysize);
}

- (void)drawRect:(NSRect)rect
{
	[self step];
	
	[[self openGLContext] flushBuffer];
	
}

@end
