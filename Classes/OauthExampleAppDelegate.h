//
//  OauthExampleAppDelegate.h
//  OauthExample
//
//  Created by cybercom on 09-12-24.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OauthViewController.h"

@interface OauthExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	OauthViewController *oauthController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) OauthViewController *oauthController;

@end

