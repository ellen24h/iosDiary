//
//  CalendarView.m
//  ios_calendar
//
//  Created by Maxim on 10/7/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "CalendarView.h"
#import "NSDate+CalendarView.h"
#import "NSString+CalendarView.h"

#import <CoreText/CoreText.h>



static const CGFloat kCalendarViewDayCellWidth       = 40;//날짜셀 크기
static const CGFloat kCalendarViewDayCellHeight      = 40;
static const CGFloat kCalendarViewDayCellOffset      = 7; //날짜셀 간격
//static const CGFloat kCalendarViewDayCellWidth       = 35;
//static const CGFloat kCalendarViewDayCellHeight      = 35;
//static const CGFloat kCalendarViewDayCellOffset      = 5;

static const CGFloat kCalendarViewMonthCellWidth     = 110; //100
//static const CGFloat kCalendarViewMonthCellHeight    = 60; //월 높이
//static const CGFloat kCalendarViewMonthCellWidth     = 90;
static const CGFloat kCalendarViewMonthCellHeight    = 30;


//static const CGFloat kCalendarViewMonthTitleOffsetY  = 100; //월 선택에서 헤더와의 간격
static const CGFloat kCalendarViewMonthTitleOffsetY  = 50;
static const CGFloat kCalendarViewMonthYStep         = 60;
static const NSInteger kCalendarViewMonthInLine      = 3;  //한 줄에 월이 몇개

static const CGFloat kCalendarViewYearCellWidth      = 80; //54
static const CGFloat kCalendarViewYearCellHeight     = 40;  //30 년 선택에서 각 연도 셀높이
static const CGFloat kCalendarViewYearTitleOffsetY   = 50;  //년 선택에서 헤더와의 간격
static const CGFloat kCalendarViewYearYStep          = 45;
static const NSInteger kCalendarViewYearsAround      = 12;
static const NSInteger kCalendarViewYearsInLine      = 5;

//static const CGFloat kCalendarViewYearCellWidth      = 54;
//static const CGFloat kCalendarViewYearCellHeight     = 30;
//static const CGFloat kCalendarViewYearTitleOffsetY   = 50;
//static const CGFloat kCalendarViewYearYStep          = 45;
//static const NSInteger kCalendarViewYearsAround      = 12;
//static const NSInteger kCalendarViewYearsInLine      = 5;

static const CGFloat kCalendarViewMonthLabelWidth    = 100;
static const CGFloat kCalendarViewMonthLabelHeight   = 20;

static const CGFloat kCalendarViewYearLabelWidth     = 40;
static const CGFloat kCalendarViewYearLabelHeight    = 120; //20

static const CGFloat kCalendarViewWeekDaysYOffset    = 30;
static const CGFloat kCalendarViewDaysYOffset        = 60;

static NSString * const kCalendarViewDefaultFont     = @"TrebuchetMS";

//static const CGFloat kCalendarViewDayFontSize        = 20;
//static const CGFloat kCalendarViewHeaderFontSize     = 22;
static const CGFloat kCalendarViewDayFontSize        = 16;
static const CGFloat kCalendarViewHeaderFontSize     = 18;

static const NSInteger kCalendarViewDaysInWeek       = 7;
static const NSInteger kCalendarViewMonthInYear      = 12;
static const NSInteger kCalendarViewMaxLinesCount    = 6;

static const CGFloat kCalendarViewSelectionRound     = 3.0;

static const NSTimeInterval kCalendarViewSwipeMonthFadeInTime  = 0.2;
static const NSTimeInterval kCalendarViewSwipeMonthFadeOutTime = 0.2;
//static const NSTimeInterval kCalendarViewSwipeMonthFadeOutTime = 0.6;

@implementation CalendarViewRect;

@end

@interface CalendarView ()
{
    NSInteger type;
    NSInteger minType;
    NSInteger mode;
    NSInteger event;
    
    NSInteger currentDay;
    NSInteger currentMonth;
    NSInteger currentYear;
    
    int preferredWeekStartIndex;
    
