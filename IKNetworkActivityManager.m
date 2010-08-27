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
        networkUsers = CFSetCreateMutable(kCFAllocatorDefault, capacity, &callbacks);
	lock = [NSCondition new];
    }
    return self;
}


- (void)dealloc {
    CFRelease(networkUsers);
    [lock release];
    [super dealloc];
}


- (void)addNetworkUser:(id)aUser {
    [lock lock];
    CFSetAddValue(networkUsers, aUser);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [lock unlock];
}


- (void)removeNetworkUser:(id)aUser {
    [lock lock];
    CFSetRemoveValue(networkUsers, aUser);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (CFSetGetCount(networkUsers) > 0);
    [lock unlock];
}


- (void)removeAllNetworkUsers {
    [lock lock];
    CFSetRemoveAllValues(networkUsers);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [lock unlock];
}

@end



static IKNetworkActivityManager *_instance = nil;

@implementation IKNetworkActivityManager (Singleton)

+ (IKNetworkActivityManager*)sharedInstance {
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[super allocWithZone:NULL] init];
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
