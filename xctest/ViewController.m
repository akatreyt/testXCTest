#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "TestObject.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setHidden:true];

    [self downloadJson:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/3031865/radioStations"] andCallback:^(NSArray* returnData) {
        [self convertToObject:returnData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)convertToObject:(NSArray*)objs
{
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects removeAllObjects];

    for (NSDictionary* dictOjb in objs) {
        TestObject* newOjb = [[TestObject alloc] init:dictOjb];
        [self.objects addObject:newOjb];
    }

    [self sortByName];

    dispatch_async(dispatch_get_main_queue(), ^{
       [self updateTableView];
    });
}

- (void)downloadJson:(NSURL*)url andCallback:(void (^)(NSArray*))callback
{
    // Create a download task.
    NSURLSessionDataTask* task = [[NSURLSession sharedSession]
          dataTaskWithURL:url
        completionHandler:^(NSData* data, NSURLResponse* response,
                              NSError* error) {
        if (!error) {
          NSError* JSONError = nil;

          NSArray* array =
              [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:&JSONError];
          if (JSONError) {
            NSLog(@"Serialization error: %@", JSONError.localizedDescription);
          } else {
            NSLog(@"Response: %@", array);
            callback(array);
          }
        } else {
          NSLog(@"Error: %@", error.localizedDescription);
        }
        }];
    // Start the task.
    [task resume];
}

- (void)updateTableView
{
    [self.tableView setHidden:false];
    [self.tableView reloadData];
}

- (void)sortByName
{
    [self.objects sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil]];
}

- (NSArray*)arrayOfCorrdinatesToCLLocaitons:(NSArray*)coordinates
{
    NSMutableArray* returnObjects = [[NSMutableArray alloc] init];
    for (NSArray* obj in coordinates) {
        if ([obj count] == 2) {
            CLLocationDegrees lat = [obj[0] doubleValue];
            CLLocationDegrees lng = [obj[1] doubleValue];

            CLLocation* location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            if (location) {
                [returnObjects addObject:location];
            }
        }
    }
    // comment in / out to make test fail
    // [returnObjects addObject:@{ @"this will fail" : @"hahaha" }];
    return returnObjects;
}

#pragma mark TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    TestObject* obj = [self.objects objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.name;
}

@end