    NSInteger todayDay;
    NSInteger todayMonth;
    NSInteger todayYear;
    
    NSMutableArray *dayRects;
    NSMutableArray *monthRects;
    NSMutableArray *yearRects;
    
    CGRect yearTitleRect;
    CGRect monthTitleRect;
}

- (void)setup;

- (void)generateDayRects;
- (void)generateMonthRects;
- (void)generateYearRects;
- (CGFloat)getEffectiveWeekDaysYOffset;
- (CGFloat)getEffectiveDaysYOffset;
- (CGFloat)getEffectiveMonthsYOffset;
- (CGFloat)getEffectiveYearsYOffset;

- (void)drawCircle:(CGRect)rect toContext:(CGContextRef *)context withColor:(UIColor *)color;
- (void)drawRoundedRectangle:(CGRect)rect toContext:(CGContextRef *)context;
- (void)drawWeekDays;

- (void)leftSwipe:(UISwipeGestureRecognizer *)recognizer;
- (void)rightSwipe:(UISwipeGestureRecognizer *)recognizer;
- (void)pinch:(UIPinchGestureRecognizer *)recognizer;
- (void)tap:(UITapGestureRecognizer *)recognizer;
- (void)doubleTap:(UITapGestureRecognizer *)recognizer;

- (void)changeDateEvent;

- (void)advanceCalendarContentsWithEvent:(CalendarEvent)eventType;
- (void)rewindCalendarContentsWithEvent:(CalendarEvent)eventType;

