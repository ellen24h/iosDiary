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

//@property (nonatomic, assign) enum YSDiaryEntryMood pickedMood;

//YSDiaryEntryWeather
@property (nonatomic, assign) enum YSDiaryEntryWeather pickedWeather;

@property (nonatomic,strong) UIImage *pickedImage;

@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;

@end


//extern NS_ENUM(int16_t, YSDiaryEntryWeather){
//    YSDiaryEntryWeatherSunny = 0,
//    YSDiaryEntryWeatherRainy = 1,
//    YSDiaryEntryWeatherWindy = 2
//    
//};

@implementation YSEntryViewController

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
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapRecognizer];
    
        NSDate *date;
    
    
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedWeather = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedWeather = YSDiaryEntryWeatherSunny;
        date = [NSDate date];
    }

    
////        self.pickedMood  = YSDiaryEntryMoodAverage;
//        self.pickedWeather =  YSDiaryEntryWeatherSunny;
//        date = [NSDate date];
//        
//    }else  {
////        self.pickedMood  = YSDiaryEntryMoodAverage;
//        date = [NSDate date];
//    }else {
////        self.pickedMood  = YSDiaryEntryMoodBad;
//        date = [NSDate date];


    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd일 (EEEE) "];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView = self.accessoryView; //up of the keybord
    self.imgButton.layer.cornerRadius = CGRectGetWidth(self.imgButton.frame) / 10.0f;
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
    entry.mood = self.pickedWeather; //not self.entry.mood
    
    [coreDataStack saveContext];
}

- (void)updateDairyEntry {
    
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedWeather;
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


- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

//UI alpha

/*
 extern NS_ENUM(int16_t, YSDiaryEntryWeather){
 YSDiaryEntryWeatherSunny = 0,
 YSDiaryEntryWeatherWindy = 1,
 YSDiaryEntryWeatherRainyAndSnowy = 2
 
 };
 */

-(void)setPickedWeather:(enum YSDiaryEntryWeather)pickedWeather {
    
    _pickedWeather = pickedWeather;
    self.goodButton.alpha = 0.3f;
    self.averageButton.alpha = 0.3f;
    self.badButton.alpha = 0.3f;

    switch (pickedWeather) {
        case YSDiaryEntryWeatherSunny:
            self.goodButton.alpha = 2.0f;
            break;
        case YSDiaryEntryWeatherWindy:
            self.averageButton.alpha = 2.0f;
            break;
            
        case YSDiaryEntryWeatherRainyAndSnowy:
            self.badButton.alpha = 2.0f;
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
    self.pickedWeather = YSDiaryEntryWeatherSunny;
    
}

- (IBAction)averageButton:(id)sender {
    self.pickedWeather = YSDiaryEntryWeatherWindy;
}

- (IBAction)badButton:(id)sender {
    self.pickedWeather = YSDiaryEntryWeatherRainyAndSnowy;
}

- (IBAction)imgButton:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else {
        [self promptForPhotoRoll];
        
    }
}


@end
