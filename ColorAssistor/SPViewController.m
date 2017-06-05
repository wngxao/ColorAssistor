//
//  StatusPopoverViewController.m
//  ColorAssistor
//
//  Created by wx on 2017/6/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SPViewController.h"
#import "AppDelegate.h"
@interface SPViewController ()
@property (weak) AppDelegate *delegate;
@property NSImage* bufImg;
@end

@implementation SPViewController
-(void)awakeFromNib{}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_rectPalette bind:@"mainColor" toObject:_hbar withKeyPath:@"color" options:nil];
    [self bind:@"color" toObject:_rectPalette withKeyPath:@"color" options:nil];
    _valHex=[[ColorTextField alloc]initWithFrame:NSMakeRect(35, 1, 65, 20)];
    [_valHex setFieldEditor:YES];
    NSMutableParagraphStyle *pstyle=[[NSMutableParagraphStyle alloc]init];
    pstyle.alignment=NSTextAlignmentCenter;
    pstyle.maximumLineHeight=17;
    pstyle.minimumLineHeight=17;
    _valHex.defaultParagraphStyle=pstyle;
    _valHex.backgroundColor=[NSColor colorWithWhite:0 alpha:0];
    _valHex.font=[NSFont systemFontOfSize:13];
    _valHex.textColor=[NSColor colorWithWhite:0.3 alpha:1];
    [_hexValBox addSubview:_valHex];
    _valR=[[RGBValTextField alloc]initWithFrame:NSMakeRect(15, 1, 35, 20)];
    [_valR setFieldEditor:YES];
    _valR.defaultParagraphStyle=pstyle;
    _valR.backgroundColor=[NSColor colorWithWhite:0 alpha:0];
    _valR.font=_valHex.font;
    _valR.textColor=[NSColor colorWithWhite:0.3 alpha:1];
    [_valR setRichText:false];
    [_rgbValBox addSubview:_valR];
    _valG=[[RGBValTextField alloc]initWithFrame:NSMakeRect(65, 1, 35, 20)];
    [_valG setFieldEditor:YES];
    _valG.defaultParagraphStyle=pstyle;
    _valG.backgroundColor=[NSColor colorWithWhite:0 alpha:0];
    _valG.font=_valHex.font;
    _valG.textColor=[NSColor colorWithWhite:0.3 alpha:1];
    [_valG setRichText:false];
    [_rgbValBox addSubview:_valG];
    _valB=[[RGBValTextField alloc]initWithFrame:NSMakeRect(115, 1, 35, 20)];
    [_valB setFieldEditor:YES];
    _valB.defaultParagraphStyle=pstyle;
    _valB.backgroundColor=[NSColor colorWithWhite:0 alpha:0];
    _valB.font=_valHex.font;
    _valB.textColor=[NSColor colorWithWhite:0.3 alpha:1];
    [_valB setRichText:false];
    [_rgbValBox addSubview:_valB];
    [_hbar setColor:[NSColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_valR];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_valG];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_valB];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:_valHex];
    [_pickColor addObserver:self forKeyPath:@"moded" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view.window setLevel:NSFloatingWindowLevel];
    _delegate=NSApp.delegate;
    _delegate.popover.delegate=self;
    NSApp.keyWindow.delegate=self;
    _colorPickerWindowController=[_delegate.storyboard instantiateControllerWithIdentifier:@"ColorPicker"];
    _colorPickerWindowController.window.level=NSScreenSaverWindowLevel;
    [_colorPickerWindowController.window setIgnoresMouseEvents:YES];
    [_colorPickerWindowController.window setOpaque:NO];
    [_colorPickerWindowController.window setBackgroundColor:[NSColor clearColor]];
    _colorPickerViewController=(ColorPickerViewController*)_colorPickerWindowController.contentViewController;
}
-(void)popoverWillShow:(NSNotification *)notification{
    [NSEvent removeMonitor:_delegate.monitor];
    _delegate.monitor=[NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown handler:^(NSEvent *event){
        if(!CGRectContainsPoint(self.view.window.frame, [NSEvent mouseLocation])){
            [_delegate.popover close];
        }
    }];
}
-(void)popoverWillClose:(NSNotification *)notification{
    [NSEvent removeMonitor:_delegate.monitor];
    _delegate.monitor=nil;
    if(_pickColor.moded)
        _pickColor.moded=NO;
}
static bool isFirstEvent=true;
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSNumber *number=[change valueForKey:NSKeyValueChangeNewKey];
    if([keyPath isEqualToString:@"moded"]){
        if(number.intValue==1){
            [NSEvent removeMonitor:_delegate.monitor];
            isFirstEvent=true;
            [self.view.window setIgnoresMouseEvents:YES];
            _delegate.monitor=[NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskMouseMoved|NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown handler:^(NSEvent *event){
                if(!isFirstEvent){
                    if(event.type==NSEventTypeMouseMoved){
                        [self showColorPickerCusor:[NSEvent mouseLocation]];
                    }else{
                        _pickColor.moded=NO;
                        NSColor *c=_colorPickerViewController.curColor;
                        self.color =c;
                        NSColor *mainColor=[_rectPalette setColor2:c];
                        [_hbar setColor:mainColor];
                    }
                }else{
                    isFirstEvent=false;
                }
            }];
            [NSApp hide:nil];
        }else{
            if([_colorPickerWindowController.window isVisible])[_colorPickerWindowController.window close];
            [NSEvent removeMonitor:_delegate.monitor];
            [NSApp activateIgnoringOtherApps:YES];
            isFirstEvent=true;
            [self.view.window setIgnoresMouseEvents:NO];
            _delegate.monitor=[NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown|NSEventMaskRightMouseDown handler:^(NSEvent *event){
                if(!CGRectContainsPoint(self.view.window.frame, [NSEvent mouseLocation])){
                    [_delegate.popover close];
                }
            }];
        }
        
    }
}
-(void)showColorPickerCusor:(NSPoint)mouseLocation{
    CGRect displayBounds=CGDisplayBounds(kCGDirectMainDisplay);
    CGImageRef img=CGDisplayCreateImageForRect(kCGDirectMainDisplay, CGRectMake(mouseLocation.x, displayBounds.size.height-mouseLocation.y, 1, 1));
    CGFloat cursorSize=[NSCursor currentCursor].image.size.height;
    [_colorPickerWindowController.window setFrameOrigin:NSMakePoint(mouseLocation.x-50, mouseLocation.y+30>=displayBounds.size.height?mouseLocation.y-30-cursorSize:mouseLocation.y+cursorSize/2)];
    [_colorPickerWindowController.window makeKeyAndOrderFront:nil];
    CGDataProviderRef dataProvider=CGImageGetDataProvider(img);
    CFDataRef data=CGDataProviderCopyData(dataProvider);
    const UInt8* bytes=CFDataGetBytePtr(data);
    NSColor* color=[NSColor colorWithRed:(0xff&bytes[2])/255.0f green:(0xff&bytes[1])/255.0f blue:(0xff&bytes[0])/255.0f alpha:1];
    [_colorPickerViewController setCurColor:color];
    CGImageRelease(img);
    CGDataProviderRelease(dataProvider);
}
-(void)textDidChange:(NSNotification *)notification{
    if(notification.object==_valR||notification.object==_valG||notification.object==_valB){
        NSColor *c=[NSColor colorWithRed:_valR.string.floatValue/255 green:_valG.string.floatValue/255 blue:_valB.string.floatValue/255 alpha:1];
        NSColor *mainColor=[_rectPalette setColor2:c];
        [_hbar setColor:mainColor];
    }else if(notification.object==_valHex){
        NSString *hexStr=[_valHex.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSColor *c;
        if(hexStr.length==0){
            c=[NSColor blackColor];
        }else{
            const char* utf8Str=[hexStr UTF8String];
            UInt32 val;
            sscanf(utf8Str, "%X",&val);
            c=[NSColor colorWithRed:(val>>16)*1.0f/255 green:((val&0x00ff00)>>8)*1.0f/255 blue:(val&0xff)*1.0f/255 alpha:1];
        }
        NSColor *mainColor=[_rectPalette setColor2:c];
        [_hbar setColor:mainColor];
    }
}
-(void)viewWillAppear{
}
-(void)viewDidAppear{
    [NSApp activateIgnoringOtherApps:YES];
    [self.view.window makeKeyWindow];
    [self.view.window makeFirstResponder:_rectPalette];
    _pickColor.layer.backgroundColor=[NSColor colorWithWhite:0 alpha:0].CGColor;
    [_pickColor setNeedsDisplay];
    
}

-(void)viewDidDisappear{
}
-(void)dealloc{
}
-(void)setColor:(NSColor *)color{
    if(_color!=color){
        _color=color;
        _valBox.fillColor=color;
        NSString *str;
        str=[NSString stringWithFormat:@"%d",(int)(color.redComponent*255)];
        if(![_valR.string isEqualToString:str]){
            _valR.string=str;
        }
        str=[NSString stringWithFormat:@"%d",(int)(color.greenComponent*255)];
        if(![_valG.string isEqualToString:str]){
            _valG.string=str;
        }
        str=[NSString stringWithFormat:@"%d",(int)(color.blueComponent*255)];
        if(![_valB.string isEqualToString:str]){
            _valB.string=str;
        }
        str=[NSString stringWithFormat:@"%X",((int)(color.redComponent*255)<<16)|((int)(color.greenComponent*255)<<8)|(int)(color.blueComponent*255)];
        if(![_valHex.string isEqualToString:str]){
            _valHex.string=str;
        }
    }
}
-(void)cpColorVal:(id)sender{
    NSPasteboard* pasteboard=[NSPasteboard pasteboardWithName:NSGeneralPboard];
    [pasteboard clearContents];
    [pasteboard writeObjects:@[_valHex.string]];
}
-(void)mouseDown:(NSEvent *)event{
    if(_pickColor.moded){
        _pickColor.moded=NO;
    }
}
-(void)mouseUp:(NSEvent *)event{
    [self mouseDown:event];
}
-(void)mouseDragged:(NSEvent *)event{
    [self mouseDown:event];
}
-(void)mouseMoved:(NSEvent *)event{
    [self mouseDown:event];
}
-(void)rightMouseUp:(NSEvent *)event{
    [self mouseDown:event];
}
-(void)rightMouseDown:(NSEvent *)event{
    [self mouseDown:event];
}
-(void)rightMouseDragged:(NSEvent *)event{
    [self mouseDown:event];
}
@end
