#import <UIKit/UIKit.h>

@class IKNetworkActivityManagerViewController;

@interface IKNetworkActivityManagerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    IKNetworkActivityManagerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet IKNetworkActivityManagerViewController *viewController;

@end

