//
//  ViewController.m
//  BlockExamples
//
//  Created by Yury Lushkinov on 3/28/19.
//  Copyright © 2019 Yury Lushkinov. All rights reserved.
//

#import "ViewController.h"
#import "BlockExamples.h"
#import "BlocksExapmlesARC.h"

typedef void (^AnimationBlock)(void);

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, copy) AnimationBlock animationBlock;

@end


@implementation ViewController

-(void)dealloc {
    [_animationBlock release];

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.animationBlock = ^{
        CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, 10, 10);
        CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        CGAffineTransform hybridTransform = CGAffineTransformConcat(rotateTransform, scaleTransform);
        _label.transform = hybridTransform;
        _label.center = self.view.center;
    };

    BlockExamples *example = [BlockExamples new];
    [example example];
    [example release];

    BlocksExapmlesARC *arcExample = [BlocksExapmlesARC new];
    [arcExample execute];
    [arcExample release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self animate];
//    [self animateWithBlock];
}

-(void)animate {
//    [UIView animateWithDuration:8.0 animations:^{
//        CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, 10, 10);
//        CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
//        CGAffineTransform hybridTransform = CGAffineTransformConcat(rotateTransform, scaleTransform);
//        _label.transform = hybridTransform;
//        _label.center = self.view.center;
//    }];
    [UIView animateWithDuration:8.0 animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity, 10, 10);
        CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        CGAffineTransform hybridTransform = CGAffineTransformConcat(rotateTransform, scaleTransform);
        _label.transform = hybridTransform;
        _label.center = self.view.center;
    } completion:^(BOOL finished) {
        _label.text = @"end";
        _label.backgroundColor = [UIColor orangeColor];
    }];
}

- (void) animateWithBlock {
    [UIView animateWithDuration:8.0 animations:self.animationBlock];
}


@end
