//
//  WebParserViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 14/01/16.
//  Copyright © 2016 SJI. All rights reserved.
//

#import "WebParserViewController.h"
#import "TFHpple.h"
@interface WebParserViewController ()
{
    NSInteger rowvalue;
    NSArray *linkdetails;
    int totalCount,value;
    
}
@end

@implementation WebParserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rowvalue = self.LinkNumber;
    linkdetails = self.Links;
    totalCount = (int)[linkdetails count];
    value = (int)rowvalue + 1;
   
    [self swipeFunction];
    [self loadTutorials:self.linkUrl];
    [self FooterLabel];
   
    
}

-(void)FooterLabel
{
    NSString *temp = [NSString stringWithFormat:@"Article %ld ",(long)value];
    NSString *lastVal = [NSString stringWithFormat:@" of %d",totalCount];
    temp = [temp stringByAppendingString: lastVal];
    self.lblFooter.text = temp;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadTutorials:(NSString *) url{
    NSString *src = [[NSString alloc]init];
    NSURL *tutorialsUrl = [NSURL URLWithString:url];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
   TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    NSString *titleXpathQueryString = @"//title";
    NSArray *titleNodes = [tutorialsParser searchWithXPathQuery:titleXpathQueryString];
    if([titleNodes count] > 0){
    for (TFHppleElement *element in titleNodes) {
        self.txtViewTitle.text = [[element firstChild] content];
    }
    NSString *trial = [[NSString alloc]init] ;
    NSString *tutorialsXpathQueryString = @"//body/div/div/div/section/div/div/div[@class='entry-content']/p";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    for (TFHppleElement *element in tutorialsNodes) {
            for (TFHppleElement *child in element.children) {
                if ([child.content rangeOfString:@"<img"].location == NSNotFound) {
                    if (child.content != nil) {
                        trial = [ trial stringByAppendingString:child.content];
                    }
                }
                else
                {
                    NSDictionary *attibutes = child.attributes;
                    src= [attibutes objectForKey:@"src"];
                }
                
            }

        }
        if ([src isEqualToString:@""]) {
            self.webImg.image = [UIImage imageNamed:@"noImage"];
            
        } else {
            NSURL *img = [NSURL URLWithString:src];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:img];
            
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            
            self.webImg.image =tmpImage;
        }
      self.txtContent.text =  trial;
    }
    else
    {
        self.txtViewTitle.text =  @"Apologies, but the page you requested could not be found.";
        self.txtContent.text = @"";
        self.webImg.image = nil;
    }
    
    
}


-(void) swipeFunction
{
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
     if(swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        value = (int)rowvalue + 1;
        if(value<totalCount){
            rowvalue = rowvalue + 1;
            
            NSString *testing = linkdetails[rowvalue];
            [self loadTutorials:testing];
            [self animationCall];
            NSString *temp = [NSString stringWithFormat:@"Article %d ",++value];
            NSString *lastVal = [NSString stringWithFormat:@" of %d",totalCount];
            temp = [temp stringByAppendingString: lastVal];
            self.lblFooter.text = temp;
        }
    }
    
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        value = (int)rowvalue;
        if(value >0){
            rowvalue = rowvalue - 1;
            NSString *testing = linkdetails[rowvalue];
            [self loadTutorials:testing];
            [self animationCall];
            NSString *temp = [NSString stringWithFormat:@"Article %d ",value];
            NSString *lastVal = [NSString stringWithFormat:@" of %d",totalCount];
            temp = [temp stringByAppendingString: lastVal];
              self.lblFooter.text = temp;
        }
    }
}

-(void) animationCall
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
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
