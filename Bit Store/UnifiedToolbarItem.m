//
//  UnifiedToolbarItem.m
//  Bit Store
//
//  Created by Kay Lukas on 18-03-14.
//  Copyright (c) 2014 com.gritt. All rights reserved.
//

#import "UnifiedToolbarItem.h"
#import <objc/runtime.h>

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
    
    [imageView setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
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
    if([dup class] == [NSButton class]){
        [dupp setImage:image];
    }
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
    if([dup class] == [NSButton class]){
        [((NSButton*)dup) sizeToFit];
        return dup;
    }else{
        return nil;
    }
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
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[NSColor controlTextColor]range: range];
    //Is correct checked by interspection
    [attrTitle addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]] range:range];
    NSButtonCell*  butCell = [but cell];
    [butCell setBackgroundStyle:NSBackgroundStyleRaised];
    [but setAttributedTitle:attrTitle];
}

-(CGFloat) getLabelWidth{
    if([dup class] == [NSButton class]){
        return [self widthOfString:[self label] withFont:[((NSButton*)dup) font] ] + 4;
    }else{
        return 0;
    }
}

- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat)heightOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}

- (void) setDuplicateAsMainView
{
    NSButton* swap = dup;
    dup = [self view];
    [swap setImagePosition:NSImageOnly];
    [super setView: swap];
    [swap sizeToFit];
    [self setImage:[self image]];
}

- (void) setOriginalAsMainView
{
    NSButton* swap = [self view];
    [swap setImagePosition:NSImageAbove];
    [super setView: dup];
    [swap sizeToFit];
    dup = swap;
    [self setImage:[self image]];
}

@end
