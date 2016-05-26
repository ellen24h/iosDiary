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

@interface YSTableViewCell (){

//    NSString *todayTxt;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImgView;

//

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
    
//    YSTableViewCell * t = [[YSTableViewCell alloc]init];
//    t.todayTxt = entry.body;
//        todayTxt = @"hihi";
//    NSLog(@" _todayTxt : %@", t.todayTxt);
    

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M월 dd일 (E) hh:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    
    if(entry.imageData){
        self.mainImgView.image = [UIImage imageWithData:entry.imageData];
    }else{
        CGFloat width = CGRectGetWidth(self.mainImgView.bounds);
        CGFloat height = CGRectGetHeight(self.mainImgView.bounds);

        self.mainImgView.image = [UIImage imageNamed:@"icon_noImage"];
//        self.mainImgView.bounds = CGRectMake(width/2 + 30, height/2 +30, 60, 60);
    }
    
    //Weather
    if(entry.mood == YSDiaryEntryWeatherSunny){
        self.moodImgView.image = [UIImage imageNamed:@"sunny_black"];
        
    }else if(entry.mood == YSDiaryEntryWeatherWindy){
        self.moodImgView.image = [UIImage imageNamed:@"cloudy_black"];
        
    }else if(entry.mood == YSDiaryEntryWeatherRainyAndSnowy){
        self.moodImgView.image = [UIImage imageNamed:@"snowrain_black"];
    }
    

    
//    self.mainImgView.layer.cornerRadius = CGRectGetWidth(self.mainImgView.frame) / 2.0f;
    

}




//- (void)awakeFromNib {
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//


@end
