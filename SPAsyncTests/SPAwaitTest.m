//
//  SPAwaitTest.m
//  SPAsync
//
//  Created by Joachim Bengtsson on 2013-01-30.
//  
//

#import "SPAwaitTest.h"
#import "SPTaskTest.h"
#import <SPAsync/SPAwait.h>
#import <SPAsync/SPTask.h>

@implementation SPAwaitTest

- (SPTask *)awaitableNumber
{
    SPTaskCompletionSource *source = [SPTaskCompletionSource new];
    int64_t delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [source completeWithValue:@42];
    });
    return source.task;
}

- (SPTask *)slowlyMultiply
{
    __block NSNumber *number;
    SPAsyncMethodBegin();
    
    SPAsyncAwait(number, [self awaitableNumber]);
    
    NSNumber *twice = @([number intValue]*2);
    
    SPAsyncMethodReturn(twice);    
    SPAsyncMethodEnd();
}


- (void)testSimple
{
    SPTask *task = [self slowlyMultiply];
    
    SPAssertTaskCompletesWithValueAndTimeout(task, @(84), 0.1);
}


@end
