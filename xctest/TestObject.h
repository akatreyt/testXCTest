#import <Foundation/Foundation.h>

@interface TestObject : NSObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) int station_id;
@property (nonatomic, retain) NSURL* url;

- (id)init:(NSDictionary*)data;
@end
