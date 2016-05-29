//
//  YSDetailViewController.m
//  instaPhoto
//
//  Created by yunseo shin on 2016. 5. 22..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSDetailViewController.h"
#import "YSCoreDataStack.h"
#import "YSDiaryEntry.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPickedImage:[UIImage imageWithData:self.entry.imageData]];

    
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



//save button
- (void)PressedSave {
    
    YSEntryViewController *entryView = [[YSEntryViewController alloc] init ];

    [YSPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        
         _pickedImage = image;

        
        if (image !=nil) {
            [self insertDiaryEntry];
//            self.imageView.image = _pickedImage;
            [entryView.imgButton setImage:_pickedImage forState:UIControlStateNormal];
            NSLog(@"image !=nil");

        }else {
            [entryView.imgButton setImage:[UIImage imageNamed:@"icon_noImage"] forState:UIControlStateNormal];

            NSLog(@"123123123123");
        }
    }];
    
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    YSNavigationController *viewController = (YSNavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"NavigationController2"];

//    viewController.delegate = self;
//    [self presentViewController:viewController animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)insertDiaryEntry {
    YSCoreDataStack *coreDataStack = [YSCoreDataStack defaultStack];
    YSDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"YSDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
 
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);  //0.75
    [coreDataStack saveContext];
}

//setImage to imgButton
-(void)setPickedImage:(UIImage *)pickedImage{
    _pickedImage = pickedImage;
    
    if(pickedImage != nil){
     NSLog(@"pickedImage != nil");
        
    YSEntryViewController *entryView = [[YSEntryViewController alloc] init ];

        if(pickedImage ==nil){
            [entryView.imgButton setImage:[UIImage imageNamed:@"icon_noImage"] forState:UIControlStateNormal];
            NSLog(@"pickedImage ==nil");
        }else{
//            [entryView.imgButton setImage:pickedImage forState:UIControlStateNormal];
            [entryView.imgButton setImage:[UIImage imageNamed:@"icn_happy.png"] forState:UIControlStateNormal];
             NSLog(@"pickedImage !=nil");
        }
    }
    
    NSLog(@"setPickedImage is calling");
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
