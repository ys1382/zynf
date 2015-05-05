#import <Foundation/Foundation.h>

#import "Verb.h"
#import "Setting.h"
#import "Item.h"

@implementation Verb

static NSMutableArray *allVerbs = nil;

+ (NSMutableArray *) all {
    if (allVerbs == nil) {
        allVerbs = [NSMutableArray array];
    }
    return allVerbs;
}

+ (Verb *)verbWithName:(NSString *)_name does:(Attempt)_doing {
    Verb *verb = [Verb alloc];
    verb.name = _name;
    verb.doing = _doing;
    [[Verb all] addObject:verb];
    return verb;
}

- (NSMutableArray *)actIn:(Setting *)setting on:(Item *)item {
//    NSNumber *value = [[setting values] objectAtIndex:0];
//    value = @([value intValue] + 1);
//    [setting.values replaceObjectAtIndex:0 withObject:value];
//    return setting.values;
    NSAssert(false, @"%@.actIn not implemented", self.name);
    return nil;
}

- (NSString *)attempt:(Action *)action in:(Setting *)setting {
    return self.doing(setting, action);
}


@end
