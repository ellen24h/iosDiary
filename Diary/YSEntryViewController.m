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

@end

@implementation YSEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    if(self.entry != nil){
        self.textField.text = self.entry.body;
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
