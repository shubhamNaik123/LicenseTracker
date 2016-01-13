//
//  WebPageViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 18/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import "WebPageViewController.h"

@interface WebPageViewController ()
{
    NSInteger rowvalue;
    NSArray *linkdetails;
    int totalCount,value;
}
@end

@implementation WebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    CGRect frame = CGRectMake (300, 350, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.color = [UIColor blackColor];
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    
    /* NSURLRequest *earthquakeURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.linkUrl]];
     
     // send the async request (note that the completion block will be called on the main thread)
     [NSURLConnection sendAsynchronousRequest:earthquakeURLRequest
     // the NSOperationQueue upon which the handler block will be dispatched:
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
     [self.webView loadRequest:earthquakeURLRequest];
     }];*/
    
    NSURL *myURL = [NSURL URLWithString:[self.linkUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
    rowvalue = self.LinkNumber;
    linkdetails = self.Links;
    totalCount = (int)[linkdetails count];
    value = (int)rowvalue + 1;
    
    NSLog(@"links=== %@",linkdetails);
    
    NSLog(@"value %d",totalCount);
    NSString *temp = [NSString stringWithFormat:@"Article %ld ",(long)value];
    NSString *lastVal = [NSString stringWithFormat:@" of %d",totalCount];
    temp = [temp stringByAppendingString: lastVal];
    [self swipeFunction];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.isMovingFromParentViewController) {
        [self.webView loadHTMLString: @"" baseURL: nil];
    }
}


-(void) swipeFunction
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.webView addGestureRecognizer:swipeLeft];
    [self.webView addGestureRecognizer:swipeRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    [self.activityIndicatorView startAnimating];
    if(swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        value = (int)rowvalue + 1;
        
        NSLog(@"value.... %d",value);
        if(value<totalCount){
            rowvalue = rowvalue + 1;
            NSURL *myURL = [NSURL URLWithString:[linkdetails[rowvalue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
            [self.webView loadRequest:request];
           
            [self animationCall];
            NSString *temp = [NSString stringWithFormat:@"Article %d ",++value];
            NSString *lastVal = [NSString stringWithFormat:@" of %d",totalCount];
            temp = [temp stringByAppendingString: lastVal];
            //self.lblArticle.text = temp;
        }
    }
    
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight) {
       value = (int)rowvalue;
        NSLog(@"value %d",(int)rowvalue);
        if(value >0){
            rowvalue = rowvalue - 1;
            NSURL *myURL = [NSURL URLWithString:[linkdetails[rowvalue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
            [self.webView loadRequest:request];
            [self animationCall];
            NSString *temp = [NSString stringWithFormat:@"Article %d ",value];
            NSString *lastVal = [NSString stringWithFormat:@" of %d",totalCount];
            temp = [temp stringByAppendingString: lastVal];
          //  self.lblArticle.text = temp;
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   [self.activityIndicatorView stopAnimating];
}

-(void) animationCall
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];
}

@end
