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

@implementation UnifiedToolbarWindow


@synthesize title;

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
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
    [nc addObserver:self selector:@selector(_unFocus) name:NSWindowDidResignMainNotification object:self];
    [nc addObserver:self selector:@selector(_focus) name:NSWindowDidBecomeMainNotification object:self];
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
    NSImageView* view = nil;
    for(NSToolbarItem* item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            UnifiedToolbarItem *utItem = (UnifiedToolbarItem*) item;
            NSView* backingView = [item view];
            NSRect frameRelWindow = [backingView convertRect:backingView.bounds toView:nil];
            NSView * viewCopy = [utItem viewDuplicate];
            frameRelWindow.size = viewCopy.frame.size;
            [viewCopy removeFromSuperview];
            if([items containsObject:item]){
                NSView* themeView = [self.contentView superview];
                viewCopy.frame = NSMakeRect(frameRelWindow.origin.x,
                                            self.frame.size.height - frameRelWindow.size.height - 10,
                                            frameRelWindow.size.width, frameRelWindow.size.height);
                [themeView addSubview: viewCopy];
            }
        }
    }
    
}

-(void) _unFocus{
    NSLog(@"unFocus");
    NSToolbar* tb = [self toolbar];
    NSArray* allItems = [tb items];
    if(allItems == nil){
        return;
    }
    NSImageView* view = nil;
    for(NSToolbarItem* item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            UnifiedToolbarItem *utItem = (UnifiedToolbarItem*) item;
            utItem.windowFocus = NO;
        }
    }
    [self _layout];
}

-(void) _focus{
    NSLog(@"focus");
    NSToolbar* tb = [self toolbar];
    NSArray* allItems = [tb items];
    if(allItems == nil){
        return;
    }
    NSImageView* view = nil;
    for(NSToolbarItem* item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            UnifiedToolbarItem *utItem = (UnifiedToolbarItem*) item;
            utItem.windowFocus = YES;
        }
    }
    [self _layout];
}
@end
