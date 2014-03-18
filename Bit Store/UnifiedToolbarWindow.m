//
//  UnifiedToolbarWindow.m
//  Bit Store
//
//  Created by Kay Lukas on 18-03-14.
//  Copyright (c) 2014 com.gritt. All rights reserved.
//

#define TOOLBARADJUST 6;
#import "UnifiedToolbarWindow.h"
#import "UnifiedToolbarItem.h"
#import <Foundation/Foundation.h>

@implementation UnifiedToolbarWindow


@synthesize title;

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    fullscreen = NO;
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		[self _doInitialWindowSetup];
	}
	return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
		[self _doInitialWindowSetup];
	}
	return self;
}

- (void) _doInitialWindowSetup
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(_layout) name:NSWindowDidResizeNotification object:self];
	[nc addObserver:self selector:@selector(_layout) name:NSWindowDidEndSheetNotification object:self];
    [nc addObserver:self selector:@selector(_inffFullScreen) name:NSWindowWillEnterFullScreenNotification object:self];
    [nc addObserver:self selector:@selector(_outFullScreen) name:NSWindowWillExitFullScreenNotification object:self];
    [nc addObserver:self selector:@selector(_didFullScreen) name:NSWindowDidEnterFullScreenNotification object:self];
    [[self toolbar]setDisplayMode:NSToolbarDisplayModeIconOnly];
    [self _layout];
}

- (void) setTitle:(NSString *)aString
{
    title = aString;
}

- (NSString*) title
{
    return title;
}

-(void) _layout
{
    [[self toolbar]setDisplayMode:NSToolbarDisplayModeIconOnly];
    [[self toolbar]setAllowsUserCustomization:NO];
    NSToolbar* tb = [self toolbar];
    NSArray* items = [tb visibleItems];
    NSArray* allItems = [tb items];
    if(items == nil){
        return;
    }
    for(NSToolbarItem* item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            UnifiedToolbarItem *utItem = (UnifiedToolbarItem*) item;
            if(fullscreen){
                NSSize size = [utItem image].size;
                size.height += 6;
                [utItem setMinSize:size];
                [utItem setMaxSize:size];
            }else{
                [utItem setImage: [utItem image]];
            }
            NSView* backingView = [item view];
            NSRect frameRelWindow = [backingView convertRect:backingView.bounds toView:nil];
            NSView * viewCopy = [utItem viewDuplicate];
            frameRelWindow.size = viewCopy.frame.size;
            [viewCopy removeFromSuperview];
            if([items containsObject:item]){
                NSView* topView = [self getTopView:backingView];
                viewCopy.frame = NSMakeRect(frameRelWindow.origin.x,
                                            topView.frame.size.height - frameRelWindow.size.height - (fullscreen ?  6 : 10),
                                            frameRelWindow.size.width, frameRelWindow.size.height);
                [topView addSubview: viewCopy];
            }
        }
    }
    
}

-(NSView*) getTopView: (NSView*) childView
{
    NSView* parent;
    while((parent = [childView superview])){
        childView = parent;
    }
    return childView;
}

-(void) _inffFullScreen
{
    fullscreen = YES;
}

-(void) _outFullScreen
{
    fullscreen = NO;
}

-(void) _didFullScreen
{
    [self _layout];
}
@end
