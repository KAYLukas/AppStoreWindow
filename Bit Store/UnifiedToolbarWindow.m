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
    if(fullscreen){
        return;
    }
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

-(void) _inffFullScreen
{
    fullscreen = YES;
    NSToolbar* tb = [self toolbar];
    [[self toolbar] setDisplayMode: NSToolbarDisplayModeIconAndLabel];
    NSArray* allItems = [tb items];
    if(allItems == nil){
        return;
    }
    BOOL first = YES;
    for(NSToolbarItem* item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            UnifiedToolbarItem *utItem = (UnifiedToolbarItem *)item;
            [[utItem viewDuplicate] removeFromSuperview];
            [utItem setDuplicateAsMainView];
        }
    }
}

-(void) _outFullScreen
{
    fullscreen = NO;
    [[self toolbar]setDisplayMode: NSToolbarDisplayModeIconOnly];
    NSToolbar* tb = [self toolbar];
    NSArray* allItems = [tb items];
    if(allItems == nil){
        return;
    }
    for(NSToolbarItem* item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            UnifiedToolbarItem *utItem = (UnifiedToolbarItem *)item;
            [utItem setOriginalAsMainView];
        }
    }
    [self _layout];
}

-(void) _didFullScreen
{
 /*   NSToolbar*tb = [self toolbar];
    NSArray* allItems = [tb items];
    if(allItems == nil){
        return;
    }
    NSToolbarItem* item = nil;
    for(item in allItems){
        if([item class] == [UnifiedToolbarItem class]){
            break;
        }
    }
    if(item != nil){
        NSView* v = [item view];
        v = [v superview];
        v = [v superview];
        NSArray* toolbarItemViewers = [v subviews];
        CGFloat minY = +INFINITY;
        NSMutableArray* frames = [NSMutableArray new];
        for(NSView* toolbarItemViewer in toolbarItemViewers){
            NSRect frame = toolbarItemViewer.frame;
            minY = MIN(minY, frame.origin.y);
            NSView *v2 = [[toolbarItemViewer subviews] objectAtIndex:0];
            [frames addObject: [NSValue valueWithRect: frame]];
        }
        for(NSView* toolbarItemViewer in toolbarItemViewers){
            NSRect frame = toolbarItemViewer.frame;
            frame.origin.y = 6;
            toolbarItemViewer.frame = frame;
            NSView *v2 = [[toolbarItemViewer subviews] objectAtIndex:0];
            if(![@"" isEqualToString: [[((id)v2) cell] title]]){
                frame.origin.y -= 6;
                toolbarItemViewer.frame = frame;
            }
        }
        v = [v superview];
        NSRect frame = v.frame;
        frame.origin.y -= 12;
        v.frame = frame;
        v = [v superview];
        frame = v.frame;
        frame.origin.y -= 12;
        v.frame = frame;
    }else{
        NSLog(@"Warning! UnifiedToolbarWindow used without a UnifiedToolbarItem. This causes incorrect alignment in the fullscreen scenario");
    }*/
}
@end
