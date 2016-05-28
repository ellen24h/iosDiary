//
//  YSDetailViewController.h
//  instaPhoto
//
//  Created by yunseo shin on 2016. 5. 22..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSDiaryEntry;
@class YSEntryViewController;

@interface YSDetailViewController : UIViewController

@property (nonatomic) NSDictionary *photo;
@property(nonatomic, strong) YSDiaryEntry *entry;


@end
