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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "isgl3dTypes.h"

#define ACCELEROMETER_CALIBRATION_MAX 20

/**
 * The Isgl3dAccelerometer provides a simplified access to the accelerometer embeded in the device.
 * 
 * As well as providing the current acceleration of the device, the Isgl3dAccelerometer provides a filter
 * to extract a vector for the current gravity measued by the device. For example when the device is held
 * vertically, the gravity is in the y-direction. When horizontal, the gravity is in the z-direction.
 * 
 * The Isgl3dAccelerometer provides a calibration mechanism too to adjust the gravity vector to suit angle at
 * which the user holds the device. For example, imagine a game where the player rolls a ball across a table and 
 * controls it using the accelerometer, effectively tilting the table. By default, gravity is along the y-axis
 * when the device is vertical and no movement occurs on the ball (the table is horizontal). However this could be 
 * uncomfortable for the user who prefers the device to be slightly tilted at all times while playing. Using the 
 * calibration technique, the current position of the device is sampled several times and the gravity vector is 
 * ajusted so that the current device position is considered vertical: hence the player can have the device tilted 
 * and no movement on the ball occurs - when he tilts away from the sampled position the ball will start to roll.
 * 
 * As well as the gravity vector, the current tilt (angle around the x-axis) and rotation (angle around the z-axis) of the 
 * device can be obtained. 
 * 
 * The Isgl3dAccelerometer provides a singleton interface to ensure that only one instance is available for the
 * whole application. A new instance should never be constructed explicitly. A call to setup: should always be called
 * once (and once only) in the application to ensure that the acceleration is recalculated at regular intervals.
 */
@interface Isgl3dAccelerometer : NSObject <UIAccelerometerDelegate> {
	
	float _gravity[3];
	float _rawGravity[3];
	float _acceleration[3];
	
	float _updateFrequency;
	isgl3dOrientation _deviceOrientation;
	
	float _calibrationY[ACCELEROMETER_CALIBRATION_MAX];
	float _calibrationZ[ACCELEROMETER_CALIBRATION_MAX];
	unsigned int _calibrationSampleNumber;
	BOOL _isCalibrating;
	
	BOOL _tiltActive;
	float _cosTilt;
	float _sinTilt;
	
	float _tiltCutoff;
}

/**
 * The frequency at which the acceleration is determined. By default this is 30 times a second.
 */
@property (nonatomic) float updateFrequency;

/**
 * Returns the gravity vector as a float array of three values. This vector takes into account any
 * tilt calibration that has been performed.
 */
@property (nonatomic, readonly) float * gravity;

/**
 * Returns the raw gravity vector as a float array of three values without any tilt calibration.
 */
@property (nonatomic, readonly) float * rawGravity;

/**
 * Returns the raw acceleration of the device.
 */
@property (nonatomic, readonly) float * acceleration;

/**
 * Specified whether the orientation of the device - this changes the axes of the acceleration and gravity.
 */
@property (nonatomic) isgl3dOrientation deviceOrientation;

/**
 * Returns true if the the tilt of the device is being measured and the gravity vector
 * calibrated accordingly.
 */
@property (nonatomic, readonly) BOOL isCalibrating;

/**
 * Specified the maximum title angle of the device for which the rotation of the device
 * should be calculed. As the device is close to horizontal the margin of effor of the calculation
 * of the rotation increases drastically and can produce spurious results. Above this angle, since the 
 * rotation cannot be measured effectively, a value of 0 is returned.
 */
@property (nonatomic) float tiltCutoff;

/**
 * Returns the singleton instance of the Isgl3dAccelerometer.
 * @return The singleton instance of the Isgl3dAccelerometer.
 */
+ (Isgl3dAccelerometer *) sharedInstance;

/**
 * Resets the singleton instance of the Isgl3dAccelerometer. All values return to their defaults.
 */
+ (void) resetInstance;

/**
 * Should always be called once by the application. The Isgl3dAccelerometer is associated with the 
 * UIAccelerometer after this call.
 * @param updateFrequency The frequency at which the acceleration should be recalculated. The default is 
 * for 30 times a second.
 */
- (void) setup:(float) updateFrequency;

/**
 * Starts the tilt calibration. This lasts for 20 cycles, after which the gravity vector is modified. The rawGravity
 * vector always contains the gravity as determined by the device.
 */
- (void) startTiltCalibration;

/**
 * Returns the rotation angle (angle about the z-axis) of the device. If a tiltCutoff has been specified and the current
 * tilt angle is less than this, then the rotation angle is returned as 0.
 * @return the rotation angle in degrees.
 */
- (float) rotationAngle;

/**
 * Returns the tilt angle (angle about the x-axis) of the device.
 * @return the tilt angle in degrees.
 */
- (float) tiltAngle;

/*
 * Implementation of the UIAccelerometerDelegate protocol. 
 */
- (void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;

@end
