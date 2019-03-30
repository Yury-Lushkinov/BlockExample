//
//  BlockExamples.m
//  BlockExamples
//
//  Created by Yury Lushkinov on 3/28/19.
//  Copyright © 2019 Yury Lushkinov. All rights reserved.
//

#import "BlockExamples.h"

@interface BlockExamples()
@property (nonatomic, copy) void(^blockProperty)(void);
@end

typedef void(^SimpleBlock)(void);

@implementation BlockExamples

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.blockProperty = ^{
            NSLog(@"blockProperty body");
        };
    }
    return self;
}

-(void)dealloc {
    NSLog(@"BlockExamples dealoc");

    [_blockProperty release];

    [super dealloc];
}

- (void)example {
    self.blockProperty();
    [self globalBlock];
    [self stackBlock];
    [self mallocBlock];
    [self captureValues];
    [self changeCaptureValuesInsideBlock];
    [self blockAsParameter];
    [self blockAsParameterImpoved];
    [self containers];

}


- (void)containers {
    NSLog(@"\nArray");
    NSArray *array = @[@"4", @"1", @"3"];

    NSArray *sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];

    NSLog(@"Sorted array %@", sortedArray);

    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%d %@", (int)idx, obj);
    }];

    NSLog(@"\nDictionary");
    NSDictionary *dict = @{@"1": @(1), @"2": @(2), @"3": @(3) };

    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@ %@", key, obj);
        if ([key isEqualToString:@"2"]) {
            *stop = YES;
        }
    }];
}

-(void)func:(NSString *) string number:(int) value block:(void(^)(BOOL)) block {

}

-(void)blockAsParameterImpoved {
    [self beginWithTakeTaskBlock:^NSString *{
        return @"Digging hole";
    } resultBlock:^(BOOL success, NSString *info) {
        if (success) {
            NSLog(@"Job is done. %@", info);
        }
        else {
            NSLog(@"Job is failed. %@", info);
            NSLog(@"Trying different task");
            [self beginWithTakeTaskBlock:^NSString *{
                return @"Lunch";
            } resultBlock:^(BOOL success, NSString *info) {
                if (success) {
                    NSLog(@"Job is done. %@", info);
                }
            }];
        }
    }];
}

-(void)beginWithTakeTaskBlock:(NSString *(^)(void))takeTask resultBlock:(void(^)(BOOL, NSString *)) resultBlock {
    NSString *task = takeTask();
    NSLog(@"Working hard on task (%@)", task);
    if (task.length > 5) {
        resultBlock(NO, @"Task is too hard. Skipped.");
    }
    else {
        resultBlock(YES, @"Easy.");
    }
}

-(void)blockAsParameter {
    [self beginTaskWithCallBackBlock:^{
        NSLog(@"Work complete!!");
    }];
}

-(void)beginTaskWithCallBackBlock:(void(^)(void)) callBackBlock {
    NSLog(@"Working hard...");
    callBackBlock();
}

- (void)changeCaptureValuesInsideBlock {
    __block int blockValue = 100500;
    int value = 100500;
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"First String"];
    SimpleBlock block = ^{
        NSLog(@"Stack block body %d | %d | %@", value, blockValue, string);
        blockValue *= 2;
    };

    value = 100;


    SimpleBlock copyBlock = [block copy];

    NSLog(@"Type block: %@", [[block class] description]);
    NSLog(@"Type copy: %@", [[copyBlock class] description]);
    block();
    [string appendString:@" Second string"];
    copyBlock();
    NSLog(@"Local body %d | %d | %@", value, blockValue, string);
    [string release];
}

-(void)captureValues {
    int value = 100500;
    NSMutableString *string = [[NSMutableString alloc] initWithString:@"First String"];
    SimpleBlock block = ^{
        NSLog(@"Stack block body %d | %@", value, string);
    };

    value = 100;


    SimpleBlock copyBlock = [block copy];

    NSLog(@"Type block: %@", [[block class] description]);
    NSLog(@"Type copy: %@", [[copyBlock class] description]);
    block();
    [string appendString:@" Second string"];
    copyBlock();
    [string release];
}

-(void)mallocBlock {
    int value = 100500;
    SimpleBlock block = ^{
        NSLog(@"Stack block body %d", value);
    };

    SimpleBlock copyBlock = [block copy];

    NSLog(@"Type block: %@", [[block class] description]);
    NSLog(@"Type copy: %@", [[copyBlock class] description]);
    block();
    copyBlock();
}

-(void)stackBlock {
    int value = 100500;
    SimpleBlock block = ^{
        NSLog(@"Stack block body %d", value);
    };

    NSLog(@"Type block: %@", [[block class] description]);
    block();
}

-(void)globalBlock {
    SimpleBlock block = ^{
        NSLog(@"Global block body");
    };

    NSLog(@"Type: %@", [[block class] description]);
    block();
}

@end
