//
//  ViewController.m
//  BreathAnimation
//
//  Created by sunyazhou on 2018/9/29.
//  Copyright © 2018 Kwai, Inc. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

static NSString *const kBreathAnimationKey  = @"BreathAnimationKey";
static NSString *const kBreathAnimationName = @"BreathAnimationName";
static NSString *const kBreathScaleName     = @"BreathScaleName";

CGFloat kHeartSizeWidth = 100.0f;
CGFloat kHeartSizeHeight = 100.0f;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *heartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(kHeartSizeWidth));
        make.height.equalTo(@(kHeartSizeHeight));
    }];
    [self addBreathAnimation];
}

/**
 *  按钮呼吸动画
 */
- (void)addBreathAnimation
{
    if (![self.heartView.layer animationForKey:kBreathAnimationKey] && _heartView) {
        CALayer *layer = [CALayer layer];
        layer.position = CGPointMake(kHeartSizeWidth/2.0f, kHeartSizeHeight/2.0f);
        layer.bounds = CGRectMake(0, 0, kHeartSizeWidth/2.0f, kHeartSizeHeight/2.0f);
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"breathImage"].CGImage);
        layer.contentsGravity = kCAGravityResizeAspect;
        [self.heartView.layer addSublayer:layer];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@1.f, @1.4f, @1.f];
        animation.keyTimes = @[@0.f, @0.5f, @1.f];
        animation.duration = 1; //1000ms
        animation.repeatCount = FLT_MAX;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animation setValue:kBreathAnimationKey forKey:kBreathAnimationName];
        [layer addAnimation:animation forKey:kBreathAnimationKey];
        
        CALayer *breathLayer = [CALayer layer];
        breathLayer.position = layer.position;
        breathLayer.bounds = layer.bounds;
        breathLayer.backgroundColor = [UIColor clearColor].CGColor;
        breathLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"breathImage"].CGImage);
        breathLayer.contentsGravity = kCAGravityResizeAspect;
//        [self.heartView.layer addSublayer:breathLayer];
        [self.heartView.layer insertSublayer:breathLayer below:layer];

        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@1.f, @2.4f];
        scaleAnimation.keyTimes = @[@0.f,@1.f];
        scaleAnimation.duration = animation.duration;
        scaleAnimation.repeatCount = FLT_MAX;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animation];
        opacityAnimation.keyPath = @"opacity";
        opacityAnimation.values = @[@1.f, @0.f];
        opacityAnimation.duration = 0.4f;
        opacityAnimation.keyTimes = @[@0.f, @1.f];
        opacityAnimation.repeatCount = FLT_MAX;
        opacityAnimation.duration = animation.duration;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

        CAAnimationGroup *scaleOpacityGroup = [CAAnimationGroup animation];
        scaleOpacityGroup.animations = @[scaleAnimation, opacityAnimation];
        scaleOpacityGroup.removedOnCompletion = NO;
        scaleOpacityGroup.fillMode = kCAFillModeForwards;
        scaleOpacityGroup.duration = animation.duration;
        scaleOpacityGroup.repeatCount = FLT_MAX;
        [breathLayer addAnimation:scaleOpacityGroup forKey:kBreathScaleName];
    }
}

- (void)shakeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.0f, @0.8f, @1.f];
    animation.keyTimes = @[@0.f,@0.5f, @1.f];
    animation.duration = 0.35f;
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.heartView.layer addAnimation:animation forKey:@""];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self shakeAnimation];
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}


@end
