//
//  LROAuth2AccessToken.m
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LROAuth2AccessToken.h"

@interface LROAuth2AccessToken ()
@property (nonatomic, copy) NSDictionary *authResponseData;
- (void)extractExpiresAtFromResponse;
@end

#pragma mark -

@implementation LROAuth2AccessToken

@dynamic accessToken;
@dynamic refreshToken;
@synthesize authResponseData = _authResponseData;
@synthesize expiresAt = _expiresAt;
@synthesize accessTokenKeyPath = _accessTokenKeyPath;

- (id)initWithAuthorizationResponse:(NSDictionary *)data;
{
  if (self = [super init]) {
	 self.accessTokenKeyPath = @"access_token";
    authResponseData = [data copy];
    [self extractExpiresAtFromResponse];    
  }
  return self;
}

- (NSString *)description;
{
  return [NSString stringWithFormat:@"<LROAuth2AccessToken token:%@ expiresAt:%@>", self.accessToken, self.expiresAt];
}

- (BOOL)hasExpired;
{
  return ([[NSDate date] earlierDate:self.expiresAt] == self.expiresAt);
}

- (void)refreshFromAuthorizationResponse:(NSDictionary *)data;
{
  NSMutableDictionary *tokenData = [self.authResponseData mutableCopy];

  [tokenData setObject:[data valueForKey:@"access_token"] forKey:@"access_token"];
  [tokenData setObject:[data objectForKey:@"expires_in"]  forKey:@"expires_in"];
  
  [self setAuthResponseData:tokenData];
  [self extractExpiresAtFromResponse];
}

- (void)extractExpiresAtFromResponse
{
  NSTimeInterval expiresIn = (NSTimeInterval)[[self.authResponseData objectForKey:@"expires_in"] intValue];
  _expiresAt = [[NSDate alloc] initWithTimeIntervalSinceNow:expiresIn];
}

#pragma mark -
#pragma mark Dynamic accessors

- (NSString *)accessToken;
{
	return [authResponseData valueForKeyPath:self.accessTokenKeyPath];
}

- (NSString *)refreshToken;
{
  return [authResponseData objectForKey:@"refresh_token"];
}

#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:authResponseData forKey:@"data"];
  [aCoder encodeObject:self.expiresAt forKey:@"expiresAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super init]) {
    authResponseData = [[aDecoder decodeObjectForKey:@"data"] copy];
    _expiresAt = [aDecoder decodeObjectForKey:@"expiresAt"];
  }
  return self;
}

@end
