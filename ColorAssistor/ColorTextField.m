//
//  ColorTextField.m
//  ColorAssistor
//
//  Created by wx on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ColorTextField.h"
@implementation ColorTextField
-(void)insertText:(id)string replacementRange:(NSRange)replacementRange{
    if((((NSString*)string).length==1&&self.string.length<=5)){
        NSString* s;
        unichar keyChar=[string characterAtIndex:0];
        if((keyChar>='0'&&keyChar<='9')||(keyChar>='A'&&keyChar<='F')){
            s=string;
        }else if(keyChar>='a'&&keyChar<='f'){
            s=[NSString stringWithFormat:@"%c",keyChar+('A'-'a')];
        }
        if(s){
            [super insertText:s replacementRange:replacementRange];
        }
    }else{
        NSString *string2=[string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        if(string2.length+self.string.length-(self.selectedRange.length)<=6){
            NSString *regex = @"[1-9a-fA-F]+";
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            BOOL match=[predicate evaluateWithObject:string2];
            if(match){
                NSMutableString *s=[[NSMutableString alloc]init];
                for(int i=0;i<string2.length;i++){
                    unichar c=[string2 characterAtIndex:i];
                    if((c>='0'&&c<='9')||(c>='A'&&c<='F')){
                        [s appendFormat:@"%c",c];
                    }else if(c>='a'&&c<='f'){
                        [s appendFormat:@"%c",c+('A'-'a')];
                    }
                }
                if(s){
                    [super insertText:s replacementRange:replacementRange];
                }
            }
        }
    }
}
-(void)paste:(id)sender{
}
-(void)keyDown:(NSEvent *)event{
    if(event.modifierFlags&(1<<20)){
        switch (event.keyCode) {
            case 8:{
                NSPasteboard* pasteboard=[NSPasteboard pasteboardWithName:NSGeneralPboard];
                [pasteboard clearContents];
                if(self.selectedRange.length>0){
                    [pasteboard writeObjects:@[[self.string substringWithRange:self.selectedRange]]];
                }else{
                    [pasteboard writeObjects:@[self.string]];
                }
                break;
            }
            case 9:{
                NSPasteboard* pasteboard=[NSPasteboard pasteboardWithName:NSGeneralPboard];
                NSArray *objs=[pasteboard readObjectsForClasses:@[[NSString class]] options:nil];
                if([objs count]&&((NSString*)objs[0]).length)[self insertText:objs[0] replacementRange:self.selectedRange];
                break;
            }
        }
    }else{
        if(event.keyCode==36){
            if(self.string.length!=6){
                const char* utf8Str=[self.string UTF8String];
                UInt32 val;
                sscanf(utf8Str, "%X",&val);
                self.string=[NSString stringWithFormat:@"%06X",val];
            }
        }
        [super keyDown:event];
    }
}
-(BOOL)resignFirstResponder{
    if(self.string.length!=6){
        const char* utf8Str=[self.string UTF8String];
        UInt32 val;
        sscanf(utf8Str, "%X",&val);
        self.string=[NSString stringWithFormat:@"%06X",val];
    }
    return YES;
}
@end
