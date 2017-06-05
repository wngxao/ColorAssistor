//
//  RectPalette.h
//  ColorAssistor
//
//  Created by wx on 2017/6/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface RectPalette : NSControl
@property (nonatomic) NSColor* mainColor;
@property (nonatomic) NSColor* color;
-(NSColor*)setColor2:(NSColor*)c;
@end
