#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "ICloudSync.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    AppDelegate *appDelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;

    [appDelegate setup];

    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    [[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:appDelegate options:nil];
    [self.window setRootViewController:appDelegate.rootController];
    self.window.backgroundColor = [UIColor systemBackgroundColor];
    [self.window makeKeyAndVisible];

    [appDelegate setTabLabels];
    [appDelegate pushManagedContextToViewControllers];
    [ICloudSync start];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
}

- (void)sceneWillResignActive:(UIScene *)scene {
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
}

@end