- (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment;
- (BOOL)checkPoint:(CGPoint)point inArray:(NSMutableArray *)array andSetValue:(NSInteger *)value;
- (void)fade;

@end

@implementation CalendarView

@synthesize currentDate = _currentDate;

#pragma mark - Initialization

- (instancetype)init
{
	self = [self initWithPosition:0.0 y:0.0];
	return self;
}

- (instancetype)initWithPosition:(CGFloat)x y:(CGFloat)y
{
	const CGFloat width = (kCalendarViewDayCellWidth + kCalendarViewDayCellOffset) * kCalendarViewDaysInWeek;
	const CGFloat height = (kCalendarViewDayCellHeight + kCalendarViewDayCellOffset) * kCalendarViewMaxLinesCount + kCalendarViewDaysYOffset;
	
    self = [self initWithFrame:CGRectMake(x, y, width, height)];
	
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)dealloc
{
    self.currentDate = nil;
    self.fontColor = nil;
    self.fontHeaderColor = nil;
    self.fontSelectedColor = nil;
    self.selectionColor = nil;
    self.fontName = nil;
}

#pragma mark - Setup

- (void)setup
{
    self.dayCellWidth = kCalendarViewDayCellWidth;
    self.dayCellHeight = kCalendarViewDayCellHeight;
    self.monthCellWidth = kCalendarViewMonthCellWidth;
    self.monthCellHeight = kCalendarViewMonthCellHeight;
    self.yearCellWidth = kCalendarViewYearCellWidth;
    self.yearCellHeight = kCalendarViewYearCellHeight;
    
    self.fontName = kCalendarViewDefaultFont;
    self.dayFontSize = kCalendarViewDayFontSize;
    self.headerFontSize = kCalendarViewHeaderFontSize;
    
    dayRects = [[NSMutableArray alloc] init];
    monthRects = [[NSMutableArray alloc] init];
    yearRects = [[NSMutableArray alloc] init];
    
    yearTitleRect = CGRectMake(0, 0, 0, 0);
    monthTitleRect = CGRectMake(0, 0, 0, 0);
    
    self.fontColor = [UIColor blackColor];
    
//    navigationBarAppearance.barTintColor =[UIColor colorWithRed:244.0/255.0 green:88.0/255.0 blue:68.0/255.0 alpha:1.0f];

    
    self.fontHeaderColor = [UIColor colorWithRed:244.0/255.0 green:88.0/255.0 blue:68.0/255.0 alpha:1.0f];
    self.fontSelectedColor = [UIColor whiteColor];
    self.selectionColor = [UIColor colorWithRed:244.0/255.0 green:88.0/255.0 blue:68.0/255.0 alpha:1.0f];
    self.todayColor = [UIColor colorWithRed:244.0/255.0 green:88.0/255.0 blue:68.0/255.0 alpha:1.0f];
    
//    self.fontHeaderColor = [UIColor redColor];
//    self.fontSelectedColor = [UIColor whiteColor];
//    self.selectionColor = [UIColor redColor];
//    self.todayColor = [UIColor redColor];
    
    
//    self.bgColor = [UIColor whiteColor];
//    self.bgColor = [UIColor lightGrayColor];
//    self.bgColor = [UIColor clearColor];
    self.bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sample.jpg"]];
    
    
    
    

//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor lightGrayColor];

//     self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_noImage.png"]];
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_noImage.png"]]];

    
    
    
    
    self.shouldMarkSelectedDate = YES;
    self.shouldMarkToday = NO;
    self.shouldShowHeaders = YES;
    
    event = CalendarEventNone;
    
    [self setMode:CalendarModeDefault];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
    
    currentDay = [components day];
    currentMonth = [components month];
    currentYear = [components year];
    
    todayDay = [components day];
    todayMonth = [components month];
    todayYear = [components year];
    
    preferredWeekStartIndex = 1; // This is Monday, from [dateFormatter shortWeekdaySymbols]
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    [right setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:right];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self addGestureRecognizer:pinch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    [self generateDayRects];
    [self generateMonthRects];
    [self generateYearRects];
}

- (void)setMode:(NSInteger)m
{
    mode = m;
    switch (mode) {
        case CalendarModeDefault:
        {
            type = CalendarViewTypeDay;
            minType = CalendarViewTypeDay;
        }
        break;
        case CalendarModeMonthsAndYears:
        {
            type = CalendarViewTypeMonth;
            minType = CalendarViewTypeMonth;
        }
        break;
        case CalendarModeYears:
        {
            type = CalendarViewTypeYear;
            minType = CalendarViewTypeYear;
        }
        break;
            
        default:
            break;
    }
}

#pragma mark - Refresh

- (void)refresh
{
    [self generateDayRects];
    [self generateMonthRects];
    [self generateYearRects];
}

#pragma mark - Getting, setting current date

- (void)setCurrentDate:(NSDate *)date
{
    if (date) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        currentDay = [components day];
        currentMonth = [components month];
        currentYear = [components year];
        
        switch (type) {
            case CalendarViewTypeDay:
                [self generateDayRects];
                break;
            case CalendarViewTypeYear:
                [self generateYearRects];
                break;
            default:
                break;
        }
        
        [self fade];
        
        _currentDate = date;
    }
}

- (NSDate *)currentDate
{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[calendar setTimeZone:timeZone];
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
	[components setYear:currentYear];
	[components setMonth:currentMonth];
	[components setDay:currentDay];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	[components setTimeZone:timeZone];
	
	return [calendar dateFromComponents:components];
}

#pragma mark - Generating of rects

- (void)generateDayRects
{
	[dayRects removeAllObjects];
	
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	[components setYear:currentYear];
	[components setMonth:currentMonth];
	[components setDay:1];  // set first day of month
	
    NSDate *currentDate = [calendar dateFromComponents:components];
	NSUInteger lastDayOfMonth = [currentDate getLastDayOfMonth];
    if (currentDay > lastDayOfMonth) {
        currentDay = lastDayOfMonth;
    }
    
    [components setDay:currentDay];
    currentDate = [calendar dateFromComponents:components];
    NSInteger weekday = [currentDate getWeekdayOfFirstDayOfMonth];
	
	const CGFloat yOffSet = [self getEffectiveDaysYOffset];
	const CGFloat w = self.dayCellWidth;
	const CGFloat h = self.dayCellHeight;
	
	CGFloat x = 0;
	CGFloat y = yOffSet;
	
	NSInteger xi = weekday - preferredWeekStartIndex;
	NSInteger yi = 0;
	
	for (NSInteger i = 1; i <= lastDayOfMonth; ++i) {
		x = xi * (self.dayCellWidth + kCalendarViewDayCellOffset);
		++xi;
		
        CalendarViewRect *dayRect = [[CalendarViewRect alloc] init];
        dayRect.value = i;
        dayRect.str = [NSString stringWithFormat:@"%ld", (long)i];
        dayRect.frame = CGRectMake(x, y, w, h);
        [dayRects addObject:dayRect];
        
		if (xi >= kCalendarViewDaysInWeek) {
			xi = 0;
			++yi;
			y = yOffSet + yi * (self.dayCellHeight + kCalendarViewDayCellOffset);
		}
	}
}

