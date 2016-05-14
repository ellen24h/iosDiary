//
//  YSDiaryEntry+CoreDataProperties.h
//  Diary
//
//  Created by yunseo shin on 2016. 5. 14..
//  Copyright © 2016년 yunseo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "YSDiaryEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSDiaryEntry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *location;
@property (nonatomic) int16_t mood;

@end

NS_ASSUME_NONNULL_END
