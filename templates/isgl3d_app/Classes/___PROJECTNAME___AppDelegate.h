//
//  ___PROJECTNAME___AppDelegate.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Isgl3dViewController;

@interface ___PROJECTNAME___AppDelegate : NSObject <UIApplicationDelegate> {

@private
    Isgl3dViewController * _viewController;
	UIWindow * _window;
}

@property (readonly, nonatomic) UIWindow * window; 
@property (readonly, nonatomic) Isgl3dViewController * viewController; 

@end
