#import "isgl3d.h"
@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, Isgl3dRenderPhaseCallback> {

@private
	RootViewController * _viewController;
	UIWindow * _window;
}

@property (nonatomic, readonly) UIWindow * window;

- (void) preRender;
- (void) postRender;

@end
