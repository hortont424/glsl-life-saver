//
//  GLSLifeSaverView.m
//  GLSLife
//
//  Created by Michael Ash on 5/13/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "GLSLifeSaverView.h"
#import "GLSLifeView.h"

@implementation GLSLifeSaverView

+ (void)initialize
{

}

- (void)reinitLifeView
{
	[lifeView removeFromSuperview];
	[lifeView release];
	
	lifeView = [[GLSLifeView alloc] initWithFrame:[self bounds]];
		
	[self addSubview:lifeView];
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		[self reinitLifeView];
    }
    return self;
}

- (void)dealloc
{
	[lifeView release];
	[super dealloc];
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
}

- (void)animateOneFrame
{
	[lifeView display];
}

- (BOOL)hasConfigureSheet
{
	return YES;
}

- (NSWindow*)configureSheet
{
    if(!configureSheet)
	{
		[NSBundle loadNibNamed:@"Screensaver" owner:self];
	}
	
	NSLog(@"configureSheet : %@", configureSheet);
	
	return configureSheet;
}

- (void)ok:sender
{
	[NSApp endSheet:configureSheet];
	
	[[NSColorPanel sharedColorPanel] orderOut:nil];
}

- (void)cancel:sender
{
	[NSApp endSheet:configureSheet];
	
	[[NSColorPanel sharedColorPanel] orderOut:nil];
}

@end
