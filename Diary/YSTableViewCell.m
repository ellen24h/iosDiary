//
//  YSTableViewCell.m
//  Diary
//
//  Created by yunseo shin on 2016. 5. 16..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSTableViewCell.h"
#import "YSDiaryEntry.h"

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
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(218, 12) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    
    return  MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin +bottonMargin);

}

-(void) configureCellForEntry:(YSDiaryEntry *)entry{

    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE, MMMMM d yyyy" ];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if(entry.imageData){
        self.mainImgView.image = [UIImage imageWithData:entry.imageData];
    }else{
        self.mainImgView.image = [UIImage imageNamed:@"icon_noImage"];
    }
    
//    
//    if(entry.mood == YSDiaryEntryMoodGood){
//        self.mainImgView.image = [UIImage imageWithData:@"icon_good"];
//        
//    }else if(entry.mood == YSDiaryEntryMoodAverage){
//        self.mainImgView.image = [UIImage imageWithData:@"icon_Average"];
//        
//    }else if(entry.mood == YSDiaryEntryMoodBad){
//        self.mainImgView.image = [UIImage imageWithData:@"icon_bad"];
//    }
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
