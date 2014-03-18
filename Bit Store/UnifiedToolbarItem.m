//
//  UnifiedToolbarItem.m
//  Bit Store
//
//  Created by Kay Lukas on 18-03-14.
//  Copyright (c) 2014 com.gritt. All rights reserved.
//

#import "UnifiedToolbarItem.h"

@interface NSToolbarItem ()
- (id) initWithCoder: (NSCoder*) aDecoder;
@end

@implementation UnifiedToolbarItem


@synthesize windowFocus;

- (id)initWithItemIdentifier:(NSString *)itemIdentifier{
    id result = [super initWithItemIdentifier:itemIdentifier];
    
    NSButton* imageView;
    if(result == self){
        [super setView:[[NSView alloc] init]];
        imageView = [[NSButton alloc] init];
        [self setView:imageView];
    }
    [imageView setBordered:NO];
    [imageView setButtonType:NSMomentaryChangeButton];
    [imageView setImagePosition:NSImageAbove];
    return result;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    id result = [super initWithCoder: aDecoder];
    if(result == self){
        if([self image] != nil){
            [self setImage: [self image]];
        }
    }
    return self;
}

-(void) setImage:(NSImage *)image{
    id dupp = dup;
    NSSize size = [image size];
    size.width = MAX(size.width, [self getLabelWidth]);
    [self setMinSize: size];
    [self setMaxSize: size];
    [dupp setImage:image];
    NSRect frame = [[self view] frame];
    frame.size = size;
    NSRect bounds = [[self view] bounds];
    bounds.size = size;
    [[self view] setFrame: frame];
    [[self view] setBounds: bounds];
    [super setImage: image];
}

- (void) setView:(NSView *)view
{
    dup = view;
}

-(NSView*) viewDuplicate{
    [((NSButton*)dup) sizeToFit];
    return dup;
}

-(void) setWindowFocus:(BOOL)windowFocuss
{
    windowFocus = windowFocuss;
    [self setLabel:[self label]];
}

-(void) setLabel:(NSString *)alabel{
    [super setLabel:alabel];
    NSButton* but = (NSButton *)dup;
    NSMutableAttributedString *attrTitle =
    [[NSMutableAttributedString alloc] initWithString:alabel];
    unsigned long len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    if(windowFocus){
        NSLog(@"item has focus");
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:52/255.0 green:52/255.0 blue: 52/255.0 alpha:1] range:range];
    }else{
        NSLog(@"item has no focus");
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:87/255.0 green:87/255.0 blue: 87/255.0 alpha:1] range:range];
    }
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont controlContentFontOfSize:[NSFont smallSystemFontSize]] range:range];
    [attrTitle fixAttributesInRange:range];
    [but setAttributedTitle:attrTitle];
}

-(CGFloat) getLabelWidth{
    return [self widthOfString:[self label] withFont:[((NSButton*)dup) font] ] + 5;
}

- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat)heightOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}


@end
