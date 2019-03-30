//
//  BlocksExapmlesARC.m
//  BlockExamples
//
//  Created by Yury Lushkinov on 3/30/19.
//  Copyright © 2019 Yury Lushkinov. All rights reserved.
//

#import "BlocksExapmlesARC.h"

@interface BlocksExapmlesARC()

@property (nonatomic, copy) void(^blockProperty)(void);
@property (nonatomic, assign) int value;

@end

@implementation BlocksExapmlesARC

- (instancetype)init {
    self = [super init];
    if (self) {
        _value = 100500;
        NSLog(@"BlocksExapmlesARC init");
    }
    return self;
}

-(void)dealloc {
    NSLog(@"BlocksExapmlesARC dealoc");
}

-(void)execute {
//    [self retainCycle];
    [self retainCycleFixed];
}

- (void)retainCycle {
    self.blockProperty = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"blockProperty value = %d", self.value);
        });
    };
    self.blockProperty();
}

- (void)retainCycleFixed {
    __weak BlocksExapmlesARC *weakSelf = self;
    self.blockProperty = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"blockProperty value = %d", weakSelf.value);
        });
    };
    self.blockProperty();
}

@end
