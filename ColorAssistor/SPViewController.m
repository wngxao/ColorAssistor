//
//  StatusPopoverViewController.m
//  ColorAssistor
//
//  Created by wx on 2017/6/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SPViewController.h"

@interface SPViewController ()
@end

@implementation SPViewController
-(void)awakeFromNib{
    _colorPad.layer.borderWidth=2;
    _colorPad.layer.borderColor=[NSColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_rectPalette bind:@"mainColor" toObject:_hbar withKeyPath:@"color" options:nil];
    [self bind:@"color" toObject:_rectPalette withKeyPath:@"color" options:nil];
    [_hbar setColor:[NSColor colorWithRed:1 green:0 blue:0 alpha:1]];
}
-(void)viewWillAppear{
    NSLog(@"viewWillAppear");
}
-(void)viewDidDisappear{
    NSLog(@"viewDidDisappear");
}
-(void)dealloc{
    NSLog(@"dealloc");
}
-(void)setColor:(NSColor *)color{
    if(_color!=color){
        _color=color;
        _colorPad.backgroundColor=color;
        _valBox.fillColor=color;
        NSLog(@"SPViewController#setColor:%@",color);
    }
}
@end
