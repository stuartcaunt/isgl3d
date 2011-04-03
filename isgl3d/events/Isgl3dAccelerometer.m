/*
 * iSGL3D: http://isgl3d.com
 *
 * Copyright (c) 2010-2011 Stuart Caunt
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "Isgl3dAccelerometer.h"

#define LOWPASS_FILTER_VALUE 0.1

static Isgl3dAccelerometer * _instance = nil;

@interface Isgl3dAccelerometer ()
- (void) calculateGravity;
- (void) calibrateTilt;
@end

@implementation Isgl3dAccelerometer

@synthesize deviceOrientation = _deviceOrientation;
@synthesize isCalibrating = _isCalibrating;
@synthesize tiltCutoff = _tiltCutoff;

- (id) init {

	if ((self = [super init])) {
		_updateFrequency = 30;
		
		_isCalibrating = NO;
		_tiltActive = NO;
		_tiltCutoff = 0;
	}
	
	return self;
}

- (void) dealloc {
	
    [super dealloc];
}

+ (Isgl3dAccelerometer *) sharedInstance {
	
	@synchronized (self) {
		if (!_instance) {
			_instance = [[Isgl3dAccelerometer alloc] init];
		}
	}
		
	return _instance;
}

+ (void) resetInstance {
	if (_instance) {
		[_instance release];
		_instance = nil;
	}
}

- (void) setup:(float)updateFrequency {
	//Configure and start accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / updateFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	_updateFrequency = updateFrequency;
}

- (void) setUpdateFrequency:(float)updateFrequency {
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / updateFrequency)];
	_updateFrequency = updateFrequency;
}

- (float) updateFrequency {
	return _updateFrequency;
}

- (float *) gravity {
	return _gravity;
}

- (float *) rawGravity {
	return _rawGravity;
}

- (float *) acceleration {
	return _acceleration;
}

- (void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {

	// Store raw data, modified with device rotation
	if (_deviceOrientation == Isgl3dOrientation0) {
	    _acceleration[0] = acceleration.x;
	    _acceleration[1] = acceleration.y;
	    _acceleration[2] = acceleration.z;
		
	} else if (_deviceOrientation == Isgl3dOrientation90Clockwise) {
	    _acceleration[0] = acceleration.y;
	    _acceleration[1] = -acceleration.x;
	    _acceleration[2] = acceleration.z;
		
	} else if (_deviceOrientation == Isgl3dOrientation180) {
	    _acceleration[0] = -acceleration.x;
	    _acceleration[1] = -acceleration.y;
	    _acceleration[2] = acceleration.z;
		
	} else if (_deviceOrientation == Isgl3dOrientation90CounterClockwise) {
	    _acceleration[0] = -acceleration.y;
	    _acceleration[1] = acceleration.x;
	    _acceleration[2] = acceleration.z;
	}


	if (_isCalibrating) {
		// normalise gravity
		float length = sqrtf(_acceleration[0] * _acceleration[0] + _acceleration[1] * _acceleration[1] + _acceleration[2] * _acceleration[2]);
	    _acceleration[0] /= length;
	    _acceleration[1] /= length;
	    _acceleration[2] /= length;
	    
	    // ... then calibrate tilt
		[self calibrateTilt];
	} else {
		
		// Calculate gravity first...
		[self calculateGravity];

		// ... then normalise gravity
		float length = sqrtf(_acceleration[0] * _acceleration[0] + _acceleration[1] * _acceleration[1] + _acceleration[2] * _acceleration[2]);
	    _acceleration[0] /= length;
	    _acceleration[1] /= length;
	    _acceleration[2] /= length;
	}
	
}

- (void) startTiltCalibration {
	_calibrationSampleNumber = 0;
	_isCalibrating = YES;
}


- (void) calculateGravity {

    _rawGravity[0] = (_acceleration[0] * LOWPASS_FILTER_VALUE) + _rawGravity[0] * (1.0 - LOWPASS_FILTER_VALUE);
    _rawGravity[1] = (_acceleration[1] * LOWPASS_FILTER_VALUE) + _rawGravity[1] * (1.0 - LOWPASS_FILTER_VALUE);
    _rawGravity[2] = (_acceleration[2] * LOWPASS_FILTER_VALUE) + _rawGravity[2] * (1.0 - LOWPASS_FILTER_VALUE);

	if (_tiltActive) {
	    _gravity[0] = (_acceleration[0] * LOWPASS_FILTER_VALUE) + _gravity[0] * (1.0 - LOWPASS_FILTER_VALUE);

		float gravY =  _cosTilt * _acceleration[1] + _sinTilt * _acceleration[2];
		float gravZ = -_sinTilt * _acceleration[1] + _cosTilt * _acceleration[2];

	    _gravity[1] = gravY * LOWPASS_FILTER_VALUE + _gravity[1] * (1.0 - LOWPASS_FILTER_VALUE);
	    _gravity[2] = gravZ * LOWPASS_FILTER_VALUE + _gravity[2] * (1.0 - LOWPASS_FILTER_VALUE);

		
	} else {
		_gravity[0] = _rawGravity[0];
		_gravity[1] = _rawGravity[1];
		_gravity[2] = _rawGravity[2];
	}

}

- (void) calibrateTilt {
	_calibrationY[_calibrationSampleNumber] = _acceleration[1];
	_calibrationZ[_calibrationSampleNumber] = _acceleration[2];

	_calibrationSampleNumber++;
	
	if (_calibrationSampleNumber == ACCELEROMETER_CALIBRATION_MAX) {
		float sumCalibrationY = 0;
		float sumCalibrationZ = 0;
		for (unsigned int i = 0; i < ACCELEROMETER_CALIBRATION_MAX; i++) {
			sumCalibrationY += _calibrationY[i];
			sumCalibrationZ += _calibrationZ[i];
		}
		
		float meanCalibrationY = sumCalibrationY / ACCELEROMETER_CALIBRATION_MAX;
		float meanCalibrationZ = sumCalibrationZ / ACCELEROMETER_CALIBRATION_MAX;
		
		float tilt = atan(meanCalibrationZ / meanCalibrationY);
		_cosTilt = cos(tilt);
		_sinTilt = sin(tilt);
		
		_isCalibrating = NO;
		_tiltActive = YES;
		
		[self calculateGravity];
	}
}

- (float) tiltAngle {
	if (_isCalibrating) {
		return 0;
	}
	return acos(-_rawGravity[2]);
}

- (float) rotationAngle {
	if (_isCalibrating) {
		return 0;
	}
	
	if ([self tiltAngle] * 180 / M_PI < _tiltCutoff) {
		return 0;
	} else {
		return atan2(_rawGravity[0], -_rawGravity[1]);
	}
}

@end
