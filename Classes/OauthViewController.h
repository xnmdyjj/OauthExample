//
//  OauthViewController.h
//  OauthExample
//
//  Created by cybercom on 09-12-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAToken.h"
#import "OAConsumer.h"

@interface OauthViewController : UIViewController {
	OAConsumer *consumer;
	OAToken *requestToken;
	OAToken *accessToken;
}

@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) OAToken *requestToken;
@property (nonatomic, retain) OAToken *accessToken;

@end
