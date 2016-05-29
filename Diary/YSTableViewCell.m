//
//  YSTableViewCell.m
//  Diary
//
//  Created by yunseo shin on 2016. 5. 16..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSTableViewCell.h"
#import "YSDiaryEntry.h"
#import <QuartzCore/QuartzCore.h>

@interface YSTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImgView;



@end

@implementation YSTableViewCell
@synthesize todayTxt;



// check
+(CGFloat)heightForEntry:(YSDiaryEntry *)entry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottonMargin = 39.0f;
    const CGFloat minHeight = 185.0f;

    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    // options: | //
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(349, 340) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    
    return  MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin +bottonMargin);

}

-(void) configureCellForEntry:(YSDiaryEntry *)entry{

    self.bodyLabel.text = entry.body;
    

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M월 dd일 (E) hh:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    
    if(entry.imageData){
        self.mainImgView.image = [UIImage imageWithData:entry.imageData];
    }else{
        CGFloat width = CGRectGetWidth(self.mainImgView.bounds);
        CGFloat height = CGRectGetHeight(self.mainImgView.bounds);

        
        UIImage * image = [UIImage imageNamed:@"noimage"];
        CGSize sacleSize = CGSizeMake(40, 30);
        UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
        UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        

        self.mainImgView.image = resizedImage ;
        self.mainImgView.contentMode = UIViewContentModeScaleAspectFit;
        self.mainImgView.bounds = CGRectMake(width/2 + 30, height/2 +30, 60, 60);
    }
    
    //Weather
    if(entry.mood == YSDiaryEntryWeatherSunny){
        self.weatherImgView.image = [UIImage imageNamed:@"sunny_black"];
        
    }else if(entry.mood == YSDiaryEntryWeatherWindy){
        self.weatherImgView.image = [UIImage imageNamed:@"cloudy_black"];
        
    }else if(entry.mood == YSDiaryEntryWeatherRainyAndSnowy){
        self.weatherImgView.image = [UIImage imageNamed:@"snowrain_black"];
    }
    
    
//    self.mainImgView.layer.cornerRadius = CGRectGetWidth(self.mainImgView.frame) / 2.0f;
    

}

@end
