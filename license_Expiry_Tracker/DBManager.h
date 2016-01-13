//
//  DBManager.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManager : NSObject

-(void) closeDB;
-(void) createDatabasse;

-(NSArray *) logLicenseList;
-(NSString *) lastPayment;
-(int) addNewLogLicense:(NSString*)logDate;
-(NSString *) paymentPercent:(NSString *)lastDate
          currDate:(NSString *)currDate;
-(NSInteger ) calcPecrcentage:(NSString *)firstDayOfPreviousWeek
          lastDayOfPrevious:(NSString *)lastDayOfPreviousWeek
          firstDayOfWeek:(NSString *)firstDayOfTheWeek
          lastDayOfWeek:(NSString *)lastDayOfWeek;
-(NSDictionary *) weekLogChart:(NSString *)firstDayOfTheWeek
          lastDayOfWeek:(NSString *)lastDayOfWeek;
-(NSDictionary *) monthLogChart:(NSString *)firstDayOfTheMonth
                 lastDayOfMonth:(NSString *)lastDayOfMonth;
-(NSDictionary *) yearlyLogChart:(NSString *)currentYear;
@end