- (void)generateMonthRects
{
    [monthRects removeAllObjects];
    
    NSDateFormatter *formater = [NSDateFormatter new];
    NSArray *monthNames = [formater standaloneMonthSymbols];
    NSInteger index = 0;
    CGFloat x, y = [self getEffectiveMonthsYOffset];
    NSInteger xi = 0;
    for (NSString *monthName in monthNames) {
        x = xi * self.monthCellWidth;
        ++xi;
        ++index;
        
        CalendarViewRect *monthRect = [[CalendarViewRect alloc] init];
        monthRect.value = index;
        monthRect.str = monthName;
        monthRect.frame = CGRectMake(x, y, self.monthCellWidth, self.monthCellHeight);
        [monthRects addObject:monthRect];
        
        if (xi >= kCalendarViewMonthInLine) {
            xi = 0;
            y += kCalendarViewMonthYStep;
        }
    }
}

- (void)generateYearRects
{
    [yearRects removeAllObjects];
    
    NSMutableArray *years = [[NSMutableArray alloc] init];
    for (NSInteger year = currentYear - kCalendarViewYearsAround; year <= currentYear + kCalendarViewYearsAround; ++year) {
        [years addObject:@(year)];
    }
    
    CGFloat x, y = [self getEffectiveYearsYOffset];
    NSInteger xi = 0;
    for (NSNumber *obj in years) {
        x = xi * self.yearCellWidth;
        ++xi;
        
        CalendarViewRect *yearRect = [[CalendarViewRect alloc] init];
        yearRect.value = [obj integerValue];
        yearRect.str = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
        yearRect.frame = CGRectMake(x, y, self.yearCellWidth, self.yearCellHeight);
        [yearRects addObject:yearRect];
        
        if (xi >= kCalendarViewYearsInLine) {
            xi = 0;
            y += kCalendarViewYearYStep;
        }
    }
}

# pragma mark - Layout Calculations 

- (CGFloat)getEffectiveWeekDaysYOffset
{
    if (self.shouldShowHeaders) {
        return kCalendarViewWeekDaysYOffset;
    } else {
        return 0;
    }
}

- (CGFloat)getEffectiveDaysYOffset
{
    if (self.shouldShowHeaders) {
        return  kCalendarViewDaysYOffset;
    } else {
        return kCalendarViewDaysYOffset - kCalendarViewWeekDaysYOffset;
    }
}

- (CGFloat)getEffectiveMonthsYOffset
{
    if (self.shouldShowHeaders) {
        return kCalendarViewMonthTitleOffsetY;
    } else {
        return 0;
    }
}

