#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "TestObject.h"

@interface ViewControllerTests : XCTestCase
@property (nonatomic, strong) ViewController* vc;
@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
}

- (void)tearDown
{
    self.vc = nil;
    [super tearDown];
}

- (void)testDownloadJson
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"HTTP request"];

    [self.vc downloadJson:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/3031865/radioStations"] andCallback:^(NSArray* returnData) {
        XCTAssertNotNil(returnData, @"downloadJson failed to get data");
        XCTAssert([returnData isKindOfClass:[NSArray class]], @"Data parse to wrong type");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testConvertToObjects
{
    NSArray* object = @[
        @{ @"name" : @"106.1",
            @"url" : @"http://playlists.ihrhls.com/c4/2245/playlist.m3u8",
            @"id" : @1 },
        @{ @"name" : @"102.9",
            @"url" : @"http://playlists.ihrhls.com/c4/2237/playlist.m3u",
            @"id" : @2 },
        @{ @"name" : @"790 - houston",
            @"url" : @"http://playlists.ihrhls.com/c1/2257/playlist.m3u8",
            @"id" : @3 }
    ];
    [self.vc convertToObject:object];

    NSMutableArray* objects = self.vc.objects;

    XCTAssertNotNil(objects);

    for (id obj in objects) {
        XCTAssert([obj isKindOfClass:[TestObject class]], @"Data is not type of TestObject its type of %@", [obj class]);
    }

    XCTAssertEqual(objects.count, [object count], @"Wrong array size.");

    TestObject* obj = objects[0];
    XCTAssertNotNil(obj.name, @"name nil for object 0");
    XCTAssertNotNil(obj.url, @"url nil for object 0");
    XCTAssertGreaterThan(obj.station_id, 0, @"Wrong size for object");

    TestObject* obj1 = objects[1];
    XCTAssertNotNil(obj1.name, @"name nil for object 1");
    XCTAssertNotNil(obj1.url, @"url nil for object 1");
    XCTAssertGreaterThan(obj1.station_id, 0, @"Wrong size for object");

    TestObject* obj2 = objects[2];
    XCTAssertNotNil(obj2.name, @"name nil for object 2");
    XCTAssertNotNil(obj2.url, @"url nil for object 2");
    XCTAssertGreaterThan(obj2.station_id, 0, @"Wrong size for object");
}

- (void)testNameSortStations
{
    [self.vc convertToObject:@[
        @{ @"name" : @"1",
            @"url" : @"http://playlists.ihrhls.com/c1/2257/playlist.m3u8",
            @"id" : @4 },
        @{ @"name" : @"790 - houston",
            @"url" : @"http://playlists.ihrhls.com/c1/2257/playlist.m3u8",
            @"id" : @3 },
        @{ @"name" : @"102.9",
            @"url" : @"http://playlists.ihrhls.com/c4/2237/playlist.m3u",
            @"id" : @2 },
        @{ @"name" : @"106.1",
            @"url" : @"http://playlists.ihrhls.com/c4/2245/playlist.m3u8",
            @"id" : @1 }
    ]];
    [self.vc sortByName];
    NSMutableArray* objects = self.vc.objects;

    TestObject* one = objects[0];
    TestObject* two = objects[1];
    TestObject* three = objects[2];
    TestObject* four = objects[3];

    XCTAssertTrue(one.station_id == 4 && two.station_id == 2 && three.station_id == 1 && four.station_id == 3,
        @"sorting did not work");
}

- (void)testCordinatasToLocationsPass
{
    NSArray* coordinates = @[
        @[ @72.39300, @45.37283 ],
        @[ @-79.61214, @-22.40939 ],
        @[ @58.73939, @153.77644 ],
        @[ @-65.56787, @114.65210 ]
    ];

    NSArray* locations = [self.vc arrayOfCorrdinatesToCLLocaitons:coordinates];
    XCTAssertNotNil(locations, @"no location from arrayOfCorrdinatesToCLLocaitons");
    XCTAssertEqual(locations.count, [coordinates count], @"");

    for (id obj in locations) {
        XCTAssert([obj isKindOfClass:[CLLocation class]], @"Data is not type of cllocation its type of %@", [obj class]);
    }
}

@end
