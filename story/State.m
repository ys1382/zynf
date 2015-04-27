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


+ (State*)stateWithName:(NSString*)_name values:(NSArray*)_values {
    State *state = [State alloc];
    state.name = _name;
    state.values = _values;

    [[State all] addObject:state];
    return state;
}


@end
