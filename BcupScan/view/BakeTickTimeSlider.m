//
//  BakeTickTimeSlider.m
//  BakeCake
//
//  Created by zhangchong on 9/9/15.
//  Copyright (c) 2015 com.infohold.BakeCake. All rights reserved.
//

#import "BakeTickTimeSlider.h"
#import "Constants.h"


@implementation BakeTickTimeSlider
@synthesize remaindTime;
@synthesize indicatedTextField;
@synthesize indicatedTextLabelField;
@synthesize radius;
@synthesize angle;

#define CIRCLE_COLOR [UIColor colorWithRed:0.855 green:0.859 blue:0.859 alpha:1.00]
#define SOLID_CIRCLE_COLOR [UIColor colorWithRed:0.624 green:0.627 blue:0.627 alpha:1.00]



-(id)initWithFrame:(CGRect)frame endTime:(NSUInteger)_remaindTime {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.remaindTime = _remaindTime;
        self.radius = self.frame.size.width/2 - 60;
        
        self.angle = 0;
        
        NSString *indicatedText = [NSString stringWithFormat:@"%ld",remaindTime];
        CGSize indicatedTextFontSize = [indicatedText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:65]}];
        
        NSString *indicatedLabelText = @"MINUTES";
        CGSize indicatedTextLabelFontSize = [indicatedLabelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
        
        CGRect indicatedTextFieldRect = CGRectMake((frame.size.width-indicatedTextFontSize.width)/2,
                                                   (frame.size.height-indicatedTextFontSize.height-indicatedTextLabelFontSize.height)/2,
                                                   indicatedTextFontSize.width,
                                                   indicatedTextFontSize.height);
        indicatedTextField = [[UITextField alloc] initWithFrame:indicatedTextFieldRect];
        indicatedTextField.backgroundColor = [UIColor clearColor];
        indicatedTextField.textColor = MAIN_COLOR;
        indicatedTextField.textAlignment = NSTextAlignmentCenter;
        indicatedTextField.font = [UIFont systemFontOfSize:65];
        indicatedTextField.text = indicatedText;
        indicatedTextField.enabled = NO;
        [self addSubview:indicatedTextField];
        
        CGRect indicatedTextFieldLabelRect = CGRectMake((frame.size.width-indicatedTextLabelFontSize.width)/2,
                                                        (frame.size.height-indicatedTextFontSize.height-indicatedTextLabelFontSize.height)/2 +indicatedTextFontSize.height,
                                                        indicatedTextLabelFontSize.width,
                                                        indicatedTextLabelFontSize.height);
        indicatedTextLabelField = [[UITextField alloc] initWithFrame:indicatedTextFieldLabelRect];
        indicatedTextLabelField.textColor = MAIN_COLOR;
        indicatedTextLabelField.backgroundColor = [UIColor clearColor];
        indicatedTextLabelField.textAlignment = NSTextAlignmentCenter;
        indicatedTextLabelField.font = [UIFont systemFontOfSize:20];
        indicatedTextLabelField.text = indicatedLabelText;
        indicatedTextLabelField.enabled = NO;
        [self addSubview:indicatedTextLabelField];
    }
    
    return self;
}


#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //Create the path
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, M_PI *2, 0);
    
    //Set the stroke color to black
    [CIRCLE_COLOR setStroke];
    
    //Define line width and cap
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);


    /** Create THE MASK Image **/
    UIGraphicsBeginImageContext(CGSizeMake(CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds)));
    CGContextRef imageCtx = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(imageCtx, self.frame.size.width/2  , self.frame.size.height/2, radius ,ToRad(270) ,ToRad(self.angle), 1);
    [[UIColor redColor] set];
    
    //Use shadow to create the Blur effect
   // CGContextSetShadowWithColor(imageCtx, CGSizeMake(0, 0), self.angle/20, [UIColor blackColor].CGColor);
    
    //define the path
    CGContextSetLineWidth(imageCtx, 10);
    CGContextDrawPath(imageCtx, kCGPathStroke);
    
    //save the context content into the image mask
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    
    
    /** Clip Context to the mask **/
    CGContextSaveGState(ctx);
    
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    
    
    /** THE GRADIENT **/
    
    //list of components
    CGFloat components[8] = {
        0.0, 0.0, 1.0, 1.0,     // Start color - Blue
        1.0, 0.0, 1.0, 1.0 };   // End color - Violet
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, components, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    //Gradient direction
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    //Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    CGContextRestoreGState(ctx);
    
    
    /** Add some light reflection effects on the background circle**/
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //Draw the outside light
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius+10/2, ToRad(270), ToRad(self.angle), 1);
    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //draw the inner light
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius-10/2, ToRad(270), ToRad(self.angle), 1);
    [[UIColor colorWithWhite:1.0 alpha:0.05]set];
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    /** Draw the handle **/
    [self drawTheHandle:ctx];
    
}

/** Draw a white knob over the circle **/
-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);
    
    //I Love shadows
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, [UIColor blackColor].CGColor);
    
    //Get the handle position
    CGPoint handleCenter =  [self pointFromAngle: self.angle];
    
    //Draw It!
    [[UIColor colorWithWhite:1.0 alpha:0.7]set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, 10 , 10));
    
    CGContextRestoreGState(ctx);
}

#pragma mark - Math -

/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    int angleInt = floor(currentAngle);
    
    //Store the new angle
    self.angle = 360 - angleInt;
    
    float leftTime = angleInt == 0 ? 0 : self.remaindTime / 360.0  * angleInt;
    
    //Update the textfield
//    NSString *str =  [NSString stringWithFormat:@"%lf", leftTime];
    
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    formater.minimumFractionDigits = 0;
    NSString *str = [formater stringFromNumber:[NSNumber numberWithFloat:leftTime]];
    indicatedTextField.text = str;
    
    //Redraw
    [self setNeedsDisplay];
}


/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - 10/2, self.frame.size.height/2 - 10/2);
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    
    return result;
}

//Sourcecode from Apple example clockControl
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}


@end
