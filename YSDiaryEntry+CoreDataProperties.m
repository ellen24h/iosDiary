//
//  YSDiaryEntry+CoreDataProperties.m
//  Diary
//
//  Created by yunseo shin on 2016. 5. 14..
//  Copyright © 2016년 yunseo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "YSDiaryEntry+CoreDataProperties.h"

@implementation YSDiaryEntry (CoreDataProperties)

@dynamic body;
@dynamic date;
@dynamic imageData;
@dynamic location;
@dynamic mood;



- (NSString *)sectionName {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM YYYY"];

    return [dateFormatter stringFromDate:date];
//    NSLog(@"dateFormatter %@", dateFormatter);
//    NSLog(@"date %@", date);


}




@end
