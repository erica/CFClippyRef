/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "ClippyHelper.h"

#define COOKBOOK_PURPLE_COLOR [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define RECTCENTER(rect) CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))

@interface TestBedViewController : UIViewController
{
    UIImageView *imageView;
    ClippyHelper *helper;
    
    int index;
}
@end

@implementation TestBedViewController

- (void) tick
{
    NSString *animation = [helper.animationNames objectAtIndex:index];
    [helper addAnimation:animation to:imageView repeats:NO];
    self.title = animation;
    
    index = (index + 1) % helper.animationNames.count;
    
    if (imageView.animationImages)
        [NSTimer scheduledTimerWithTimeInterval:(3.0f + (imageView.animationImages.count * 0.2f)) target:self selector:@selector(tick) userInfo:nil repeats:NO];
    else
        [self tick];
}

- (void) loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    helper = [ClippyHelper helper];
    imageView = [helper baseImageView];
    imageView.center = RECTCENTER(self.view.bounds);
    [self.view addSubview:imageView];
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(tick));    
}

- (void) viewDidAppear:(BOOL)animated
{
    
    // someView.frame = self.view.bounds;
    imageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

- (void) viewDidLayoutSubviews
{
    [self viewDidAppear:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end

#pragma mark -

#pragma mark Application Setup
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
}
@end
@implementation TestBedAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{	
    // [application setStatusBarHidden:YES];
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    window.rootViewController = nav;
	[window makeKeyAndVisible];
    return YES;
}
@end
int main(int argc, char *argv[]) {
    @autoreleasepool {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}