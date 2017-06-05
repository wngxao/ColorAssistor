//
//  ScrnImgViewController.h
//  ColorAssistor
//
//  Created by wx on 2017/6/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface ColorPickerViewController : NSViewController
@property (weak) IBOutlet NSBox *colorView;
@property (weak) IBOutlet NSTextField *colorTxt;
@property (nonatomic) NSColor *curColor;
@end
