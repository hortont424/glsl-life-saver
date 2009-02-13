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
	IBOutlet NSWindow *configureSheet;
	IBOutlet NSSlider *fpsSlider;
	IBOutlet NSPopUpButton *backgroundSelector;
	IBOutlet NSButton *rectangleMutationBox;
	IBOutlet NSButton *triangleMutationBox;
	IBOutlet NSButton *gliderMutationBox;
	IBOutlet NSColorWell *fromWell;
	IBOutlet NSColorWell *toWell;
	
	GLSLifeView *lifeView;
}

- (void)ok:sender;
- (void)cancel:sender;

@end