- (CGFloat)getEffectiveYearsYOffset
{
    if (self.shouldShowHeaders) {
        return kCalendarViewYearTitleOffsetY;
    } else return 0;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	
	CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
	CGContextFillRect(context, rect);
    
	NSDictionary *attributesBlack = [self generateAttributes:self.fontName
												withFontSize:self.dayFontSize
												   withColor:self.fontColor
											   withAlignment:NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment)];
	
	NSDictionary *attributesWhite = [self generateAttributes:self.fontName
												withFontSize:self.dayFontSize
												   withColor:self.fontSelectedColor
											   withAlignment:NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment)];
    
	NSDictionary *attributesRedRight = [self generateAttributes:self.fontName
												   withFontSize:self.headerFontSize
													  withColor:self.fontHeaderColor
												  withAlignment:NSTextAlignmentFromCTTextAlignment(kCTRightTextAlignment)];
	
	NSDictionary *attributesRedLeft = [self generateAttributes:self.fontName
												  withFontSize:self.headerFontSize
													 withColor:self.fontHeaderColor
												 withAlignment:NSTextAlignmentFromCTTextAlignment(kCTLeftTextAlignment)];
    
	CTFontRef cellFont = CTFontCreateWithName((CFStringRef)self.fontName, self.dayFontSize, NULL);
	CGRect cellFontBoundingBox = CTFontGetBoundingBox(cellFont);
	CFRelease(cellFont);
    
	NSString *year = [NSString stringWithFormat:@"%ld", (long)currentYear];
	const CGFloat yearNameX = (self.dayCellWidth - CGRectGetHeight(cellFontBoundingBox)) * 0.5;
    if (self.shouldShowHeaders) {
        yearTitleRect = CGRectMake(yearNameX, 0, kCalendarViewYearLabelWidth, kCalendarViewYearLabelHeight);
    } else {
        yearTitleRect = CGRectZero;
    }
	[year drawUsingRect:yearTitleRect withAttributes:attributesRedLeft];
	
    if (mode != CalendarModeYears) {
        NSDateFormatter *formater = [NSDateFormatter new];
        NSArray *monthNames = [formater standaloneMonthSymbols];
        NSString *monthName = monthNames[(currentMonth - 1)];
        const CGFloat monthNameX = (self.dayCellWidth + kCalendarViewDayCellOffset) * kCalendarViewDaysInWeek - kCalendarViewMonthLabelWidth - (self.dayCellWidth - CGRectGetHeight(cellFontBoundingBox));
        if (self.shouldShowHeaders) {
            monthTitleRect = CGRectMake(monthNameX, 0, kCalendarViewMonthLabelWidth, kCalendarViewMonthLabelHeight);
        } else {
            monthTitleRect = CGRectZero;
        }
        [monthName drawUsingRect:monthTitleRect withAttributes:attributesRedRight];
    }
	
    NSMutableArray *rects = nil;
    NSInteger currentValue = 0;
    
    switch (type) {
        case CalendarViewTypeDay:
        {
            [self drawWeekDays];
            
            rects = dayRects;
            currentValue = currentDay;
        }
        break;
        case CalendarViewTypeMonth:
        {
            rects = monthRects;
            currentValue = currentMonth;
        }
        break;
        case CalendarViewTypeYear:
        {
            rects = yearRects;
            currentValue = currentYear;
        }
        break;
            
        default:
            break;
    }
    
    if (rects) {
        for (CalendarViewRect *rect in rects) {
            NSDictionary *attrs = nil;
            CGRect rectText = rect.frame;
            rectText.origin.y = rectText.origin.y + ((CGRectGetHeight(rectText) - CGRectGetHeight(cellFontBoundingBox)) * 0.5);
            
            if (rect.value == currentValue && self.shouldMarkSelectedDate) {
                if (type == CalendarViewTypeDay) {
                    [self drawCircle:rect.frame toContext:&context withColor:self.selectionColor];
                }
                else {
                    [self drawRoundedRectangle:rect.frame toContext:&context];
                }
                
                attrs = attributesWhite;
            } else if (type == CalendarViewTypeDay &&
                       rect.value == todayDay &&
                       currentMonth == todayMonth &&
                       currentYear == todayYear &&
                       self.shouldMarkToday) {
                [self drawCircle:rect.frame toContext:&context withColor:self.todayColor];
                attrs = attributesWhite;
            }
            else {
                attrs = attributesBlack;
            }
            
            [rect.str drawUsingRect:rectText withAttributes:attrs];
        }
    }
}

- (void)drawCircle:(CGRect)rect toContext:(CGContextRef *)context withColor:(UIColor *)color
{
    CGContextSetFillColorWithColor(*context, color.CGColor);
    CGContextFillEllipseInRect(*context, rect);
}

