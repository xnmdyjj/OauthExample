//
//  OauthExampleAppDelegate.m
//  OauthExample
//
//  Created by cybercom on 09-12-24.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "OauthExampleAppDelegate.h"


@implementation OauthExampleAppDelegate

@synthesize window;
@synthesize oauthController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	OauthViewController *aController = [[OauthViewController alloc] init];
	self.oauthController = aController;
	[aController release];
	[window addSubview:oauthController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[oauthController release];
    [window release];
    [super dealloc];
}


@end
