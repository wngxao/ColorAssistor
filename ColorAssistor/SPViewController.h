//
//  StatusPopoverViewController.h
//  ColorAssistor
//
//  Created by wx on 2017/6/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HBar.h"
#import "RectPalette.h"
@interface SPViewController : NSViewController
@property (weak) IBOutlet HBar *hbar;
@property (weak) IBOutlet RectPalette *rectPalette;
@property (nonatomic) NSColor *color;
@property (weak) IBOutlet NSTextField *colorPad;
@property (weak) IBOutlet NSBox *valBox;
@end
