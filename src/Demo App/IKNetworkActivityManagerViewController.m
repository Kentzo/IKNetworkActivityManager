#import "IKNetworkActivityManagerViewController.h"
#import "IKConnectionDelegate.h"
#import "IKNetworkActivityManager.h"


@implementation IKNetworkActivityManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView1.layer.borderWidth = 1.0;
    imageView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView2.layer.borderWidth = 1.0;
    imageView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView3.layer.borderWidth = 1.0;
    imageView4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageView4.layer.borderWidth = 1.0;
    
    NSArray *imageViews = [NSArray arrayWithObjects:imageView1, imageView2, imageView3, imageView4, nil];
    NSArray *progressViews = [NSArray arrayWithObjects:progressView1, progressView2, progressView3, progressView4, nil];
    NSArray *indicators = [NSArray arrayWithObjects:activityIndicator1, activityIndicator2, activityIndicator3, activityIndicator4, nil];
    NSArray *URLs = [NSArray arrayWithObjects:[NSURL URLWithString:@"http://www.vseoboi.com/wp/big/art/dali-sleep.jpg"],
                     [NSURL URLWithString:@"http://www.vseoboi.com/wp/big/art/salvador_dali5.jpg"],
                     [NSURL URLWithString:@"http://www.1zoom.ru/big2/95/177604-frederika.jpg"],
                     [NSURL URLWithString:@"http://www.neoteo.com/Portals/0/imagenes/cache/5321x1024y768.jpg"], nil];
    
    NSUInteger i;
    for (i=0; i<4; ++i) {
        // We are loading images so we can use imageView as a network user
        [[IKNetworkActivityManager sharedInstance] addNetworkUser:[imageViews objectAtIndex:i]];
        
        IKConnectionProgressHandlerBlock progressHandler = ^(long long downloadedLength, long long maximumLength) {
            float progress = ((float)downloadedLength)/maximumLength;
            dispatch_async(dispatch_get_main_queue(), ^{
                ((UIProgressView *)[progressViews objectAtIndex:i]).progress = progress;
            });
        };
        
        IKConnectionCompletionBlock completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
            // Remove imageView from the network users after image is loaded
            [[IKNetworkActivityManager sharedInstance] removeNetworkUser:[imageViews objectAtIndex:i]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error == nil) {
                    ((UIImageView *)[imageViews objectAtIndex:i]).image = image;
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:1.0f];
                    ((UIProgressView *)[progressViews objectAtIndex:i]).alpha = 0.0f;
                    ((UIActivityIndicatorView *)[indicators objectAtIndex:i]).alpha = 0.0f;
                    ((UIImageView *)[imageViews objectAtIndex:i]).alpha = 1.0f;
                    [UIView commitAnimations];
                }
                else {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Download Image"
                                                                         message:[error localizedDescription]
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                    [errorAlert show];
                    [errorAlert release];
                }
            });
        };
        
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[URLs objectAtIndex:i]]
                                                                   delegate:[IKConnectionDelegate connectionDelegateWithProgressHandler:progressHandler
                                                                                                                             completion:completion]];
    }
}

@end
