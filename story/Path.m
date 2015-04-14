#import "Path.h"
#import "Setting.h"
#import "Step.h"

@implementation Path

static NSMutableSet *theVisited = nil;
static NSMutableArray *allPaths = nil;

+ (NSMutableArray *) all {
    if (allPaths == nil) {
        allPaths = [NSMutableArray array];
    }
    return allPaths;
}

+ (NSNumber *)score:(NSArray *)path {
    Step *first = [path objectAtIndex:0];
    Step *last = [path objectAtIndex:[path count] -1];
    long delta = [last.to.index integerValue] - [first.to.index integerValue];
    return [NSNumber numberWithInteger:delta];
}

+ (NSArray *)best {
    
    NSArray *sortedArray;
    NSArray *paths = [Path all];
    
    sortedArray = [paths sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [Path score:(NSArray *)a];
        NSNumber *second = [Path score:(NSArray *)b];
        NSComparisonResult result = [first compare:second];
        return result;
    }];

    NSArray *winner = [sortedArray objectAtIndex:0];
    
    return winner;
}

+ (void)generateAll {

    theVisited = nil;
    
    NSArray *sa = [Setting all];

    for (Setting *setting in sa) {
        NSMutableArray *subPaths = [Path generateStartingAt:setting];
        [[Path all] addObjectsFromArray:subPaths];
    }
}

+ (BOOL)visit:(NSNumber *)destinationIndex {

    if (theVisited == nil) {
        theVisited = [NSMutableSet set];
    }
    NSString *stringdex = [NSString stringWithFormat:@"%@", destinationIndex];
    if ([theVisited containsObject:stringdex]) {
        return NO;
    }
    [theVisited addObject:stringdex];
    return YES;
}

+ (NSMutableArray *)generateStartingAt:(Setting *)setting {

    NSMutableArray *result = [NSMutableArray array];
    NSArray *linkKeys = [setting.links allKeys];

    for (NSNumber *actionIndex in linkKeys) {

        NSNumber *destinationIndex = [setting.links objectForKey:actionIndex];
        if ([Path visit:destinationIndex]) {

            Setting *consequence = [[Setting all] objectAtIndex:[destinationIndex integerValue]];
            Action *action = [[Action all] objectAtIndex:[actionIndex integerValue]];
            Step *step = [Step stepFrom:setting to:consequence by:action];
            [result addObject:[NSMutableArray arrayWithObject:step]];
            NSMutableArray *subPaths = [Path generateStartingAt:consequence];
            for (NSMutableArray *path in subPaths) {
                [path insertObject:step atIndex:0];
                [result addObject:path];
            }
        }
    }

    return result;
}

+ (NSString *)tell {
    
    NSString *result = @"Once upon a time, there was ";
    for (Item *item in [Item all]) {
        result = [result stringByAppendingFormat:@"%@, ", item.name];
    }
    result = [result stringByAppendingString:@"\n"];

    NSArray *story = [Path best];
    for (Step *step in story) {
        result = [result stringByAppendingFormat:@"%@\n", [step.by description]];
    }

    result = [result stringByAppendingString:@"...and they lived happily ever after. The end.\n"];
    
    return result;
}

@end
