//
//  YSNewEntryViewController.h
//  Diary
//
//  Created by yunseo shin on 2016. 5. 13..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDiaryEntry;

@interface YSEntryViewController : UIViewController <UITextFieldDelegate>{

    @public IBOutlet UIButton *imgButton;
    
}

@property(nonatomic, strong) YSDiaryEntry *entry;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, readonly, strong) IBOutlet UIButton *imgButton;
@property (nonatomic) NSDictionary *photo;

- (void)textViewDidBeginEditing:(UITextView *)textView;


@end
