//
//  ChartViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 20/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController ()
{
    NSString *firstDate,*lastDate;
    NSArray *graphValues, *graphDates;
}
@end

@implementation ChartViewController
-(DBManager *) model1
{
    if(!_model1)
    {
        _model1 = [[DBManager alloc]init];
    }
    return _model1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *lastLog = [self.model1 lastPayment];
    if(![lastLog isEqualToString: @""])
    {  NSString *result = [self geTimeFromString:lastLog];
    self.lblLastPayment.text = result;
    }
    else{
        self.lblLastPayment.hidden = YES;
    }
    // Do any additional setup after loading the view.
    [self paymentPercentage];
    [self displayWeeksChart];
    self.myGraph.delegate = self;
    self.myGraph.dataSource = self;
    self.myGraph.enableTouchReport = YES;
    [self.view addSubview:self.myGraph];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)geTimeFromString:(NSString *)lastLog
{
    NSDateFormatter *trialFormat = [[NSDateFormatter alloc]init];
    
    [trialFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [trialFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *trialDate = [trialFormat dateFromString:lastLog];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatedCurrentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"current date %@",formatedCurrentDate);
    
    NSDate *trialDate1 = [trialFormat dateFromString:formatedCurrentDate];
    NSTimeInterval secondsBetween = [trialDate1 timeIntervalSinceDate:trialDate];
    NSString *result = [self stringFromTimeInterval:secondsBetween];
    NSArray* myArray = [result  componentsSeparatedByString:@":"];
    
    NSString* firstString = [myArray objectAtIndex:0];
    NSString* secondString = [myArray objectAtIndex:1];
    result = [firstString stringByAppendingString:@" Hours "];
    result = [result stringByAppendingString: secondString];
    result = [result stringByAppendingString:@" Minutes" ];
    
    return result;
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
    
}
- (IBAction)btnWeeksData:(id)sender {
    [self displayWeeksChart];
}

- (IBAction)btnMonthlyData:(id)sender {
    [self displayMonthlyChart];
}

- (IBAction)btnYearlyData:(id)sender {
    [self displayYearlyChart];
   
}

-(void) paymentPercentage
{
    NSDate *weekDate = [NSDate date];
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [myCalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:weekDate];
     int ff = (int)currentComps.weekOfYear;
    [currentComps setWeekday:1]; // 1: sunday
    NSDate *firstDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    [currentComps setWeekday:7]; // 7: saturday
    NSDate *lastDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    
    [currentComps setWeekday:1];
    [currentComps setWeekOfYear:ff-1];
    NSDate *firstDayOfPreviousWeek = [myCalendar dateFromComponents:currentComps];
    
    [currentComps setWeekday:7];
    [currentComps setWeekOfYear:ff-1];
    NSDate *lastDayOfPreviousWeek = [myCalendar dateFromComponents:currentComps];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    firstDate=[dateFormat stringFromDate:firstDayOfTheWeek];
    lastDate=[dateFormat stringFromDate:lastDayOfTheWeek];
    NSString *previousFirstDate=[dateFormat stringFromDate:firstDayOfPreviousWeek];
    NSString *previousLastDate=[dateFormat stringFromDate:lastDayOfPreviousWeek];
    NSInteger value = [self.model1 calcPecrcentage:previousFirstDate lastDayOfPrevious:previousLastDate firstDayOfWeek:firstDate lastDayOfWeek:lastDate];
    
    NSString *finalVal = [NSString stringWithFormat:@"%ld",(long)value] ;
    if ([finalVal rangeOfString:@"-"].location == NSNotFound) {
        finalVal = [@"Up " stringByAppendingString:finalVal];
        finalVal = [finalVal stringByAppendingString:@"%"];
        self.lblPaymentPercent.text = finalVal;
    }
    else {
        NSString *newStr = [finalVal substringFromIndex:1];
        finalVal = [@"Down " stringByAppendingString:newStr];
        finalVal = [finalVal stringByAppendingString:@"%"];
         self.lblPaymentPercent.text = finalVal;
    }
   
}

-(void) displayWeeksChart
{
    NSDictionary *weeksData = [[NSDictionary alloc]init];
    weeksData = [self.model1 weekLogChart:firstDate lastDayOfWeek:lastDate];
    NSArray *weekDates = [weeksData allKeys];
    NSArray *weekCount = [weeksData allValues];
    if ([weekCount count]> 1) {
        NSMutableArray *test = [[NSMutableArray alloc]init];
        [test addObject:@0];
        [test addObjectsFromArray:weekCount];
        
        graphValues = [weekCount copy];
        graphDates = [weekDates copy];
        NSLog(@"keys = %@ values = %@ and graphValues =%@ and graphDates=%@",weekDates,weekCount,graphValues,graphDates);
        
        [self hydrateDatasets];
        [self.myGraph reloadGraph];
        self.lblChartDetails.text = @"Weekly Log";
    }
    else
    {
       [self displayAlert:@"Weekly log contains only one data point. Add more data to the weekly log and then reload the graph."];
    }
    
    
    
}
-(void) displayMonthlyChart
{
    NSDate *weekDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:weekDate];
    comp.day = 1;
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    firstDate=[dateFormat stringFromDate:firstDayOfMonthDate];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *beginningOfNextMonth = [gregorian dateByAddingComponents:comps toDate:firstDayOfMonthDate options:0];
    lastDate = [dateFormat stringFromDate:beginningOfNextMonth];
    NSDictionary *monthsData = [[NSDictionary alloc]init];
    monthsData = [self.model1 monthLogChart:firstDate lastDayOfMonth:lastDate];
    NSArray *monthDates = [monthsData allKeys];
    NSArray *monthCount = [monthsData allValues];
    if ([monthCount count]> 1) {
        graphValues = [monthCount copy];
        graphDates = [monthDates copy];
        [self hydrateDatasets];
        [self.myGraph reloadGraph];
        self.lblChartDetails.text = @"Monthly Log";
    }
    else
    [self displayAlert:@"Monthly log contains only one data point. Add more data to the monthly log and then reload the graph."];
}

