//
//  IKConnectionDelegate.m
//  IKConnectionDelegate
//
//  Created by Ilya Kulakov on 11.08.10.
//  Copyright 2010. All rights reserved.

#import <dispatch/dispatch.h>
#import "IKConnectionDelegate.h"


@interface IKConnectionDelegate (/* Private Stuff Here */)

@property (retain) NSMutableData *data;
@property (retain) NSURLResponse *response;
@property (retain) NSURLConnection *_connection;

@end

@implementation IKConnectionDelegate
@synthesize progressHandler;
@synthesize completion;
@synthesize data;
@synthesize response;
@synthesize _connection;

+ (IKConnectionDelegate *)connectionDelegateWithProgressHandler:(IKConnectionProgressHandlerBlock)aProgressHandler
                                                     completion:(IKConnectionCompletionBlock)aCompletion
{
    return [[[self alloc] initWithProgressHandler:aProgressHandler completion:aCompletion] autorelease];
}


- (IKConnectionDelegate *)initWithProgressHandler:(IKConnectionProgressHandlerBlock)aProgressHandler 
                                       completion:(IKConnectionCompletionBlock)aCompletion 
{
    if (self = [super init]) {
        self.progressHandler = aProgressHandler;
        self.completion = aCompletion;
        data = [NSMutableData new];
    }
    return self;
}


- (void)dealloc {
    [progressHandler release];
    [completion release];
    [data release];
    [response release];
    [super dealloc];
}


#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
    
    NSAssert(_connection == nil || _connection == connection, @"You cannot use one IKConnectionDelegate more than once");
    
    if (_connection == nil) {
        _connection = connection;
    }
    
    self.response = aResponse;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData {
    [data appendData:aData];
    progressHandler([data length], [response expectedContentLength]);
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSAssert(_connection == nil || _connection == connection, @"You cannot use one IKConnectionDelegate more than once");
    
	if ([challenge previousFailureCount] > 0) {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
	else {
		[[challenge sender] useCredential:[challenge proposedCredential] forAuthenticationChallenge:challenge];
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    completion(data, response, nil);
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)anError {
    completion(data, response, anError);
}

@end
