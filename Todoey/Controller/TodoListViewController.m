//
//  ViewController.m
//  Todoey
//
//  Created by REVE Systems on 7/9/23.
//

#import "TodoListViewController.h"

@interface TodoListViewController ()
@property (strong, nonatomic) NSMutableArray<Item *> *itemArray;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) AppDelegate* delegate;
@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = (AppDelegate*) UIApplication.sharedApplication.delegate;
    self.context = self.delegate.persistentContainer.viewContext;
    self.itemArray = [[NSMutableArray alloc] init]; // Initialize itemArray
    [self loadItems];
}

#pragma mark - Tableview Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoItemCell" forIndexPath:indexPath];

    cell.textLabel.text = self.itemArray[indexPath.row].title;
    cell.accessoryType = self.itemArray[indexPath.row].done ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.itemArray[indexPath.row];
    item.done = !item.done;
    
    [self saveItems];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Add New Items

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    
    __block UITextField* myTextField = [[UITextField alloc]init];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Todoey Item" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add Item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Item* newItem = [[Item alloc]initWithContext:self.context];
        newItem.title = myTextField.text;
        newItem.done = NO;
        [self.itemArray addObject:newItem];
        
        [self saveItems];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Create new item";
        myTextField = textField;
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Core data methods

- (void)loadItems {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Failed to retrieve data: %@", error);
    } else {
        self.itemArray = [NSMutableArray arrayWithArray:results];
    }
    [self.tableView reloadData];
}

- (void)saveItems {
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Error saving context %@, %@", error, [error localizedDescription]);
    }
    [self.tableView reloadData];
}

- (void)deleteItemAt:(NSIndexPath * _Nonnull)indexPath {
    Item *item = self.itemArray[indexPath.row];
    //    item.done = !item.done;
    [self.context deleteObject:item];
    [self.itemArray removeObjectAtIndex:indexPath.row];
}

@end

/*
 CRUD:
 C: create -> line 61 to 66
 R: read -> loadItems method
 U: update -> didSelectRowAtIndexPath method, changing done property
 D: delete -> deleteItemAt method, it can be called from didSelectRowAtIndexPath method
 */
