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
#import "AppDelegate.h"
#import "YSPhotosViewController.h"
#import "YSPhotoController.h"
#import "YSDetailViewController.h"
#import "YSNavigationController.h"
#import <SimpleAuth/SimpleAuth.h>
#import <UIKit/UIKit.h>

@interface YSEntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>


//YSDiaryEntryWeather
@property (nonatomic, assign) enum YSDiaryEntryWeather pickedWeather;
@property (nonatomic,strong) UIImage *pickedImage;
@property (nonatomic) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderText;

@property (weak, nonatomic) IBOutlet UIButton *sunnyButton;
@property (weak, nonatomic) IBOutlet UIButton *cloudyButton;
@property (weak, nonatomic) IBOutlet UIButton *rainyAndSnowyButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, readwrite, strong) IBOutlet UIButton *imgButton;



@end


@implementation YSEntryViewController
//@synthesize imageButton;


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



    [_textView setDelegate:self];
//    _textView.insertDictationResultPlaceholder = @"Comment";
    
    if ([_textView.text length] > 0) {
        [_textView setBackgroundColor:[UIColor whiteColor]];
        [_placeHolderText setHidden:YES];
        [_textView becomeFirstResponder];
        
    }else if ([_textView.text isEqualToString:@"Comment"]) {
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_placeHolderText setHidden:NO];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd일 (EEEE) "];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    self.textView.inputAccessoryView = self.accessoryView; //up of the keybord
    self.imgButton.layer.cornerRadius = CGRectGetWidth(self.imgButton.frame) / 10.0f;
    
    
    
}

- (void)textViewDidBeginEding:(UITextView *)textView {

}


- (void)textViewDidChange:(UITextView *)textView {

    if ([textView.text length] > 0) {
        [textView setBackgroundColor:[UIColor whiteColor]];
        [_placeHolderText setHidden:YES];
        [textView becomeFirstResponder];

    }else if ([textView.text isEqualToString:@"Comment"]) {
        [textView setBackgroundColor:[UIColor clearColor]];
        [_placeHolderText setHidden:NO];

        
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)insertDiaryEntry {
    YSCoreDataStack *coreDataStack = [YSCoreDataStack defaultStack];
    YSDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"YSDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);  //0.75
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
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:Nil otherButtonTitles: @"Camera",@"Photo Roll", @"Instagram", nil];
    
    [actionSheet showInView:self.view];
}

//image
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if ([buttonTitle isEqualToString:@"Camera"]) {  //buttonIndex !=actionSheet.firstOtherButtonIndex
            [self promptForCamera];
        }else if([buttonTitle isEqualToString:@"Photo Roll"]){
            [self promptForPhotoRoll];
        }else if([buttonTitle isEqualToString:@"Instagram"]){
            [self promptForInstagram];
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
//Ablum
-(void)promptForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc ]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
 
}


//instagram
-(void)promptForInstagram{
    NSLog(@"call photosViewController");
    

    YSPhotosViewController *photosViewController = [[YSPhotosViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photosViewController];
    
    UINavigationBar *navigationBar = navigationController.navigationBar;
//    navigationBar.barTintColor =[UIColor colorWithRed:238.0/255.0 green:63.0/255.0 blue:53.0/255.0 alpha:1.0f];
    navigationBar.barStyle = UIBarStyleBlackOpaque;


    //connect
   [self.navigationController pushViewController:photosViewController animated:YES];

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


-(void)setPickedWeather:(enum YSDiaryEntryWeather)pickedWeather {
    
    _pickedWeather = pickedWeather;
    self.sunnyButton.alpha = 0.3f;
    self.cloudyButton.alpha = 0.3f;
    self.rainyAndSnowyButton.alpha = 0.3f;

    switch (pickedWeather) {
        case YSDiaryEntryWeatherSunny:
            self.sunnyButton.alpha = 2.0f;
            break;
        case YSDiaryEntryWeatherWindy:
            self.cloudyButton.alpha = 2.0f;
            break;
            
        case YSDiaryEntryWeatherRainyAndSnowy:
            self.rainyAndSnowyButton.alpha = 2.0f;
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
         NSLog(@"DonePressed update");
    }else {
        [self insertDiaryEntry];
        NSLog(@"DonePressed insert");

    }
    
    [self dismissSelf];

//        UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        YSNavigationController *viewController = (YSNavigationController *)[storyboard2 instantiateViewControllerWithIdentifier:@"NavigationController1"];
//    [self presentViewController:viewController animated:YES completion:nil];
//    
//     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    

}
- (IBAction)cancelPressed:(id)sender {
        [self dismissSelf];
}


- (IBAction)sunnyButton:(id)sender {
    self.pickedWeather = YSDiaryEntryWeatherSunny;
    
}

- (IBAction)cloudyButton:(id)sender {
    self.pickedWeather = YSDiaryEntryWeatherWindy;
}

- (IBAction)rainyAndSnowyButton:(id)sender {
    self.pickedWeather = YSDiaryEntryWeatherRainyAndSnowy;
}

- (IBAction)imgButton:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else {
//        [self promptForPhotoRoll];
        [self promptForInstagram];
    }
}


@end
