//
//  DBManager.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "DBManager.h"
static sqlite3 *database;
@implementation DBManager
NSString *_dbPathString;


-(void) createDatabasse
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docPath = [path objectAtIndex:0];
    
    _dbPathString = [docPath stringByAppendingPathComponent:@"license.sqlite3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:_dbPathString]) {
        const char *dbPath = [_dbPathString UTF8String];
        
        if(sqlite3_open(dbPath, &database)== SQLITE_OK) {
            const char *sqlStatement =   "CREATE TABLE logDateDetails(logID integer not null primary key, log_time datetime default (DATETIME(current_timestamp, 'LOCALTIME')));";
            char *error;
            
            if(sqlite3_exec(database, sqlStatement, NULL, NULL, &error) == SQLITE_OK){
                NSLog(@"All tables are created");
                
            } else {
                NSLog(@"Unable to create some table %s", error);
                sqlite3_free(error);
                error = NULL;
            }
            
            
        }
    }
    
}
-(void) closeDB
{
    sqlite3_close(database);
}

-(NSArray *) logLicenseList
{
    NSMutableArray *licenselogTable = [[NSMutableArray alloc] initWithCapacity:5];
     if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
     NSString *selectSQL = @"Select logID,log_time from logDateDetails order by logID DESC LIMIT 5 ";
    //select TOP 5 from users order by user_id DESC
    NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logDate = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *licenseLogDate = [[NSString alloc] initWithUTF8String:logDate];
        NSArray *test = [NSArray arrayWithObjects:licenseLogDate, nil];
        [licenselogTable addObjectsFromArray:test];
      
    }
    NSLog(@"test%@=",licenselogTable);
    [self closeDB];
     }
    return licenselogTable;
}

-(int) addNewLogLicense:(NSString*)logDate
{
    
    if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
    NSString *insertString = [NSString stringWithFormat:@"INSERT INTO logDateDetails (log_time) VALUES(datetime(CURRENT_TIMESTAMP, 'LOCALTIME'))"];
    NSLog(@"Insert Query=%@",insertString);
    const char* query = [insertString UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    while (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing %@", insertString);
        return 0;
    }
    if(sqlite3_step(query_stmt)!= SQLITE_DONE)
    {NSLog(@"Error running insert %s",query);
        return 0;
    }
    [self closeDB];
    }
    return 1;
}

-(NSString *) lastPayment
{
    NSString *lastLogDate = [[NSString alloc]init];
    if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
    NSString *selectSQL11 = @"Select logID,log_time from logDateDetails order by logID DESC LIMIT 1 ";
    NSLog(@"selectSQL Query=%@",selectSQL11);
    const char* query = [selectSQL11 UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL11);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logDate1 = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *licenseLogDate = [[NSString alloc] initWithUTF8String:logDate1];
        lastLogDate = licenseLogDate;
            }
   [self closeDB];
     }
    return lastLogDate;

}
-(NSString *) paymentPercent:(NSString *)lastDate currDate:(NSString *)currDate
{
    NSString *count = [[NSString alloc]init];
    if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
    NSString *selectSQL = [NSString stringWithFormat: @"SELECT count(log_date) from license_log_details where log_date BETWEEN '%@' AND '%@'",lastDate,currDate];
   const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
       while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logDate = (char *) sqlite3_column_text(query_stmt, 0);
        NSString *licenseLogDate = [[NSString alloc] initWithUTF8String:logDate];
        count = licenseLogDate;
    }
    [self closeDB];
    }
    return  count;
}

-(NSInteger ) calcPecrcentage:(NSString *)firstDayOfPreviousWeek
            lastDayOfPrevious:(NSString *)lastDayOfPreviousWeek
               firstDayOfWeek:(NSString *)firstDayOfTheWeek
                lastDayOfWeek:(NSString *)lastDayOfWeek
{
     NSInteger lastWeekCount = 0,currentWeekCount = 0,finalResult = 0;
    currentWeekCount = [self getCurrentWeekCount:firstDayOfTheWeek lastDayOfWeek:lastDayOfWeek];
    lastWeekCount = [self getPreviousWeekCount:firstDayOfPreviousWeek lastDayOfWeek:lastDayOfPreviousWeek];
    if (lastWeekCount == 0) {
        finalResult = currentWeekCount;
    }
    else
    {
        finalResult = ((currentWeekCount - lastWeekCount)*100) / 100;
    }
    return finalResult;
}

-(NSInteger) getCurrentWeekCount:(NSString *)firstDayOfTheWeek
                   lastDayOfWeek:(NSString *)lastDayOfWeek
{
    NSInteger currentWeekCount = 0;
     if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
    NSString *selectcurrentWeek = [NSString stringWithFormat: @"Select count(log_time) from logDateDetails  where log_time BETWEEN '%@' AND '%@'",firstDayOfTheWeek,lastDayOfWeek];
    NSLog(@"selectSQL Query=%@",selectcurrentWeek);
    const char* query = [selectcurrentWeek UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectcurrentWeek);
        return 0;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logTimecount = (char *) sqlite3_column_text(query_stmt, 0);
        NSString *totalCount = [[NSString alloc] initWithUTF8String:logTimecount];
        currentWeekCount = [totalCount integerValue];
    }
    [self closeDB];
     }
    return currentWeekCount;
}