- (void)drawRoundedRectangle:(CGRect)rect toContext:(CGContextRef *)context
{
    CGContextSetFillColorWithColor(*context, self.selectionColor.CGColor);
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(*context, minx, midy);
    CGContextAddArcToPoint(*context, minx, miny, midx, miny, kCalendarViewSelectionRound);
    CGContextAddArcToPoint(*context, maxx, miny, maxx, midy, kCalendarViewSelectionRound);
    CGContextAddArcToPoint(*context, maxx, maxy, midx, maxy, kCalendarViewSelectionRound);
    CGContextAddArcToPoint(*context, minx, maxy, minx, midy, kCalendarViewSelectionRound);
    CGContextClosePath(*context);
    
    CGContextSetStrokeColorWithColor(*context, self.selectionColor.CGColor);
    CGContextDrawPath(*context, kCGPathFillStroke);
}

- (void)drawWeekDays
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSArray *weekdayNames = [dateFormatter shortWeekdaySymbols];
	
	NSDictionary *attrs = [self generateAttributes:self.fontName
									  withFontSize:self.dayFontSize
										 withColor:self.fontColor
									 withAlignment:NSTextAlignmentFromCTTextAlignment(kCTCenterTextAlignment)];
	
	CGFloat x = 0;
	CGFloat y = [self getEffectiveWeekDaysYOffset];
	const CGFloat w = self.dayCellWidth;
	const CGFloat h = self.dayCellHeight;
	for (int i = preferredWeekStartIndex; i < kCalendarViewDaysInWeek; ++i) {
        int adjustedIndex = i - preferredWeekStartIndex;
		x = adjustedIndex * (self.dayCellWidth + kCalendarViewDayCellOffset);
		NSString *str = [NSString stringWithFormat:@"%@", weekdayNames[i]];
		[str drawUsingRect:CGRectMake(x, y, w, h) withAttributes:attrs];
	}
    
    for (int i = 0; i < preferredWeekStartIndex; ++i) {
        int adjustedIndex = kCalendarViewDaysInWeek - (preferredWeekStartIndex - i);
        x = adjustedIndex * (self.dayCellWidth + kCalendarViewDayCellOffset);
        NSString *str = [NSString stringWithFormat:@"%@", weekdayNames[i]];
        [str drawUsingRect:CGRectMake(x, y, w, h) withAttributes:attrs];
    }

}

#pragma mark - Change date event

- (void)changeDateEvent
{
	NSDate *currentDate = [self currentDate];
	if (_calendarDelegate && [_calendarDelegate respondsToSelector:@selector(didChangeCalendarDate:)]) {
		[_calendarDelegate didChangeCalendarDate:currentDate];
	}
    if (_calendarDelegate && [_calendarDelegate respondsToSelector:@selector(didChangeCalendarDate:withType:withEvent:)]) {
        [_calendarDelegate didChangeCalendarDate:currentDate withType:type withEvent:event];
    }
}

#pragma mark - Advance/Rewind Calendar Contents

- (void)advanceCalendarContents
{
    [self advanceCalendarContentsWithEvent:CalendarEventNone];
}

- (void)rewindCalendarContents
{
    [self rewindCalendarContentsWithEvent:CalendarEventNone];
}

- (void)advanceCalendarContentsWithEvent:(CalendarEvent)eventType
{
    event = eventType;
    
    switch (type) {
        case CalendarViewTypeDay:
        {
            if (currentMonth == kCalendarViewMonthInYear) {
                currentMonth = 1;
                ++currentYear;
            }
            else {
                ++currentMonth;
            }
            
            [self generateDayRects];
        }
            break;
        case CalendarViewTypeMonth:
        {
            ++currentYear;
        }
            break;
        case CalendarViewTypeYear:
        {
            currentYear += kCalendarViewYearsAround;
            [self generateYearRects];
        }
            break;
            
        default:
            break;
    }
    
    [self changeDateEvent];
    [self fade];
}

