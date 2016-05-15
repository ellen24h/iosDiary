//
//  YSDiaryEntry.h
//  Diary
//
//  Created by yunseo shin on 2016. 5. 14..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

extern NS_ENUM(int16_t, YSDiaryEntryMood){
    YSDiaryEntryMoodGood = 0,
    YSDiaryEntryMoodAverage = 1,
    YSDiaryEntryMoodBad = 2
};


@interface YSDiaryEntry : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end




NS_ASSUME_NONNULL_END

#import "YSDiaryEntry+CoreDataProperties.h"
