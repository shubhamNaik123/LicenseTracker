//
//  SubmitStoryViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import "SubmitStoryViewController.h"

@interface SubmitStoryViewController ()
{
    NSString *localFilePath, *jPath;
}
@end

@implementation SubmitStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGPoint originalCenter;
    originalCenter = self.view.center;
    // Do any additional setup after loading the view.
    self.btnHideCancel.hidden = YES;
    
    [self.txtViewBody.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.txtViewBody.layer setBorderWidth:0.5];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.txtViewBody.layer.cornerRadius = 5;
    self.txtViewBody.clipsToBounds = YES;
    
    self.txtViewBody.text = @"Enter Your Story";
    self.txtViewBody.textColor = [UIColor lightGrayColor];
    self.txtViewBody.delegate = self;
    
    [self.txtViewBody flashScrollIndicators];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.txtViewBody.text = @"";
    self.txtViewBody.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.txtViewBody.text.length == 0 || [self.txtViewBody.text isEqualToString:@""]){
        self.txtViewBody.textColor = [UIColor lightGrayColor];
        self.txtViewBody.text = @"Enter Your Story";
        [self.txtViewBody resignFirstResponder];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    localFilePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    self.imageView.image = image;
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    self.btnHideCancel.hidden = NO;
}

- (void)showEmail:(NSString*)file {
    
    
    NSString *emailTitle = self.txtStoryTitle.text;
    NSString *messageBody = self.txtViewBody.text;
    NSArray *toRecipents = [NSArray arrayWithObject:@"shubham@sjinnovation.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    // Determine the file name and extension
    UIImage *myImage = self.imageView.image;
    if(!(myImage == nil))
    {
        NSData *myImageData = UIImagePNGRepresentation(myImage);
        [mc addAttachmentData:myImageData mimeType:@"image/png" fileName:@"cover.png"];
    }
    [self presentViewController:mc animated:YES completion:NULL];
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self displayAlert:@"E-mail cancelled."];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            [self displayAlert:@"E-mail saved."];
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {  [self displayAlert:@"E-mail sent sucessfully."];
            [self clearDetails];
            NSLog(@"Mail sent");
            break;}
        case MFMailComposeResultFailed:
            [self displayAlert:@"E-mail sent failure."];
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"RSS Feed"
                                                           message:msg
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
    [displayAlert show];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.txtUserName endEditing:YES];
    [self.txtUserEmail endEditing:YES];
    [self.txtStoryTitle endEditing:YES];
    [self.txtViewBody endEditing:YES];
    
}

-(void) displayConfirmation
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"RSS Feeds"
                                                   message:@""
                                                  delegate: self
                                         cancelButtonTitle:@"Take Photo"
                                         otherButtonTitles:@"Upload Photo", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
        
    }else if(buttonIndex == 1)
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void) clearDetails
{
    self.txtUserName.text = @"";
    self.txtUserEmail.text = @"";
    self.txtStoryTitle.text = @"" ;
    self.txtViewBody.text = @"Enter Your Story";
    self.imageView.image = nil;
    self.btnHideCancel.hidden = YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (IBAction)btnPhotoAttchment:(id)sender {
    [self displayConfirmation];
}

- (IBAction)btnCancel:(id)sender {
    self.imageView.image = nil;
    self.btnHideCancel.hidden = YES;
}

- (IBAction)btnSendMail:(id)sender {
    if([self.txtStoryTitle.text isEqual: @""] || [self.txtUserEmail.text isEqual:@""] || [self.txtUserName.text isEqual:@""])
    {
        [self displayAlert:@"One or more of the required fields is blank. Please fill in the information and resubmit the form."];
    }
    else{
        if(![self NSStringIsValidEmail:self.txtUserEmail.text])
        {
            [self displayAlert:@"The email address is in the wrong format!"];
            self.txtUserEmail.text = @"";
            
        }
        else
        {
            
            [self showEmail:localFilePath];
        }
    }
}
@end
