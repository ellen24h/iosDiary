//
//  YSDetailViewController.m
//  instaPhoto
//
//  Created by yunseo shin on 2016. 5. 22..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSDetailViewController.h"
#import "YSPhotoController.h"

@interface YSDetailViewController ()
@property (nonatomic) UIImageView *imageView;

@end

@implementation YSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    
    self.imageView = [[UIImageView alloc] init];
    
    
    [self.view addSubview:self.imageView];
    
    
    //image shows up
    [YSPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
//
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
//
//    //    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
//    


}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
    //    [self.animator addBehavior:snap];
    
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // View controller's view's size
    CGSize size = self.view.bounds.size;
    
    // Image view's size
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    // Image view's frame               (self.view's height - self.imageView height) / 2
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) / 2.0, imageSize.width, imageSize.height);
}


- (void)close {
    //    [self.animator removeAllBehaviors];
    //    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180.0f)];
    
    //    [self.animator addBehavior:snap];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
