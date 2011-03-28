#import "isgl3d.h"


@interface SandboxCameraController : NSObject <Isgl3dTouchScreenResponder> {

@private
	Isgl3dCamera * _camera;
	Isgl3dView * _view;
	
	Isgl3dNode * _target;
	
	float _orbit;
	float _orbitMin;
	float _vTheta;
	float _vPhi;
	float _theta;
	float _phi;	
	float _damping;
	BOOL _doubleTapEnabled;
}

@property (nonatomic, retain) Isgl3dNode * target;
@property (nonatomic) float orbit;
@property (nonatomic) float orbitMin;
@property (nonatomic) float theta;
@property (nonatomic) float phi;
@property (nonatomic) float damping;
@property (nonatomic) BOOL doubleTapEnabled;

- (id) initWithCamera:(Isgl3dCamera *)camera andView:(Isgl3dView *)view;

- (void) update;

@end