-(void) displayYearlyChart
{
    NSDictionary *weeksData = [[NSDictionary alloc]init];
    weeksData = [self.model1 yearlyLogChart:@"2016"];
    NSArray *yearlyDates = [weeksData allKeys];
    NSArray *yearlyCount = [weeksData allValues];
   if ([yearlyCount count]>= 1) {
        NSMutableArray *test = [[NSMutableArray alloc]init];
        [test addObject:@0];
        [test addObjectsFromArray:yearlyCount];
        NSMutableArray *test1 = [[NSMutableArray alloc]init];
        [test1 addObject:@"0"];
        [test1 addObject:@"2015"];
        graphValues = [test copy];
        graphDates = [test1 copy];
 NSLog(@"yearlykeys = %@ yearlyvalues = %@ and yearlygraphValues =%@ and yearlygraphDates=%@",yearlyDates,yearlyCount,graphValues,graphDates);
    [self hydrateDatasets];
    [self.myGraph reloadGraph];
    self.lblChartDetails.text = @"Yearly Log";
    }
    else
        [self displayAlert:@"Yearly log contains only one data point. Add more data to the yearly log and then reload the graph."];

   }


- (void)hydrateDatasets {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
       for (int i=0; i<[graphValues count]; i++) {
        [self.arrayOfValues addObject:graphValues[i]];
        [self.arrayOfDates addObject:graphDates[i]];
    }
    
}
#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    NSString *val = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
    NSString *val2 = [NSString stringWithFormat:@"in %@", [self labelForDateAtIndex:index]];
    val = [val stringByAppendingString:@" logs "];
    val = [val stringByAppendingString:val2];
  //  self.lblChartInfo.text = val;
   
}


- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSString *value = self.arrayOfDates[index];
   return value;
}
//Data source contains only one data point. Add more data to the data source and then reload the graph.

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"License Expiry Tracker"
                                                           message:msg delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
    [displayAlert show];
}

@end
