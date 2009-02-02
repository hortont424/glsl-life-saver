//
//  GLSLifeView.h
//  GLSLife
//
//  Created by Michael Ash on 5/12/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface GLSLifeView : NSOpenGLView
{
	BOOL inited;
	GLuint tex;
	GLuint shader, p;
	GLuint widthLoc, heightLoc;
	int xsize, ysize;

	int numFrames;
	double lastClock;
}
@end
