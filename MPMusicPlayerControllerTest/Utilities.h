//
//  Utilities.h
//  MusicPlayerForStudy3
//
//  Created by MURONAKA HIROAKI on 2013/02/02.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString*)stringFromNSInterval:(NSTimeInterval)interval;
+(NSString*)stringFromNSIntervalWithNSNumber:(NSNumber*)interval;
+(NSTimeInterval)NSNumberToNSTimeInterval:(NSNumber*)number;
+(NSTimeInterval)valueToNSTimeInterval:(NSInteger)minute second:(NSInteger)second millisecond:(NSInteger)millisecond;

+(NSOrderedSet*)orderedSet:(NSOrderedSet*)set ReplaceFrom:(NSInteger)fromIndex to:(NSInteger)toIndex;

+(NSInteger)boolToInt:(BOOL)boolValue;
+(BOOL)intToBool:(NSInteger)intValue;

@end
