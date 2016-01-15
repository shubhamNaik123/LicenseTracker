//
//  AddNewEntryController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "AddNewEntryController.h"

@interface AddNewEntryController ()

@end
NSString *formatedDate;
@implementation AddNewEntryController

-(DBManager *) model
{
    if (!_model) {
        _model = [[DBManager alloc] init];
    }
    return _model;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    formatedDate = [dateFormat stringFromDate:self.datePicker.date];
    self.lblDisplayDate.text = formatedDate;
}

- (IBAction)saveDetails:(UIButton *)sender {
    if([self.licenseName.text isEqual:@""])
    {
       [self displayAlert:@"Please enter License name!"];
    }
    else
    {
       NSDate *now = [NSDate date];
       NSComparisonResult result = [now compare:self.datePicker.date];
    
       if(result == 1)
       {
          [self displayAlert:@"Invalid Expiry Date! Please select future date."];
        
       }
       else{
         [self sendNotification];
            [self displayAlert:@"Data entered succesfully."];
            self.lblDisplayDate.text = @"";
            self.licenseName.text = @"";
            [self.datePicker setDate:[NSDate date]];
            
       
        }
    }
  
}

- (IBAction)openHelp:(id)sender {
    HelpViewController *infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"Help"];
    [self.navigationController pushViewController:infoController animated:YES];
}



-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"License Expiray Tracker" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}

-(void) sendNotification
{
    UIApplication* app = [UIApplication sharedApplication];
    // [app cancelAllLocalNotifications];
    UILocalNotification *ourNotification = [[UILocalNotification alloc]init];
    NSDate *fireDate = self.datePicker.date;
    NSLog(@"now=%@",fireDate);
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: fireDate options:0];
    
    int rand= arc4random()%100;
    
    NSLog(@"Yesterday=%@",yesterday);
    [ourNotification setFireDate:yesterday];
    NSString *alertMSg = @"1 day for ";
    alertMSg = [alertMSg stringByAppendingString:self.licenseName.text];
    alertMSg = [alertMSg stringByAppendingString:@" to expire!"];
    [ourNotification setAlertBody:alertMSg];
    [ourNotification setAlertAction:@"Go to App"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:rand],@"NotificationID",self.licenseName.text,@"LicenseName",formatedDate,@"LicenseDate", nil];
    // NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NotificationId],@"NotificationID",@"Alarm",@"AlarmName", nil];
    
    ourNotification.userInfo = dict;
    ourNotification.applicationIconBadgeNumber = [app applicationIconBadgeNumber]+1;
    [app scheduleLocalNotification:ourNotification];
    NSLog(@"Done %@",fireDate);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.licenseName endEditing:YES];
    
}

@end
