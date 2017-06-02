//
//  AppDelegate.m
//  ColorAssistor
//
//  Created by wx on 2017/5/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "SPViewController.h"

@interface AppDelegate ()
@property (strong) NSStatusItem *statusItem;
@property (strong) NSPopover *popover;
@property (strong) NSEvent *monitor;
@end

@interface NSPopover (canBecomeKeyWindow)
@property (readwrite) BOOL canBecomeKeyWindow;
@end

@implementation NSPopover (canBecomeKeyWindow)
-(BOOL)canBecomeKeyWindow{
    return YES;
}
-(void)setCanBecomeKeyWindow:(BOOL)canBecomeKeyWindow{
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.statusItem=[[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image=[NSImage imageNamed:@"StatusIcon"];
    NSSize size=[image size];
    NSLog(@"image size:%f*%f",size.width,size.height);
    [self.statusItem setAction:@selector(clickStatusIcon:)];
    [self.statusItem setTarget:self];
    self.statusItem.image=image;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return NO;
}
-(void)clickStatusIcon:(id)sendor{
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    if(self.popover==nil){
        NSStoryboard* storyboard=[NSStoryboard storyboardWithName:@"Main" bundle:nil];
        SPViewController *spcontroller=[storyboard instantiateControllerWithIdentifier:@"SPViewController"];
        self.popover=[[NSPopover alloc]init];
        [self.popover setContentViewController:spcontroller];
        [self.popover setAnimates:NO];
    }
    if(![self.popover isShown]){
        [self.popover showRelativeToRect:
         [self.popover contentViewController].view.bounds ofView:sendor preferredEdge:(NSMaxXEdge+NSMinXEdge)/2];
        if(self.monitor==nil){
            self.monitor=[NSEvent addGlobalMonitorForEventsMatchingMask:(NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown) handler:^(NSEvent* event){
                self.monitor=nil;
                [self.popover close];
            }];
        }
    }else{
        [self.popover close];
    }
}
@end