-(NSInteger) getPreviousWeekCount:(NSString *)firstDayOfPreviousWeek
                   lastDayOfWeek:(NSString *)lastDayOfPreviousWeek
{
    NSInteger lastWeekCount = 0;
    if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
    NSString *selectlastWeek = [NSString stringWithFormat: @"Select count(log_time) from logDateDetails  where log_time BETWEEN '%@' AND '%@'",firstDayOfPreviousWeek,lastDayOfPreviousWeek];
    NSLog(@"selectSQL Query=%@",selectlastWeek);
    const char* query1 = [selectlastWeek UTF8String];
    sqlite3_stmt *query_stmt1 = NULL;
    if (sqlite3_prepare_v2(database, query1, -1, &query_stmt1, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectlastWeek);
        return 0;
    }
    while (sqlite3_step(query_stmt1)==SQLITE_ROW) {
        char *logTimecount1 = (char *) sqlite3_column_text(query_stmt1, 0);
        NSString *totalCount1 = [[NSString alloc] initWithUTF8String:logTimecount1];
        lastWeekCount = [totalCount1 integerValue];
    }
    [self closeDB];
    }
    return lastWeekCount;
}

-(NSDictionary *) weekLogChart:(NSString *)firstDayOfTheWeek
            lastDayOfWeek:(NSString *)lastDayOfWeek
{
    NSMutableDictionary *oneWeekLog = [[NSMutableDictionary alloc]init];
    if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
    NSString *selectSQL = [NSString stringWithFormat:@"Select count(log_time),strftime('%%d/%%m',log_time)  from logDateDetails  where log_time BETWEEN '%@' AND '%@' group by strftime('%%d %%m %%Y',log_time)",firstDayOfTheWeek,lastDayOfWeek];
  //  NSString *selectSQL = @"Select count(log_time),strftime('%d/%m',log_time)  from logDateDetails  where log_time BETWEEN '2015-12-01' AND '2015-12-21' group by strftime('%d %m %Y',log_time)";
   NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logDateCount = (char *) sqlite3_column_text(query_stmt, 0);
        NSString *weeklyLogCount = [[NSString alloc] initWithUTF8String:logDateCount];
        
        char *logDate = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *weeklyLogDate = [[NSString alloc] initWithUTF8String:logDate];
         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:weeklyLogCount,weeklyLogDate, nil];
        [oneWeekLog addEntriesFromDictionary:dict];
     
    }
    
    NSLog(@"week log%@=",oneWeekLog);
    [self closeDB];
    }
    return oneWeekLog;
}

-(NSDictionary *) monthLogChart:(NSString *)firstDayOfTheMonth
                 lastDayOfMonth:(NSString *)lastDayOfMonth
{
    NSMutableDictionary *oneWeekLog = [[NSMutableDictionary alloc]init];
    if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
       NSString *selectSQL = [NSString stringWithFormat:@"Select count(log_time),strftime('%%d/%%m',log_time)  from logDateDetails  where log_time BETWEEN '%@' AND '%@' group by strftime('%%d %%m %%Y',log_time)",firstDayOfTheMonth,lastDayOfMonth];
   // NSString *selectSQL = @"Select count(log_time),strftime('%d/%m',log_time)  from logDateDetails  where log_time BETWEEN '2016-01-06' AND '2016-01-31' group by strftime('%d %m %Y',log_time)";
    NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logDateCount = (char *) sqlite3_column_text(query_stmt, 0);
        NSString *weeklyLogCount = [[NSString alloc] initWithUTF8String:logDateCount];
        
        char *logDate = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *weeklyLogDate = [[NSString alloc] initWithUTF8String:logDate];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:weeklyLogCount,weeklyLogDate, nil];
        [oneWeekLog addEntriesFromDictionary:dict];
        
    }
    
    NSLog(@"week log%@=",oneWeekLog);
    [self closeDB];
    }
    return oneWeekLog;
}

-(NSDictionary *) yearlyLogChart:(NSString *)currentYear
{
    NSMutableDictionary *yearlyLog = [[NSMutableDictionary alloc]init];
     if(sqlite3_open([_dbPathString UTF8String], &database)== SQLITE_OK) {
         NSString *selectSQL = [NSString stringWithFormat:@"Select count(log_time),strftime('%%m/%%Y',log_time)  from logDateDetails  where strftime('%%Y',log_time)='%@'  group by strftime('%%m %%Y',log_time)",currentYear];
  // NSString *selectSQL = @"Select count(log_time),strftime('%m/%Y',log_time)  from logDateDetails  where strftime('%Y',log_time)='2015'  group by strftime('%m %Y',log_time)";
     NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *yearlyLogDateCount = (char *) sqlite3_column_text(query_stmt, 0);
        NSString *yearlyLogCount = [[NSString alloc] initWithUTF8String:yearlyLogDateCount];
        
        char *logDate = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *yearlyLogDate = [[NSString alloc] initWithUTF8String:logDate];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:yearlyLogCount,yearlyLogDate, nil];
        [yearlyLog addEntriesFromDictionary:dict];
        
    }
    
    NSLog(@"yearly log%@=",yearlyLog);
    [self closeDB];
     }
    return yearlyLog;
}

@end
