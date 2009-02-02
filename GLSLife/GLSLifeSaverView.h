//
//  GLSLifeSaverView.h
//  GLSLife
//
//  Created by Michael Ash on 5/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ScreenSaver/ScreenSaver.h>


@class GLSLifeView;

@interface GLSLifeSaverView : ScreenSaverView
{
	GLSLifeView *lifeView;
}


@end
