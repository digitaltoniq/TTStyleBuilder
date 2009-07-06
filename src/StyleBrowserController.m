//
//  StyleBrowserController.m
//  TTStyleBuilder
//
//  Created by Keith Lazuka on 6/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StyleBrowserController.h"
#import "StyleStructureController.h"
#import "objc/runtime.h"

@interface StyleBrowserController ()
- (void)showStyle:(TTStyle *)style;
@end

@implementation StyleBrowserController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIViewController

- (void)loadView
{
    [super loadView];
    self.title = @"Archived Styles";
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewController

- (id<TTTableViewDataSource>)createDataSource
{
    NSMutableArray *items = [NSMutableArray array];
    
    // Search for all available .ttstyle file archives
    NSString *dir = StyleArchivesDir();
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
    
    for (NSString *file in dirEnum) {
        if ([[file pathExtension] isEqualToString: @"ttstyle"]) {

            [items addObject:[[[TTTableField alloc] initWithText:file] autorelease]];            
        }        
    }
    
    return [TTListDataSource dataSourceWithItems:items];
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    NSString *filename = [object text];
    NSString *fullPath = [StyleArchivesDir() stringByAppendingPathComponent:filename];
    TTStyle *style = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    
    if ( ![style isKindOfClass:[TTStyle class]] ){
        NSLog(@"Failed to load a TTStyle from %@", fullPath);
        [self alert:[NSString stringWithFormat:@"Failed to load %@. Perhaps it is not a valid archive?", filename]];
        return;
    }

    [self showStyle:style];
}

- (void)showStyle:(TTStyle *)style
{
    UIViewController *controller = [[StyleStructureController alloc] initWithHeadStyle:style];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


@end
