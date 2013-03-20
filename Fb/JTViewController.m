//
//  JTViewController.m
//  Fb
//
//  Created by Jonathan Twaddell on 3/20/13.
//  Copyright (c) 2013 Jonathan Twaddell. All rights reserved.
//

#import "JTViewController.h"
#import "JTAppDelegate.h"

@interface JTViewController ()
- (IBAction)performLogin:(id)sender;
- (void)updateView;
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
  

@end

@implementation JTViewController

  

- (void)updateView
{
  NSLog(@"you updated the view");
	// Do any additional setup after loading the view, typically from a nib.
  self.myLabel.text=@"you are logged in";
  //self.loginFbButton.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
      
    [self updateView];
    
    JTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
       self.myLabel.text=@"you are not logged in";

        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session, 
                                                             FBSessionState status, 
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)performLogin:(id)sender {
  NSLog(@"you want to login");
      // get the app delegate so that we can access the session property
    JTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, 
                                                         FBSessionState status, 
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
  


}
@end
