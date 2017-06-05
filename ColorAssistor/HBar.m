//
//  CPalette.m
//  ColorAssistor
//
//  Created by wx on 2017/6/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HBar.h"
@interface HBar (){
    CGImageRef image;
    UInt32 *data;
}
@end
@implementation HBar
#define ARROW_SIZE (8)
#define BORD_WIDTH (2)
CGFloat mY=ARROW_SIZE/2;
- (void)drawRect:(NSRect)dirtyRect {
    CGFloat w=self.bounds.size.width;
    CGFloat h=self.bounds.size.height;
    CGContextRef ctx=[[NSGraphicsContext currentContext]graphicsPort];
    CGContextDrawImage(ctx, CGRectMake(ARROW_SIZE, ARROW_SIZE/2, w-2*ARROW_SIZE, h-ARROW_SIZE), image);
    CGContextSetLineWidth(ctx, BORD_WIDTH);
    CGContextAddRect(ctx, CGRectMake(ARROW_SIZE-BORD_WIDTH/2, ARROW_SIZE/2-BORD_WIDTH/2, self.frame.size.width+BORD_WIDTH-2*ARROW_SIZE, self.frame.size.height+BORD_WIDTH-ARROW_SIZE));
    CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextSetFillColorWithColor(ctx, [NSColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1].CGColor);
    CGContextMoveToPoint(ctx, 0, mY-ARROW_SIZE/2);
    CGContextAddLineToPoint(ctx, ARROW_SIZE, mY);
    CGContextAddLineToPoint(ctx,0, mY+ARROW_SIZE/2);
    CGContextAddLineToPoint(ctx, 0, mY-ARROW_SIZE/2);
    CGContextClosePath(ctx);
    CGContextMoveToPoint(ctx, w, mY-ARROW_SIZE/2);
    CGContextAddLineToPoint(ctx, w, mY+ARROW_SIZE/2);
    CGContextAddLineToPoint(ctx, w-ARROW_SIZE, mY);
    CGContextAddLineToPoint(ctx, w, mY-ARROW_SIZE/2);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [NSColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1].CGColor);
    CGContextMoveToPoint(ctx, ARROW_SIZE/2, mY);
    CGContextAddLineToPoint(ctx, w-ARROW_SIZE/2, mY);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx,kCGPathFillStroke);
}
-(void)viewWillDraw{
    CGColorSpaceRef colorSpace=CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGFloat w=self.frame.size.width,h=self.frame.size.height;
    int bytesPerRow=4*w;
    int bytesCount=bytesPerRow*h;
    if(!data)data=malloc(bytesCount);
    if(image)CGImageRelease(image);
    if(data){
        for(int i=1;i<=h;i++){
            if(h-i<h/6){
                for(int j=0;j<w;j++){
                    data[(int)((i-1)*w+j)]=0xff0000ff+((((UInt32)((h-i)*6*255/h))<<8)&0xff00);
                }
            }else if((h-i)>=h/6&&(h-i)<h/3){
                for(int j=0;j<w;j++){
                    data[(int)((i-1)*w+j)]=0xff00ffff-((((UInt32)(((h-i)-h/6)*6*255/h)))&0xff);
                }
            }else if((h-i)>=h/3&&(h-i)<h/2){
                for(int j=0;j<w;j++){
                    data[(int)((i-1)*w+j)]=0xff00ff00+((((UInt32)(((h-i)-h/3)*6*255/h))<<16)&0xff0000);
                }
            }else if((h-i)>=h/2&&(h-i)<h*2/3){
                for(int j=0;j<w;j++){
                    data[(int)((i-1)*w+j)]=0xffffff00-((((UInt32)(((h-i)-h/2)*6*255/h))<<8)&0xff00);
                }
            }else if((h-i)>=h*2/3&&(h-i)<h*5/6){
                for(int j=0;j<w;j++){
                    data[(int)((i-1)*w+j)]=0xffff0000+((((UInt32)(((h-i)-h*2/3)*6*255/h)))&0xff);
                }
            }else{
                for(int j=0;j<w;j++){
                    data[(int)((i-1)*w+j)]=0xffff00ff-((((UInt32)(((h-i)-h*5/6)*6*255/h))<<16)&0xff0000);
                }
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
-(void)dealloc{
    NSLog(@"dealloc");
}
-(void)mouseUp:(NSEvent *)event{
    [self mouseDragged:event];
}
-(void)mouseDown:(NSEvent *)event{
    [self mouseDragged:event];
}
-(void)mouseDragged:(NSEvent *)event{
    NSPoint point=[event locationInWindow];
    NSView *tmp=self;
    while (tmp) {
        NSPoint point2=tmp.frame.origin;
        point.x=point.x-point2.x;
        point.y=point.y-point2.y;
        tmp=tmp.superview;
    }
    mY=point.y;
    if(mY<ARROW_SIZE/2){
        mY=ARROW_SIZE/2;
    }
    if(mY>self.frame.size.height-ARROW_SIZE/2){
        mY=self.frame.size.height-ARROW_SIZE/2;
    }
    NSColor *color=[self colorOfPoint:point];
    [self setColor:color];
    [self.window makeFirstResponder:self];
    [super mouseDown:event];
}
-(id)colorOfPoint:(NSPoint)point{
    CGFloat y=point.y-ARROW_SIZE/2;
    CGFloat h=self.frame.size.height-ARROW_SIZE;
    NSColor* color;
    if(y<0)y=0;
    if(y>h)y=h;
    if(y<h/6){
        color=[NSColor colorWithRed:1 green:(y*6*255/h)/255 blue:0 alpha:1];
    }else if(y>=h/6&&y<h/3){
        color=[NSColor colorWithRed:(255-(y-h/6)*6*255/h)/255 green:1 blue:0 alpha:1];
    }else if(y>=h/3&&y<h/2){
        color=[NSColor colorWithRed:0 green:1 blue:((y-h/3)*6*255/h)/255 alpha:1];
    }else if(y>=h/2&&y<h*2/3){
        color=[NSColor colorWithRed:0 green:(255-(y-h/2)*6*255/h)/255 blue:1 alpha:1];
    }else if(y>=h*2/3&&y<h*5/6){
        color=[NSColor colorWithRed:((y-h*2/3)*6*255/h)/255 green:0 blue:1 alpha:1];
    }else{
        color=[NSColor colorWithRed:1 green:0 blue:(255-(y-h*5/6)*6*255/h)/255 alpha:1];
    }
    return color;
}
-(NSPoint)pointOfColor:(NSColor*)c{
    NSPoint point;
    CGFloat h=self.frame.size.height-ARROW_SIZE;
    point.x=0;
    if(c.redComponent==1&&c.blueComponent==0){
        point.y=ARROW_SIZE/2+h/6*c.greenComponent;
    }else if(c.greenComponent==1&&c.blueComponent==0){
        point.y=ARROW_SIZE/2+h/3-h/6*c.redComponent;
    }else if(c.greenComponent==1&&c.redComponent==0){
        point.y=ARROW_SIZE/2+h/3+h/6*c.blueComponent;
    }else if(c.blueComponent==1&&c.redComponent==0){
        point.y=ARROW_SIZE/2+h*2/3-h/6*c.greenComponent;
    }else if(c.blueComponent==1&&c.greenComponent==0){
        point.y=ARROW_SIZE/2+h*2/3+h/6*c.redComponent;
    }else{
        point.y=ARROW_SIZE/2+h-h/6*c.blueComponent;
    }
    return point;
}
-(void)setColor:(NSColor *)color{
    if(_color!=color){
        _color=color;
        mY = [self pointOfColor:color].y;
        [self setNeedsDisplay];
    }
}
@end
