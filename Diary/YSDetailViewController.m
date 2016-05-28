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
#import "YSPhotosViewController.h"
#import "YSPhotoCell.h"
#import <SAMCache/SAMCache.h>
#import "YSNavigationController.h"

@interface YSDetailViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
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
    
    //show Detail image view
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    NSLog(@"show Detail image view");
  
    //selected 1 image shows up
    [YSPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
        
        

    }];
    
    
}

-(void)setPhoto:(NSDictionary *)photo{
    
    _photo = photo;
    [YSPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    NSURL *url = [[NSURL alloc]initWithString:_photo[@"images"][@"standard_resolution"][@"url"]]; //
    
    //    [self downloadPhotoWithURL:url];
    //    NSLog(@"setPhoto url = %@",url); //all thumbnail images
    
}



//cancel button
- (void)dismiss {
    
    [self dismissSelf];
}


-(void)setPickedImage:(UIImage *)image{
    _pickedImage = image;
    
    YSEntryViewController *entryView = [[YSEntryViewController alloc] init ];

    if(image ==nil){
        [entryView.imgButton setImage:[UIImage imageNamed:@"icon_noImage"] forState:UIControlStateNormal];
    }else{
        [entryView.imgButton setImage:image forState:UIControlStateNormal];
    }
}



//save button
- (void)PressedSave {
    
    
    
    [YSPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        
        YSEntryViewController *entryView = [[YSEntryViewController alloc] init ];
        if (image !=nil) {
        self.imageView.image = image;
        [entryView.imgButton setImage:image forState:UIControlStateNormal];
            NSLog(@"image !=nil");

//            [entryView.imgButton setImage:[UIImage imageNamed:@"about_80.png"] forState:UIControlStateNormal];
        }else {
            NSLog(@"123123123123");
        }
    }];
    

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YSNavigationController *viewController = (YSNavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"NavigationController2"];
 
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
    

//    YSDetailViewController *PhotosViewController = [[UINavigationController alloc] initWithRootViewController:addController];
//    [self.navigationController pushViewController:entryView animated:YES];

}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

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



- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
