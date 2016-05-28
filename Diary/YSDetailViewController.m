//
//  YSDetailViewController.m
//  instaPhoto
//
//  Created by yunseo shin on 2016. 5. 22..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSDetailViewController.h"

#import "YSPhotoController.h"
#import "YSEntryViewController.h"
#import "YSDiaryEntry.h"
#import "YSCoreDataStack.h"
#import "YSEntryViewController.h"
#import "YSPhotosViewController.h"

#import "YSPhotoCell.h"
#import "YSPhotoController.h"
#import <SAMCache/SAMCache.h>

@interface YSDetailViewController ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic,strong) UIImage *pickedImage; //entryview controller

@end

@implementation YSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];

    //NavigationBar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.barTintColor =[UIColor colorWithRed:244.0/255.0 green:88.0/255.0 blue:68.0/255.0 alpha:1.0f];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"Select Image";
    
    //leftButton
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    //rightButton
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(PressedSave)];
    navigationItem.rightBarButtonItem = doneBarButtonItem;
    
    navigationBar.items = @[ navigationItem ];
    
    [self.view addSubview:navigationBar];
    
    //show Detail images
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
        NSLog(@"select thumnail");
  
    //selected 1 image shows up
    [YSPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
        
        
        
        
    }];
    
    

}


//cancel button
- (void)dismiss {
    
    [self dismissSelf];
}

//save button
- (void)PressedSave {

        UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icn_happy." ofType:@"png"]];
    
        YSEntryViewController *entryView = [[YSEntryViewController alloc]init];
    
    
//        [entryView.imgButton setImage:[UIImage imageNamed:@"icn_happy"] forState:UIControlStateNormal];
//        
        [entryView.imgButton setImage:img forState:UIControlStateNormal];
    
    [self dismissSelf];
}

//- (void) setImageView:(UIImageView *)pickedImage{
//
//    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"icn_happy." ofType:@"png"]];
//    
//    YSEntryViewController *entryView = [[YSEntryViewController alloc]init];
//    
//    //    entryView.imgButton =     self.pickedImage;
////    entryView.imgButton =img;
//    
//    [entryView.imgButton setImage:[UIImage imageNamed:@"icn_happy.png"] forState:UIControlStateSelected];
//    
//    
//}



//- (void)setPickedImage:(UIImage *)pickedImage {
//    _pickedImage = pickedImage;
//    
//    if (pickedImage == nil) {
//        YSEntryViewController *entryView = [[YSEntryViewController alloc]init];
//
//        [entryView.image]
////        [self.imageButton setImage:[UIImage imageNamed:@"icn_happy.png"] forState:UIControlStateNormal];
//    } else {
//        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
//    }
//}



//- (void)updateDairyEntry {
//    
//    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
//    
//    YSCoreDataStack *coreDataStack =[YSCoreDataStack defaultStack];
//    [coreDataStack saveContext];
//    
//}



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    NSLog(@"selct saveImage mehod1111" );

}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // View controller's view's size
    CGSize size = self.view.bounds.size;
    
    // Image view's size
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    // Image view's frame  (self.view's height - self.imageView height) / 2
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
}

//insert to Coredata
- (void) saveImage {

    [self close];
    

}


- (void)close {

    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"selct close mehod" );

}


- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
