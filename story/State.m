#import "State.h"


@implementation State


static NSMutableArray *allStates = nil;


+ (NSMutableArray *)all
{
    if (allStates == nil)
    {
        allStates = [NSMutableArray array];
    }
    return allStates;
}


+ (State*)StateWithName:(NSString*)name values:(NSArray*)values {
    State *state = [State alloc];
    state.name = name;
    state.values = values;

    [[State all] addObject:state];
    return state;
}


@end
