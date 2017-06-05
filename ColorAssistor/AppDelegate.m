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
    NSImage *image=[NSImage imageNamed:@"StatusIcon"];NSLog(@"image:%f %f",image.size.width,image.size.height);
    [self.statusItem setAction:@selector(clickStatusIcon:)];
    [self.statusItem setTarget:self];
    self.statusItem.image=image;
}
-(void)applicationDidBecomeActive:(NSNotification *)notification{
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return NO;
}
-(void)clickStatusIcon:(id)sendor{
    if(self.popover==nil){
        _storyboard=[NSStoryboard storyboardWithName:@"Main" bundle:nil];
        SPViewController *spcontroller=[_storyboard instantiateControllerWithIdentifier:@"SPViewController"];
        self.popover=[[NSPopover alloc]init];
        [self.popover setContentViewController:spcontroller];
        [self.popover setAnimates:NO];
    }
    if(![self.popover isShown]){
        [self.popover showRelativeToRect:
         [self.popover contentViewController].view.bounds ofView:sendor preferredEdge:(NSMaxXEdge+NSMinXEdge)/2];    }else{
        [self.popover close];
    }
}
@end
