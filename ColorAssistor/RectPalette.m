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
-(NSColor*)setColor2:(NSColor*)c{
    CGFloat r=c.redComponent,g=c.greenComponent,b=c.blueComponent;
    CGFloat max=r>g?(r>b?r:b):(g>b?g:b),min=r>g?(g<b?g:b):(r>b?b:r),mid=r>b?(b>g?b:(r>g?g:r)):(b<g?b:(r>g?r:g));
    // (mid-max*x)/(max-max*x)=min/max
    // min-min*x=mid-max*x x=(mid-min)/(max-min)
    CGFloat w=self.frame.size.width-2*BORD_WIDTH,h=self.frame.size.height-2*BORD_WIDTH;
    if(max==min){
        point.x=BORD_WIDTH;
        point.y=BORD_WIDTH+min*h;
        [self setColor:c];
        return [NSColor colorWithRed:_mainColor.redComponent green:_mainColor.greenComponent blue:_mainColor.blueComponent alpha:1];
    }
    CGFloat mmax=1,mmid=(mid-min)/(max-min),mmin=0;
    point.y=max*h+BORD_WIDTH;
    point.x=w-min/max*w+BORD_WIDTH;
    [self setColor:c];
    NSColor *mColor;
    if(r==max&&g==min){
        mColor = [NSColor colorWithRed:mmax green:mmin blue:mmid alpha:1];
    }else if(r==max&&b==min){
        mColor = [NSColor colorWithRed:mmax green:mmid blue:mmin alpha:1];
    }else if(g==max&&b==min){
        mColor = [NSColor colorWithRed:mmid green:mmax blue:mmin alpha:1];
    }else if(g==max&&r==min){
        mColor = [NSColor colorWithRed:mmin green:mmax blue:mmid alpha:1];
    }else if(b==max&&r==min){
        mColor = [NSColor colorWithRed:mmin green:mmid blue:mmax alpha:1];
    }else{
        mColor = [NSColor colorWithRed:mmid green:mmin blue:mmax alpha:1];
    }
    return mColor;
}
-(void)setMainColor:(NSColor *)color{
    if(_mainColor!=color){
        _mainColor=color;
        [self redraw];
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
    }
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
    [self.window makeFirstResponder:self];
    [super mouseDown:event];
}
-(id)colorOfPoint:(NSPoint)pt{
    CGFloat x=pt.x-BORD_WIDTH,y=pt.y-BORD_WIDTH;    CGFloat w=self.frame.size.width-2*BORD_WIDTH,h=self.frame.size.height-2*BORD_WIDTH;
    NSColor* color;
    CGFloat r=_mainColor.redComponent,g=_mainColor.greenComponent,b=_mainColor.blueComponent;
    CGFloat mR=r-(h-y)*r/h;
    CGFloat mG=g-(h-y)*g/h;
    CGFloat mB=b-(h-y)*b/h;
    CGFloat mMax=mR>=mG&&mR>=mB?mR:(mG>=mR&&mG>=mB?mG:mB);
    mR=mR+(w-x)*(mMax-mR)/w;
    mG=mG+(w-x)*(mMax-mG)/w;
    mB=mB+(w-x)*(mMax-mB)/w;
    color=[NSColor colorWithRed:mR green:mG blue:mB alpha:1];
    return color;
}
@end