- (void)rewindCalendarContentsWithEvent:(CalendarEvent)eventType
{
    event = eventType;
    
    switch (type) {
        case CalendarViewTypeDay:
        {
            if (currentMonth == 1) {
                currentMonth = kCalendarViewMonthInYear;
                --currentYear;
            }
            else {
                --currentMonth;
            }
            
            [self generateDayRects];
        }
            break;
        case CalendarViewTypeMonth:
        {
            --currentYear;
        }
            break;
        case CalendarViewTypeYear:
        {
            currentYear -= kCalendarViewYearsAround;
            [self generateYearRects];
        }
            break;
            
        default:
            break;
    }
    
    [self changeDateEvent];
    [self fade];
}

#pragma mark - Gestures

- (void)leftSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [self advanceCalendarContentsWithEvent:CalendarEventSwipeLeft];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [self rewindCalendarContentsWithEvent:CalendarEventSwipeRight];
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSInteger t = type;
        if (recognizer.velocity < 0) {
            event = CalendarEventPinchIn;
            if (t - 1 >= minType) {
                --t;
            }
        }
        else {
            event = CalendarEventPinchOut;
            if (t + 1 < CalendarViewTypeCount) {
                ++t;
            }
        }
        
        if (t != type) {
            type = t;
            [self fade];
        }
    }
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    event = CalendarEventTap;
    CGPoint touchPoint = [recognizer locationInView:self];
    
    if (CGRectContainsPoint(yearTitleRect, touchPoint)) {
        if (type != CalendarViewTypeYear) {
            type = CalendarViewTypeYear;
            [self fade];
        }
        return;
    }
    
    if (CGRectContainsPoint(monthTitleRect, touchPoint)) {
        if (type != CalendarViewTypeMonth) {
            type = CalendarViewTypeMonth;
            [self fade];
        }
        return;
    }
    
    BOOL hasEvent = NO;
    switch (type) {
        case CalendarViewTypeDay:
        {
            hasEvent = [self checkPoint:touchPoint inArray:dayRects andSetValue:&currentDay];
        }
        break;
        case CalendarViewTypeMonth:
        {
            hasEvent = [self checkPoint:touchPoint inArray:monthRects andSetValue:&currentMonth];
        }
        break;
        case CalendarViewTypeYear:
        {
            hasEvent = [self checkPoint:touchPoint inArray:yearRects andSetValue:&currentYear];
        }
        break;
            
        default:
            break;
    }
    
    if (hasEvent) {
        [self changeDateEvent];
        [self setNeedsDisplay];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer
{
    event = CalendarEventDoubleTap;
    if (type != CalendarViewTypeDay && type > minType) {
        --type;
        [self fade];
    }
    
    if (type == CalendarViewTypeDay) {
        [self generateDayRects];
    }
    
    NSDate *currentDate = [self currentDate];
    if (event == CalendarEventDoubleTap && _calendarDelegate && [_calendarDelegate respondsToSelector:@selector(didDoubleTapCalendar:withType:)]) {
        [_calendarDelegate didDoubleTapCalendar:currentDate withType:type];
    }
}

#pragma mark - Additional functions

- (BOOL)checkPoint:(CGPoint)point inArray:(NSMutableArray *)array andSetValue:(NSInteger *)value
{
    for (CalendarViewRect *rect in array) {
        if (CGRectContainsPoint(rect.frame, point)) {
            *value = rect.value;
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:textAlignment];
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	NSDictionary * attrs = @{
							 NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize],
							 NSForegroundColorAttributeName : color,
							 NSParagraphStyleAttributeName : paragraphStyle
							 };
	
	return attrs;
}

- (void)fade
{
	[UIView animateWithDuration:kCalendarViewSwipeMonthFadeInTime
						  delay:0
						options:0
					 animations:^{
						 self.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [self setNeedsDisplay];
						 [UIView animateWithDuration:kCalendarViewSwipeMonthFadeOutTime
											   delay:0
											 options:0
										  animations:^{
											  self.alpha = 1.0f;
										  }
										  completion:nil];
					 }];
}

- (void)setPreferredWeekStartIndex:(NSInteger)index
{
    preferredWeekStartIndex = (int)index;
}

@end
