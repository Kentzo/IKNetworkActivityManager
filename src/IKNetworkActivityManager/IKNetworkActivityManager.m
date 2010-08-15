//
//  IKNetworkActivityManager.m
//  IKNetworkActivityManager
//
//  Created by Ilya Kulakov on 14.08.10.
//  Copyright 2010. All rights reserved.

#import "IKNetworkActivityManager.h"


CFStringRef _NetworkUserDescription(const void *value) {
    return (CFStringRef)NSStringFromClass([(id)value class]);
}


@implementation IKNetworkActivityManager

- (IKNetworkActivityManager *)init {
    return [self initWithCapacity:0];
}


- (IKNetworkActivityManager *)initWithCapacity:(CFIndex)capacity {
    if (self = [super init]) {
        CFSetCallBacks callbacks = {0, NULL, NULL, _NetworkUserDescription, NULL, NULL};
        _networkUsers = CFSetCreateMutable(kCFAllocatorDefault, capacity, &callbacks);
    }
    return self;
}


- (void)dealloc {
    CFRelease(_networkUsers);
    [super dealloc];
}


- (void)addNetworkUser:(id)aUser {
    CFSetAddValue(_networkUsers, aUser);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)removeNetworkUser:(id)aUser {
    CFSetRemoveValue(_networkUsers, aUser);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (CFSetGetCount(_networkUsers) > 0);
}


- (void)removeAllNetworkUsers {
    CFSetRemoveAllValues(_networkUsers);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end



static IKNetworkActivityManager *_instance;

@implementation IKNetworkActivityManager (Singleton)

+ (IKNetworkActivityManager*)sharedInstance {
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[super allocWithZone:NULL] init];
            
            // Allocate/initialize any member variables of the singleton class her
            // example
			//_instance.member = @"";
        }
    }
    return _instance;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
	return [[self sharedInstance]retain];	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

@end
