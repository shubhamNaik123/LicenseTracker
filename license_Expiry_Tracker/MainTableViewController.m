//
//  MainTableViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import "MainTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomeClass.h"
@interface MainTableViewController ()
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *imagelink, *description, *contentLink;
    NSString *element, *resultString, *ActualUrl;
    NSMutableArray *links;
    NSURL *url;
}
@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblListAll.dataSource = self;
    self.tblListAll.delegate =self;
    CGRect frame = CGRectMake (300, 350, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    
    
    feeds = [[NSMutableArray alloc]init];
    if([self.btnName isEqualToString:@"News"])
    {
        url = [NSURL URLWithString:@"http://www.ozarkareanetwork.com/category/app-feed/feed/rss2"];
    } else
    {
        if([self.btnName isEqualToString:@"Orbits"])
            url = [NSURL URLWithString:@"http://www.ozarkareanetwork.com/category/obits/feed/rss2"];
        else
        {
            if([self.btnName isEqualToString:@"Sports"])
                url = [NSURL URLWithString:@"http://www.ozarkareanetwork.com/category/sports/feed/rss2"];
            else
                url = [NSURL URLWithString:@"http://www.ozarkareanetwork.com/category/birthdays-anniversaries/feed/rss2"];
        }
    }
    
    [self loadData];
   }


- (void) loadData
{
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(loadDataWithOperation)
                                                                              object:nil];
    [queue addOperation:operation];
    
}

-(void) loadDataWithOperation
{
    [self.activityIndicatorView startAnimating];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
    return feeds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *img = [NSURL URLWithString:[[feeds objectAtIndex:indexPath.row]objectForKey:@"imagelink"]];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *contentTitle = (UILabel *)[cell viewWithTag:102];
    contentTitle.text =[[feeds objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    
    UITextView *contentDetails = (UITextView *)[cell viewWithTag:103];
    contentDetails.text = [[feeds objectAtIndex:indexPath.row]objectForKey:@"description"];
   
    UIImageView *contentImage = (UIImageView *)[cell viewWithTag:101];
      if(![[img absoluteString] isEqualToString:@""]) {
    [contentImage sd_setImageWithURL:img
         placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
      }
      else{
          contentImage.image = [UIImage imageNamed:@"noImage"];

      }
     return cell;
  }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"testWebPage" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebParserViewController *webPageParser = segue.destinationViewController;
    
    NSMutableArray *linksList = [[NSMutableArray alloc]initWithCapacity:5];
   for(int i =0; i< [feeds count];i++)
    {
        NSString *string = [feeds[i] objectForKey:@"link"];
        NSArray *linkArr = [NSArray arrayWithObjects:string, nil];
       [linksList  addObjectsFromArray:linkArr];
      }
  
    if ([[segue identifier] isEqualToString:@"testWebPage"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey:@"link"];
        NSInteger row = indexPath.row;
        
        NSString *data =[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        webPageParser.Links = [linksList copy];
        webPageParser.LinkNumber = row;
        webPageParser.linkUrl = data;
        
    }

    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if([element isEqualToString:@"item"]) {
        
        item = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        imagelink = [[NSMutableString alloc] init];
        contentLink = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        resultString = [[NSString alloc] init];
        ActualUrl = [[NSString alloc] init];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if([element isEqualToString:@"title"]) {
        [title appendString:string];
    }
    else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
        
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.:/-"] invertedSet];
        resultString = [[link componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        [links addObject:resultString];
        
    }
    else if ([element isEqualToString:@"content:encoded"]) {
        [contentLink appendString:string];
        if([contentLink rangeOfString:@"<img"].location != NSNotFound )
        {
            NSRange firstRange = [contentLink rangeOfString:@"src=\""];
            NSRange secondRange = [[contentLink substringFromIndex:firstRange.location] rangeOfString:@"alt"];
            NSString *hashtagWord = [contentLink substringWithRange:NSMakeRange(firstRange.location, secondRange.location)];
            NSString *value1 = @"src=\"";
            NSString *value2;
            
            NSScanner *scanner = [NSScanner scannerWithString:hashtagWord];
            [scanner scanString:value1 intoString:nil];
            value2 = [hashtagWord substringFromIndex:scanner.scanLocation];
            value2 = [value2 substringToIndex:[value2 length]-2];
            ActualUrl = value2;
        }
    }
    else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    }
    
    
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:resultString forKey:@"link"];
        [item setObject:ActualUrl forKey:@"imagelink"];
        [item setObject:description forKey:@"description"];
        [feeds addObject:[item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tblListAll reloadData];
     [self.activityIndicatorView stopAnimating];
}

@end
