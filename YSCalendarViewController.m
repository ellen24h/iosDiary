//
//  YSCalendarViewController.m
//  Diary
//
//  Created by yunseo shin on 2016. 5. 17..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSCalendarViewController.h"
#import "CalendarView.h"
#import "YSDiaryEntry.h"
#import "YSEntryViewController.h"
#import "YSCoreDataStack.h"

#import <QuartzCore/QuartzCore.h>

@interface YSCalendarViewController ()


//@property(nonatomic, strong) YSDiaryEntry *entry;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;





@end

//@synthesize todayTxt;
@implementation YSCalendarViewController

 NSString *todayTxt;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalendarView *calendarView = [[CalendarView alloc] initWithPosition:30.0 y:100.0];
    
    [self.view addSubview:calendarView];


    
    if(self.entry != nil){
        self.bodyLabel.text = self.entry.body;
        NSString * a = self.bodyLabel.text;
            NSLog(@" _todayTxt : %@",a);
    }else{
        
        self.bodyLabel.text = @"오늘의 한 줄";

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
