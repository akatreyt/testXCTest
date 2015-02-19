#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (retain, nonatomic) NSMutableArray* objects;

- (void)downloadJson:(NSURL*)url andCallback:(void (^)(NSArray*))callback;
- (void)convertToObject:(NSArray*)objs;
- (void)updateTableView;
- (void)sortByName;
- (NSArray*)arrayOfCorrdinatesToCLLocaitons:(NSArray*)coordinates;
@end
