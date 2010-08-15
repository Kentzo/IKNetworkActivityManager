//
//  IKConnectionDelegate.h
//  IKConnectionDelegate
//
//  Created by Ilya Kulakov on 11.08.10.
//  Copyright 2010. All rights reserved.

#import <Foundation/Foundation.h>


/*
 @param downloadedDataLength Length of data that is already downloaded.
 @param maximumLength The expected length of data. NSURLResponseUnknownLength if the length cannot be determined.
 */
typedef void (^IKConnectionProgressHandlerBlock)(long long downloadedDataLength, long long maximumLength);

/*
 @param data Downloaded data.
 @param response The URL response for the connection's request.
 @param error An error object containing details of why the connection failed to load the request successfully. nil if no error is occured.
 */
typedef void (^IKConnectionCompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);

@interface IKConnectionDelegate : NSObject {
    IKConnectionProgressHandlerBlock progressHandler;
    IKConnectionCompletionBlock completion;
    dispatch_queue_t queue;
    NSMutableData *data;
    NSURLResponse *response;
@private
    NSURLConnection *_connection;
}

/*
 @abstract Executes a given block after connection loads data incrementally.
 */
@property (copy) IKConnectionProgressHandlerBlock progressHandler;
/*
 @abstract Executes a given block after connection has finished loading or failed to load its request successfully.
 */
@property (copy) IKConnectionCompletionBlock completion;
/*
 @abstract Data that connection is loaded.
 */
@property (retain, readonly) NSMutableData *data;
/*
 @abstract Response for the connection.
 */
@property (retain, readonly) NSURLResponse *response;

/*
 @abstract Creates and returns an autoreleased IKConnectionDelegate object.
 @discussion Copies given blocks.
 */
+ (IKConnectionDelegate *)connectionDelegateWithProgressHandler:(IKConnectionProgressHandlerBlock)aProgressHandler 
                                                     completion:(IKConnectionCompletionBlock)aCompletion;

/*
 @abstract Designated Initializer.
 @discussion Copies given blocks.
 */
- (IKConnectionDelegate *)initWithProgressHandler:(IKConnectionProgressHandlerBlock)aProgressHandler
                                       completion:(IKConnectionCompletionBlock)aCompletion;

@end
