//
//  RectPalette.m
//  ColorAssistor
//
//  Created by wx on 2017/6/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RectPalette.h"

@interface RectPalette (){
    CGImageRef image;
    UInt32 *data;
    NSPoint point;
}
@end
@implementation RectPalette
#define CICLE_SIZE (10)
#define BORD_WIDTH (2)
-(void)viewWillMoveToWindow:(NSWindow *)newWindow{
    NSLog(@"viewDidMoveToWindow");
}
- (void)drawRect:(NSRect)dirtyRect {
    CGContextRef ctx=[[NSGraphicsContext currentContext]graphicsPort];
    CGContextDrawImage(ctx, CGRectMake(BORD_WIDTH, BORD_WIDTH, self.frame.size.width-BORD_WIDTH, self.frame.size.height-BORD_WIDTH), image);
    CGContextSetShouldAntialias(ctx, true);
    CGContextAddEllipseInRect(ctx, CGRectMake(point.x- CICLE_SIZE/2, point.y-CICLE_SIZE/2, 10, 10));
    NSLog(@"color:%f",_color.redComponent+_color.greenComponent+_color.blueComponent);
    if(_color.redComponent+_color.greenComponent+_color.blueComponent>=1.5){
        CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1].CGColor);
    }else{
        CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor);
    }
    CGContextClosePath(ctx);
    CGContextSetLineWidth(ctx, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextSetLineWidth(ctx, BORD_WIDTH);
    CGContextAddRect(ctx, CGRectMake(BORD_WIDTH/2, BORD_WIDTH/2, self.frame.size.width-BORD_WIDTH, self.frame.size.height-BORD_WIDTH));
    CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);
    
}
-(void)redraw{
    CGColorSpaceRef colorSpace=CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGFloat w=self.frame.size.width-2*BORD_WIDTH,h=self.frame.size.height-2*BORD_WIDTH;
    int bytesPerRow=4*w;
    int bytesCount=bytesPerRow*h;
    if(!data)data=malloc(bytesCount);
    if(image)CGImageRelease(image);
    int r=_mainColor.redComponent*255,g=_mainColor.greenComponent*255,b=_mainColor.blueComponent*255;
    if(data){
        for(int i=0;i<h;i++){
            for(int j=0;j<w;j++){
                int mR=r-i*r/(h-1);
                int mG=g-i*g/(h-1);
                int mB=b-i*b/(h-1);
                int mMax=mR>=mG&&mR>=mB?mR:(mG>=mR&&mG>=mB?mG:mB);
                mR=mR+(w-(j+1))*(mMax-mR)/(w-1);
                mG=mG+(w-(j+1))*(mMax-mG)/(w-1);
                mB=mB+(w-(j+1))*(mMax-mB)/(w-1);
                data[(int)(i*w+j)]=(0xff000000|(mR)|(mG<<8)|(mB<<16));
            }
        }
        CGContextRef cgctx = CGBitmapContextCreate(data, w, h, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
        if(cgctx){
            image=CGBitmapContextCreateImage(cgctx);
            CGContextRelease(cgctx);
        }
    }
    CGColorSpaceRelease(colorSpace);
}
-(void)setMainColor:(NSColor *)color{
    if(_mainColor!=color){
        _mainColor=color;
        [self redraw];
        NSLog(@"RectPalette#setMainColor:%@",color);
        if(!_color){
            point = NSMakePoint(self.frame.size.width-BORD_WIDTH, self.frame.size.height-BORD_WIDTH);
        }
        NSColor *color2=[self colorOfPoint:point];
        [self setColor:color2];
    }
}
-(void)setColor:(NSColor *)color{
    if(_color!=color){
        _color=color;
        [self setNeedsDisplay];
        NSLog(@"RectPalette#setColor:%@",color);
    }
}
-(void)dealloc{
    NSLog(@"rect palette dealloc");
}
-(void)mouseUp:(NSEvent *)event{
    [self mouseDragged:event];
}
-(void)mouseDown:(NSEvent *)event{
    [self mouseDragged:event];
}
-(void)mouseDragged:(NSEvent *)event{
    point=[event locationInWindow];
    NSView *tmp=self;
    while (tmp) {
        NSPoint point2=tmp.frame.origin;
        point.x=point.x-point2.x;
        point.y=point.y-point2.y;
        tmp=tmp.superview;
    }
    if(point.y<BORD_WIDTH)point.y=BORD_WIDTH;
    if(point.y>self.frame.size.height-BORD_WIDTH)point.y=self.frame.size.height-BORD_WIDTH;
    if(point.x<BORD_WIDTH)point.x=BORD_WIDTH;
    if(point.x>self.frame.size.width-BORD_WIDTH)point.x=self.frame.size.width-BORD_WIDTH;
    NSColor *color=[self colorOfPoint:point];
    [self setColor:color];
}
-(id)colorOfPoint:(NSPoint)pt{
    CGFloat x=pt.x-BORD_WIDTH,y=pt.y-BORD_WIDTH;
    CGFloat w=self.frame.size.width-2*BORD_WIDTH,h=self.frame.size.height-2*BORD_WIDTH;
    NSColor* color;
    int r=_mainColor.redComponent*255,g=_mainColor.greenComponent*255,b=_mainColor.blueComponent*255;
    float mR=r-(h-y)*r/h;
    float mG=g-(h-y)*g/h;
    float mB=b-(h-y)*b/h;
    float mMax=mR>=mG&&mR>=mB?mR:(mG>=mR&&mG>=mB?mG:mB);
    mR=mR+(w-x)*(mMax-mR)/w;
    mG=mG+(w-x)*(mMax-mG)/w;
    mB=mB+(w-x)*(mMax-mB)/w;
    color=[NSColor colorWithRed:mR/255 green:mG/255 blue:mB/255 alpha:1];
    return color;
}

@end
