#import "Step.h"

@implementation Step

+ (Step*) stepFrom:(Setting*)from to:(Setting*)to by:(Action*)by
{
    Step *step = [Step alloc];
    
    step.from = from;
    step.to = to;
    step.by = by;

    return step;
}

@end
