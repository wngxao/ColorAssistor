//
//  FlatButton.m
//  ColorAssistor
//
//  Created by wx on 2017/5/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RPalette.h"

@implementation RPalette

- (void)drawRect:(NSRect)dirtyRect {
//    CGContextRef ctx=(CGContextRef)[[NSGraphicsContext currentContext]graphicsPort];
//    CGContextSetRGBFillColor(ctx, 100, 100, 100, 255);
//    CGContextFillRect(ctx, NSRectToCGRect(dirtyRect));
    // Drawing code here.
    [[NSColor greenColor]set];
    [NSBezierPath fillRect:dirtyRect];
    
}
-(void)viewWillDraw{
    NSRect frame=[self frame];
    NSLog(@"view size %f*%f",frame.size.width,frame.size.height);
}
-(void)viewDidHide{
    NSLog(@"view hide");
}
-(void)viewDidUnhide{
    NSLog(@"view unhide");
}
@end
