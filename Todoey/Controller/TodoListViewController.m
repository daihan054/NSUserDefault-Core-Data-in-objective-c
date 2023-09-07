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

@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self retrieveArrayFromUserDefault];
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
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Add New Items

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    
    __block UITextField* myTextField = [[UITextField alloc]init];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Todoey Item" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add Item" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@, \n myTextField.text = %@",self.itemArray,myTextField.text);
        
        Item* item = [[Item alloc]initWithTitle:myTextField.text done:NO];
        [self.itemArray addObject:item];
        
        [self saveArrayToUserDefault];

        [self.tableView reloadData];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Create new item";
        myTextField = textField;
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UserDefault methods
- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = NSUserDefaults.standardUserDefaults;
    }
    return _userDefaults;
}

- (void)retrieveArrayFromUserDefault {
    NSData * encodedData = [self.userDefaults objectForKey:@"ToDoListArray"];
    self.itemArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSMutableArray class], [Item class], nil] fromData:encodedData error:nil];
}

- (void)saveArrayToUserDefault {
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self.itemArray requiringSecureCoding:YES error:nil];
    [self.userDefaults setObject:encodedData forKey:@"ToDoListArray"];
    [self.userDefaults synchronize];
}

@end
