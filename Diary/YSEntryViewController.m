//
//  YSNewEntryViewController.m
//  Diary
//
//  Created by yunseo shin on 2016. 5. 13..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSEntryViewController.h"
#import "YSCoreDataStack.h"
#import "YSDiaryEntry.h"
#import <CoreLocation/CoreLocation.h>


@interface YSEntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

//location
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *location;

@property (nonatomic, assign) enum YSDiaryEntryMood pickedMood;
@property (nonatomic,strong) UIImage *pickedImage;

@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;

@end


@implementation YSEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date;
    
    if(self.entry != nil){
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        
    }else {
        self.pickedMood  = YSDiaryEntryMoodAverage;
        date = [NSDate date];
        [self loadLocation];
    }
//    }else  {
//        self.pickedMood  = YSDiaryEntryMoodAverage;
//        date = [NSDate date];
//        [self loadLocation];
//    }else {
//        self.pickedMood  = YSDiaryEntryMoodBad;
//        date = [NSDate date];
//        [self loadLocation];
//    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM d (EEEE) "];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.textView.inputAccessoryView = self.accessoryView; //up of the keybord
    self.imgButton.layer.cornerRadius = CGRectGetWidth(self.imgButton.frame) / 10.0f;

    
}

-(void) loadLocation {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 100;
    
    [self.locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *) locations{
    
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark =[placemarks firstObject];
        self.location = placemark.name;
        
//        self.location = placemark.areasOfInterest; //administrativeArea OR country

    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)insertDiaryEntry {
    YSCoreDataStack *coreDataStack = [YSCoreDataStack defaultStack];
    YSDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"YSDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    entry.location = self.location;
    
    [coreDataStack saveContext];
}

- (void)updateDairyEntry {
    
    self.entry.body = self.textView.text;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);

    YSCoreDataStack *coreDataStack =[YSCoreDataStack defaultStack];
    [coreDataStack saveContext];

}
-(void)promptForSource {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles: @"Camera",@"Photo Roll", nil];
    [actionSheet showInView:self.view];
    

}

//image

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex !=actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        }else{
            [self promptForPhotoRoll];
        }
    }
}

//camera
-(void)promptForCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc ]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)promptForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc ]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
 
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

-(void)setPickedMood:(enum YSDiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
    self.goodButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.badButton.alpha = 0.5f;

    switch (pickedMood) {
        case YSDiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case YSDiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
            
        case YSDiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
    }

}

-(void)setPickedImage:(UIImage *)pickedImage{
    _pickedImage = pickedImage;
    
    if(pickedImage ==nil){
        [self.imgButton setImage:[UIImage imageNamed:@"icon_noImage"] forState:UIControlStateNormal];
    }else{
        [self.imgButton setImage:pickedImage forState:UIControlStateNormal];
    }
}

     
//IBAction
- (IBAction)DonePressed:(id)sender {
    
    if (self.entry != nil) {
        [self updateDairyEntry];
        
    }else {
        [self insertDiaryEntry];
    }
    
    [self dismissSelf];


}
- (IBAction)cancelPressed:(id)sender {
        [self dismissSelf];
}


- (IBAction)goodButton:(id)sender {
    self.pickedMood = YSDiaryEntryMoodGood;
}

- (IBAction)averageButton:(id)sender {
    self.pickedMood = YSDiaryEntryMoodAverage;
}

- (IBAction)badButton:(id)sender {
    self.pickedMood = YSDiaryEntryMoodBad;
}

- (IBAction)imgButton:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else {
        [self promptForPhotoRoll];
        
    }
}


@end
