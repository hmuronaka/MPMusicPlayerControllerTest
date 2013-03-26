//
//  Utilities.m
//  MusicPlayerForStudy3
//
//  Created by MURONAKA HIROAKI on 2013/02/02.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+(NSString*)stringFromNSInterval:(NSTimeInterval)interval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: interval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss.S"];
    NSString* str = [formatter stringFromDate:date];
    return str;
}

+(NSString*)stringFromNSIntervalWithNSNumber:(NSNumber*)interval
{
    return [Utilities stringFromNSInterval:[Utilities NSNumberToNSTimeInterval:interval]];
}

+(NSTimeInterval)NSNumberToNSTimeInterval:(NSNumber*)number
{
    return [number doubleValue];
}

+(NSTimeInterval)valueToNSTimeInterval:(NSInteger)minute second:(NSInteger)second millisecond:(NSInteger)millisecond
{
    NSTimeInterval result = 0;
    result = minute * 60 + second + ((NSTimeInterval)millisecond / 1000);
    return result;
}

// 指定した要素を置き換えた新しいOrderSetを作成する。
// coredataのバグによる。
+(NSOrderedSet*)orderedSet:(NSOrderedSet*)set ReplaceFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:[set array]];
    id aFrom = [array objectAtIndex:fromIndex];
    id aTo = [array objectAtIndex:toIndex];
    [array replaceObjectAtIndex:toIndex withObject:aFrom];
    [array replaceObjectAtIndex:fromIndex withObject:aTo];
    
    return [NSOrderedSet orderedSetWithArray:array];
}


+(NSInteger)boolToInt:(BOOL)boolValue
{
    return boolValue ? 1 : 0;
}

+(BOOL)intToBool:(NSInteger)intValue
{
    return intValue != 0;
}



@end
