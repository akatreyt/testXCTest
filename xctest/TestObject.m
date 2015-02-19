#import "TestObject.h"

@implementation TestObject

- (id)init:(NSDictionary*)data
{
    if (self = [super init]) {

        self.station_id = -1;

        if ([[data allKeys] containsObject:@"name"]) {
            NSString* name = [data valueForKey:@"name"];
            self.name = name;
        }

        if ([[data allKeys] containsObject:@"id"]) {
            float station_id = [[data valueForKey:@"id"] floatValue];
            self.station_id = station_id;
        }

        if ([[data allKeys] containsObject:@"url"]) {
            NSString* url = [data valueForKey:@"url"];
            self.url = [NSURL URLWithString:url];
        }
    }
    return self;
}

@end
