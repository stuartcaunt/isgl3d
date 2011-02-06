#import "Isgl3dFpsDisplay.h"

@implementation Isgl3dFpsDisplay


- (id) initWithView:(Isgl3dView3D *)view {
	
    if (self = [super init]) {

		_view = [view retain];
		_fpsTracer = [[Isgl3dFpsTracer alloc] init];
		_added = NO;
		_position = CGPointMake(8, 290);
		_counter = 0;
    }
	
    return self;
}

- (void) dealloc {
	[_view release];
	[_fpsLabel release]; 
	
	[super dealloc];
}

- (void) update {
	Isgl3dFpsTracingInfo fpsTracingInfo = [_fpsTracer tick];

	if (_added) {
	
		if (_counter++ == 10) {
			[_fpsLabel setText:[NSString stringWithFormat:@"%3.1f", fpsTracingInfo.fps]];
			_counter = 0;
		}
		
	} else {
		// Get ui
		if (!_view.activeUI) {
			Isgl3dGLUI * ui = [[Isgl3dGLUI alloc] initWithView:_view];
			_view.activeUI = [ui autorelease];
		} 

		// add fps label
		_fpsLabel = [[Isgl3dGLUILabel alloc] initWithText:@"0.0" fontName:@"Arial" fontSize:24];
		[_view.activeUI addComponent:_fpsLabel];
		[_fpsLabel setX:_position.x andY:_position.y];
		_fpsLabel.z = -20;
		_fpsLabel.transparent = YES;
		
		_added = YES;
	}
}

- (CGPoint) position {
	return _position;
}

- (void) setPosition:(CGPoint)position {
	_position = position;
	[_fpsLabel setX:position.x andY:position.y];
}

@end
	