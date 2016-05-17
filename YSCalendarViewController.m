//
//  YSCalendarViewController.m
//  Diary
//
//  Created by yunseo shin on 2016. 5. 17..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSCalendarViewController.h"
#import "CalendarView.h"

@interface YSCalendarViewController ()

@end

@implementation YSCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CalendarView *calendarView = [[CalendarView alloc] initWithPosition:40.0 y:80.0];
    [self.view addSubview:calendarView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
