//
//  ImageButton.m
//  ColorAssistor
//
//  Created by wx on 2017/6/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ImageButton.h"
@interface ImageButton()
@property NSImage *img1;
@property NSImage *img2;
@end
@implementation ImageButton
-(void)viewWillMoveToWindow:(NSWindow *)newWindow{
    self.moded=NO;
    self.img1=[NSImage imageNamed:@"ColorPicker"];
    self.img2=[NSImage imageNamed:@"ColorPicker2"];
}
- (void)drawRect:(NSRect)dirtyRect {
    CGRect drawRect=CGRectMake(5, 5, self.bounds.size.width-10, self.bounds.size.height-10);
    if(![self moded]){
        [[NSColor colorWithWhite:0.6 alpha:1]set];
        [[NSColor colorWithWhite:0.9 alpha:1]setFill];
        NSBezierPath *path=[NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:10 yRadius:10];
        [path fill];
        [path stroke];
        [[self img1]drawInRect:drawRect];
    }else {
        [[NSColor colorWithWhite:0.8 alpha:1]setFill];
        NSBezierPath *path=[NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:10 yRadius:10];
        [path fill];
        [[self img2]drawInRect:drawRect];
    }
}
-(void)setModed:(BOOL)m{
    if(m!=_moded){
        _moded=m;
        [self setNeedsDisplay];
    }
}
//-(BOOL)becomeFirstResponder{
//    NSLog(@"becomeFirstResponder");
//    return YES;
//}
-(void)mouseDown:(NSEvent *)event{
//    [super mouseDown:event];
    if(!_moded)[self setModed:YES];
}
-(void)mouseUp:(NSEvent *)event{}
-(void)mouseDragged:(NSEvent *)event{}
//-(void)setModed:(BOOL)m{
//    @synchronized (self) {
//        if(m==){
//            
//        }
//    }
//}
//-(BOOL)moded{
//    @synchronized (self) {
//        return _moded;
//    }
//}
@end
