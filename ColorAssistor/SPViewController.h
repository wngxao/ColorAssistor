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
#import "ColorTextField.h"
#import "RGBValTextField.h"
#import "ImageButton.h"
#import "ColorPickerViewController.h"
@interface SPViewController : NSViewController <NSTextDelegate,NSPopoverDelegate>
@property (nonatomic,copy) NSString *rStr;
@property (nonatomic,copy) NSString *gStr;
@property (nonatomic,copy) NSString *bStr;
@property (nonatomic,copy) NSString *hexStr;
@property (weak) IBOutlet HBar *hbar;
@property (weak) IBOutlet RectPalette *rectPalette;
@property (weak) IBOutlet NSButton *cpColor;
@property (nonatomic) NSColor *color;
@property (weak) IBOutlet NSBox *valBox;
@property RGBValTextField *valR;
@property RGBValTextField *valG;
@property RGBValTextField *valB;
@property (weak) IBOutlet ImageButton *pickColor;
@property ColorTextField *valHex;
@property (weak) IBOutlet NSBox *hexValBox;
@property (weak) IBOutlet NSBox *rgbValBox;
-(IBAction)cpColorVal:(id)sender;
@property (weak) IBOutlet NSImageView *screenImg;
@property (strong) NSWindowController *colorPickerWindowController;
@property (weak) ColorPickerViewController *colorPickerViewController;
@end
