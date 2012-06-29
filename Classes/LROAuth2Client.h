//
//  LROAuth2Client.h
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LROAuth2ClientDelegate.h"

@class LROAuth2AccessToken;

@interface LROAuth2Client : NSObject {
 @private
	NSMutableArray *requests;
  BOOL isVerifying;
	NSOperationQueue *networkQueue;

}
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSURL *redirectURL;
@property (nonatomic, copy) NSURL *cancelURL;
@property (nonatomic, copy) NSURL *userURL;
@property (nonatomic, copy) NSURL *tokenURL;
@property (nonatomic, readonly) LROAuth2AccessToken *accessToken;
@property (nonatomic, unsafe_unretained) id<LROAuth2ClientDelegate> delegate;
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, strong) NSString *accessTokenKeyPath;

- (id)initWithClientID:(NSString *)clientID 
                secret:(NSString *)secret 
           redirectURL:(NSURL *)url;

- (NSURLRequest *)userAuthorizationRequestWithParameters:(NSDictionary *)additionalParameters;
- (void)verifyAuthorizationWithAccessCode:(NSString *)accessCode;
- (void)refreshAccessToken:(LROAuth2AccessToken *)accessToken;
@end

@interface LROAuth2Client (UIWebViewIntegration) <UIWebViewDelegate>
- (void)authorizeUsingWebView:(UIWebView *)webView;
- (void)authorizeUsingWebView:(UIWebView *)webView additionalParameters:(NSDictionary *)additionalParameters;
- (void)extractAccessCodeFromCallbackURL:(NSURL *)url;
@end
