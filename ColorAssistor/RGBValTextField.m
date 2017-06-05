//
//  RGBValTextField.m
//  ColorAssistor
//
//  Created by wx on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RGBValTextField.h"
@interface RGBValTextField()
-(BOOL)checkNumber:(NSString*)insString;
@end
@implementation RGBValTextField
-(void)insertText:(id)string replacementRange:(NSRange)replacementRange{
    if((((NSString*)string).length==1&&self.string.length<=2)){
        NSString* s;
        unichar keyChar=[string characterAtIndex:0];
        if((keyChar>='0'&&keyChar<='9')){
            s=string;
        }
        if(s){
            if([self checkNumber:s])[super insertText:s replacementRange:replacementRange];
        }
    }else{
        NSString *string2=[string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
        NSMutableString *string3=[[NSMutableString alloc]init];
        BOOL nzFlag=NO;
        for(int i=0;i<string2.length;i++){
            unichar c=[string2 characterAtIndex:i];
            if(!nzFlag&&c=='0'){
                continue;
            }else{
                nzFlag=YES;
                [string3 appendFormat:@"%c",c];
            }
        }
        if(string3.length+self.string.length-(self.selectedRange.length)<=3){
            NSString *regex = @"[1-9]+";
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            BOOL match=[predicate evaluateWithObject:string3];
            if(match){
                if([self checkNumber:string3])[super insertText:string3 replacementRange:replacementRange];
            }
        }
    }
}
-(BOOL)checkNumber:(NSString*)insString{
    NSMutableString* numString=[[NSMutableString alloc]init];
    NSRange range=self.selectedRange;
    for(int i=0;i<=self.string.length;i++){
        if(i==range.location){
            for(int j=0;j<insString.length;j++){
                [numString appendFormat:@"%c",[insString characterAtIndex:j]];
            }
            i+=range.length;
            if(i<self.string.length){
                [numString appendFormat:@"%c",[self.string characterAtIndex:i]];
            }
        }
        if((i<range.location||i>range.length+range.location)&&i<self.string.length){
            [numString appendFormat:@"%c",[self.string characterAtIndex:i]];
        }
    }
    int number=[numString intValue];
    if(number>255){
        return NO;
    }
    return YES;
}
-(NSMenu *)menuForEvent:(NSEvent *)event{
    return nil;
}
-(void)paste:(id)sender{
    
}
-(void)keyDown:(NSEvent *)event{
    if(event.modifierFlags&(1<<20)){
        switch (event.keyCode) {
            case 8:{
                if(self.selectedRange.length>0){
                    NSPasteboard* pasteboard=[NSPasteboard pasteboardWithName:NSGeneralPboard];
                    [pasteboard clearContents];
                    [pasteboard writeObjects:@[[self.string substringWithRange:self.selectedRange]]];
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
            if(self.string.length==0){
                self.string=@"0";
            }
        }
        [super keyDown:event];
    }
}
@end
