//
//  ScrnImgViewController.m
//  ColorAssistor
//
//  Created by wx on 2017/6/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ColorPickerViewController.h"

@interface ColorPickerViewController ()

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)setCurColor:(NSColor*)color{
    _curColor=color;
    _colorView.fillColor=color;
    _colorTxt.cell.title=[NSString stringWithFormat:@"%02X%02X%02X",(int)(color.redComponent*255),(int)(color.greenComponent*255),(int)(color.blueComponent*255)];
}
@end
