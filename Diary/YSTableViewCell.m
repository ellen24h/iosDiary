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
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImgView;

@end

@implementation YSTableViewCell


+(CGFloat)heightForEntry:(YSDiaryEntry *)entry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottonMargin = 39.0f;
    const CGFloat minHeight = 85.0f;

    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    // options: | //
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(349, 340) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    
    return  MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin +bottonMargin);

}

-(void) configureCellForEntry:(YSDiaryEntry *)entry{

    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM d (EE)" ];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    
    
    
    //test-time
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"hh:mm" ];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:entry.date];
    [dateFormatter stringFromDate:date2];
    
    NSLog(@"date : %@", date2);
    
    
    if(entry.imageData){
        self.mainImgView.image = [UIImage imageWithData:entry.imageData];
    }else{
        self.mainImgView.image = [UIImage imageNamed:@"icon_noImage"];
    }
    
    
    if(entry.mood == YSDiaryEntryMoodGood){
        self.moodImgView.image = [UIImage imageNamed:@"icn_happy"];
        
    }else if(entry.mood == YSDiaryEntryMoodAverage){
        self.moodImgView.image = [UIImage imageNamed:@"icn_Average"];
        
    }else if(entry.mood == YSDiaryEntryMoodBad){
        self.moodImgView.image = [UIImage imageNamed:@"icn_bad"];
    }
    
//    self.mainImgView.layer.cornerRadius = CGRectGetWidth(self.mainImgView.frame) / 2.0f;
    
    if (entry.location.length > 0){
        self.locationLabel.text = entry.location;
        NSLog(@"entry.location : %@ ",entry.location);
        
    }else {
        self.locationLabel.text = @"No location";
        NSLog(@"No location");

    }
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
