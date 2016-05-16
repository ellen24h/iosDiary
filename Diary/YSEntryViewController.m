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

@interface YSEntryViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, assign) enum YSDiaryEntryMood pickedMood;

@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation YSEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date;
    
    if(self.entry != nil){
        self.textField.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        
    }else{
        self.pickedMood  = YSDiaryEntryMoodGood;
        date = [NSDate date];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM d (EEEE) "];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.textField.inputAccessoryView = self.accessoryView; //up of the keybord
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
    
    entry.body = self.textField.text;
//    entry.date = [[NSDate date] timeIntervalSince1970];
    
    [coreDataStack saveContext];

    
    
}

- (void)updateDairyEntry {
    
    self.entry.body = self.textField.text;
    
    YSCoreDataStack *coreDataStack =[YSCoreDataStack defaultStack];
    [coreDataStack saveContext];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
