//
//  HelloWorldView.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "isgl3d.h"

@interface HelloWorldView : Isgl3dView3D {

@private
	// The root scene node. 
	Isgl3dScene3D * _scene;
	
	// The rendered text
	Isgl3dMeshNode * _3dText;

	// The fps display
	Isgl3dFpsDisplay * _fpsDisplay;
}

@end



