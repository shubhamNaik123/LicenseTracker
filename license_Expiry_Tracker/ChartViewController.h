//
//  ChartViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 20/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

@import UIKit;
#import "BEMSimpleLineGraphView.h"
#import "DBManager.h"


@interface ChartViewController : UIViewController<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property (nonatomic,strong) DBManager *model1;

@property (weak, nonatomic) IBOutlet UILabel *lblChartDetails;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (weak, nonatomic) IBOutlet UILabel *lblChartInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblLastPayment;


- (IBAction)btnWeeksData:(id)sender;
- (IBAction)btnMonthlyData:(id)sender;
- (IBAction)btnYearlyData:(id)sender;

@end
