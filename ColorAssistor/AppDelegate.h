//
//  AppDelegate.h
//  ColorAssistor
//
//  Created by wx on 2017/5/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSStatusItem *statusItem;
@property (strong) NSPopover *popover;
@property (strong) NSEvent *monitor;
@property (strong) NSStoryboard *storyboard;
@end

