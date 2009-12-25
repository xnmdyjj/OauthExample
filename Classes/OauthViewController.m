//
//  OauthViewController.m
//  OauthExample
//
//  Created by cybercom on 09-12-24.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OauthViewController.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OAPlaintextSignatureProvider.h"

static NSString *const  AUTHORIZATION_URL = @"http://www.douban.com/service/auth/authorize";

@implementation OauthViewController

@synthesize consumer;
@synthesize requestToken;
@synthesize accessToken;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIView *aView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = aView;
	[aView release];
	
	
	UIButton *obtainUnauthTokenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	obtainUnauthTokenButton.frame = CGRectMake(20.0, 40.0, 280.0, 40.0);
	obtainUnauthTokenButton.backgroundColor = [UIColor clearColor];
	[obtainUnauthTokenButton setTitle:@"Get Unauthorized Request Token" forState:UIControlStateNormal];
	[obtainUnauthTokenButton addTarget:self action:@selector(obtainUnauthTokenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:obtainUnauthTokenButton];
	
	
	UIButton *authorizeTokenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	authorizeTokenButton.frame = CGRectMake(20.0, 100.0, 280.0, 40.0);
	authorizeTokenButton.backgroundColor = [UIColor clearColor];
	[authorizeTokenButton setTitle:@"Authorizing the Request Token" forState:UIControlStateNormal];
	[authorizeTokenButton addTarget:self action:@selector(authorizeTokenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:authorizeTokenButton];
	
	UIButton *getAccessTokenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	getAccessTokenButton.frame = CGRectMake(20.0, 160.0, 280.0, 40.0);
	getAccessTokenButton.backgroundColor = [UIColor clearColor];
	[getAccessTokenButton setTitle:@"Get an Access Token" forState:UIControlStateNormal];
	[getAccessTokenButton addTarget:self action:@selector(getAccessTokenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:getAccessTokenButton];
	
	UIButton *accessResourcesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	accessResourcesButton.frame = CGRectMake(20.0, 220.0, 280.0, 40.0);
	accessResourcesButton.backgroundColor = [UIColor clearColor];
	[accessResourcesButton setTitle:@"Accessing Protected Resources" forState:UIControlStateNormal];
	[accessResourcesButton addTarget:self action:@selector(accessResourcesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:accessResourcesButton];
	
	
	UIButton *testGDataButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	testGDataButton.frame = CGRectMake(20.0, 280.0, 280.0, 40.0);
	testGDataButton.backgroundColor = [UIColor clearColor];
	[testGDataButton setTitle:@"test GData" forState:UIControlStateNormal];
	[testGDataButton addTarget:self action:@selector(testGDataButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:testGDataButton];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)obtainUnauthTokenButtonPressed:(id)sender {
	OAConsumer *theConsumer = [[OAConsumer alloc] initWithKey:@"0d3a338906fa819f27ae9a9b14ef84dd"
                                                    secret:@"3a2969a5dcbbee34"];
	self.consumer = theConsumer;
	[theConsumer release];
	
    NSURL *url = [NSURL URLWithString:@"http://www.douban.com/service/auth/request_token"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
	
    [request setHTTPMethod:@"POST"];
	
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
	[request release];
	[fetcher release];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		OAToken *aToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[responseBody release];
		self.requestToken = aToken;
		[aToken release];
		
		NSLog(@"token key = %@", requestToken.key);
		NSLog(@"token secret = %@", requestToken.secret);
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"get unauth token error");
}

-(void)authorizeTokenButtonPressed:(id)sender {
	NSString *authorizeUrlString = [AUTHORIZATION_URL stringByAppendingFormat:@"?oauth_token=%@", requestToken.key];
	NSLog(@"authorizeUrlString = %@", authorizeUrlString);
}


-(void)getAccessTokenButtonPressed:(id)sender {	
    NSURL *url = [NSURL URLWithString:@"http://www.douban.com/service/auth/access_token"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:requestToken   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
	
    [request setHTTPMethod:@"POST"];
	
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	[request release];
	[fetcher release];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		OAToken *aToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		[responseBody release];
		self.accessToken = aToken;
		[aToken release];
		[accessToken storeInUserDefaultsWithServiceProviderName:@"yujianjun" prefix:@"douban-objective-c"];
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"get access token error");
}

-(void)accessResourcesButtonPressed:(id)sender {
	NSURL *url = [NSURL URLWithString:@"http://api.douban.com/book/subject/1220562"];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:accessToken
                                                                      realm:nil
                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    
    OARequestParameter *nameParam = [[OARequestParameter alloc] initWithName:@"apikey"
                                                                       value:@"0d3a338906fa819f27ae9a9b14ef84dd"];
    
    NSArray *params = [NSArray arrayWithObjects:nameParam, nil];
    [request setParameters:params];
	[nameParam release];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
	[request release];
	[fetcher release];
}	

-(void)apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if ([ticket didSucceed]) {
		NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"reponseBody = %@", responseBody);
		[responseBody release];
	}
}

-(void)apiTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
	NSLog(@"access resources error");
}


-(void)testGDataButtonPressed:(id)sender {
	
}

- (void)dealloc {
	[consumer release];
	[requestToken release];
	[accessToken release];
    [super dealloc];
}


@end
