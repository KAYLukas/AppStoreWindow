//
//  UnifiedToolbarItem.h
//  Bit Store
//
//  Created by Kay Lukas on 18-03-14.
//  Copyright (c) 2014 com.gritt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UnifiedToolbarItem : NSToolbarItem{
    NSView* dup;
}

- (NSView*) viewDuplicate;
@end
