#import "isgl3d.h"


@interface Isgl3dFpsDisplay : NSObject {

@private
	Isgl3dView3D * _view;

	Isgl3dFpsTracer * _fpsTracer;
	Isgl3dGLUILabel * _fpsLabel;
	
	CGPoint _position;
	BOOL _added;
	int _counter;
}

@property (nonatomic) CGPoint position;

- (id) initWithView:(Isgl3dView3D *)view;

- (void) update;
- (CGPoint) position;
- (void) setPosition:(CGPoint)position;

@end
