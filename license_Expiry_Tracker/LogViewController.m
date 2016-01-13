//
//  LogViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController
{
    NSMutableArray *logDetails;
}
-(DBManager *) model
{
    if(!_model)
    {
        _model = [[DBManager alloc]init];
    }
    return _model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tblLogDetails.delegate = self;
    self.tblLogDetails.dataSource = self;
    [self displayLogDetails];
    [self.tblLogDetails reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([logDetails count]==0)
    {
       self.tblLogDetails.hidden = YES;
    }
    else{
        self.tblLogDetails.hidden=NO;
    }
    return [logDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text =[logDetails objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
   return cell;
}

- (IBAction)btnLogDetails:(id)sender {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter1 setLocale:locale];
    [dateFormatter1 setDateFormat:@"EEEE HH:mm a| MMMM dd, yyyy"];
    NSString *myDate = [dateFormatter1 stringFromDate:now];
    self.lblLogDisp.text = myDate;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MMM d, yyyy hh:mm a"];
    NSString *formatedDate = [dateFormater stringFromDate:now];
    int value =[self.model addNewLogLicense:formatedDate];
    if(value == 1)
    {
        [self displayLogDetails];
        [self.tblLogDetails reloadData];
    }
        }

-(void) displayLogDetails
{
    NSArray *logList = [[NSArray alloc]init];
    logList = [self.model logLicenseList];
    if ([logList count] > 0) {
     logDetails = [[NSMutableArray alloc]initWithArray:logList];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
       if ([[segue identifier] isEqualToString:@"payment"]) {
    }
}
@end
