//
//  YSCalendarViewController.h
//  Diary
//
//  Created by yunseo shin on 2016. 5. 17..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDiaryEntry;
@interface YSCalendarViewController : UIViewController


+(CGFloat) heightForEntry:(YSDiaryEntry *)entry;
-(void) configureCellForEntry:(YSDiaryEntry *)entry;

@property(nonatomic, strong) YSDiaryEntry *entry;


@end




