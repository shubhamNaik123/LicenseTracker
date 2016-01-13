//
//  ViewAllTableViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 04/01/16.
//  Copyright © 2016 SJI. All rights reserved.
//

#import "ViewAllTableViewController.h"

@interface ViewAllTableViewController ()

{
    NSMutableArray *LicenseTrackerArray, *uniqueID;
    NSMutableArray *tableData11, *tableData12;
    NSArray *searchResults, *searchDate;
    int lastOfIndex;
    NSMutableDictionary *licenseList;
    NSString *value1,*value2;
}
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ViewAllTableViewController

-(DBManager *) model
{
    if(!_model)
    {
        _model = [[DBManager alloc]init];
    }
    return _model;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self allLocalLicenseList];
    [self initializeSearchController];
    [self.tableView reloadData];
}

- (void)initializeSearchController {
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.definesPresentationContext = YES;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height) animated:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height) animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
        return [tableData11 count];
  }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
  
        cell.textLabel.text =[tableData11 objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [tableData12 objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     self.notificationID = [[uniqueID objectAtIndex:indexPath.row]intValue];
    if(self.searchController.searchResultsController)
    {
        NSInteger rowNo = indexPath.row;
        NSLog(@"Here %ld",rowNo);
        value1=[tableData11 objectAtIndex:rowNo];
        value2=[tableData12 objectAtIndex:rowNo];
        [self performSegueWithIdentifier:@"EditData" sender:self];
    }
  
   else if (tableView.editing == YES) {
        
        NSInteger rowNo = indexPath.row;
        value1=[tableData11 objectAtIndex:rowNo];
        value2=[tableData12 objectAtIndex:rowNo];
        [self performSegueWithIdentifier:@"EditData" sender:self];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    EditViewController *transferViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"EditData"]) {
        transferViewController.licenseName=value1;
        transferViewController.expiryDate = value2;
        NSLog(@"%d",self.notificationID);
        transferViewController.localNotificationID = self.notificationID;
    }
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   NSString *searchText = [self.searchController.searchBar text];
   if(![searchText length] > 0) {
        return;
    }
    else {
       [tableData11 removeAllObjects];
       if([searchText length] == 0) {
            [self allLocalLicenseList];
        }
        else if(searchText.length > 0) {
            [self filterContentForSearchText:searchText];
        }
        [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
    }
}


- (void)filterContentForSearchText:(NSString*)searchText
{
    NSMutableDictionary *filteredData = [NSMutableDictionary new];
    
    [licenseList enumerateKeysAndObjectsUsingBlock:^(id value, NSString *obj, BOOL *stop) {
        NSRange range = [value rangeOfString:searchText
                                     options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
        if (range.location != NSNotFound)
        {
            [filteredData setObject:obj forKey:value];
        }
    }];
    searchResults =[filteredData allKeys];
    searchDate = [filteredData allValues];
    [tableData11 addObjectsFromArray:searchResults];
    [tableData12 addObjectsFromArray:searchDate];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.notificationID = [[uniqueID objectAtIndex:indexPath.row]intValue];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"here====%d",[[uniqueID objectAtIndex:indexPath.row]intValue]);
       
        [self displayConfirmation];
     }
}

-(void) displayConfirmation
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"License Expiry Tracker"
                                                   message:@"Are you sure you want to delete?"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        self.btnEditLabel.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
        [self.tableView reloadData];
    }
    else if(buttonIndex == 1)
    {
        [self CancelExistingNotification];
        [self allLocalLicenseList];
        [self.tableView reloadData];
    }
}


- (IBAction)btnEdit:(id)sender {
 
    if ([self.tableView isEditing]) {
      [[self tableView] setEditing:NO animated:NO];
       self.btnEditLabel.title = @"Edit";
    }
    else {
        
        self.btnEditLabel.title = @"Done";
        [[self tableView] setEditing:YES animated:NO];
        self.tableView.allowsSelectionDuringEditing = YES;
    }
    
}

-(void) allLocalLicenseList
{
    UIApplication* objApp = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [objApp scheduledLocalNotifications];
    licenseList = [[NSMutableDictionary alloc]init];
    tableData11 = [[NSMutableArray alloc]init];
    tableData12 = [[NSMutableArray alloc]init];
    uniqueID = [[NSMutableArray alloc]init];
   for (int i = 0; i< [oldNotifications count]; i++) {
        UILocalNotification *notif = [oldNotifications objectAtIndex:i];
        NSDictionary *userInfoCurrent = notif.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"NotificationID"]];
        NSString *LicenseNameLocal=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"LicenseName"]];
        NSString *LicenseDateLocal=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"LicenseDate"]];
         NSDictionary *LicenseDetails = [NSDictionary dictionaryWithObjectsAndKeys:LicenseDateLocal,LicenseNameLocal, nil];
        [licenseList addEntriesFromDictionary:LicenseDetails];
        [uniqueID addObject:uid];
        [tableData11 addObject:LicenseNameLocal];
        [tableData12 addObject:LicenseDateLocal];
    }
}


- (void)CancelExistingNotification
{
    NSLog(@"Notification id = %d",self.notificationID);
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"NotificationID"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%i",self.notificationID]])
        {
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}

@end
