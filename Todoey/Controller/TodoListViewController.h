//
//  ViewController.h
//  Todoey
//
//  Created by REVE Systems on 7/9/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Item+CoreDataClass.h"
#import "Category+CoreDataClass.h"

@interface TodoListViewController : UITableViewController <UISearchBarDelegate>

@property(nonatomic,strong) Category* selectedCategory;
@end

