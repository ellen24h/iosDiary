//
//  YSTableViewCell.h
//  Diary
//
//  Created by yunseo shin on 2016. 5. 16..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDiaryEntry;

@interface YSTableViewCell : UITableViewCell{
    
//        NSString *todayTxt;


}


+(CGFloat) heightForEntry:(YSDiaryEntry *)entry;
-(void) configureCellForEntry:(YSDiaryEntry *)entry;

@property (nonatomic, readwrite) NSString *todayTxt;

@end
