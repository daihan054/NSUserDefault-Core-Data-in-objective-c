//
//  CategoryViewController.m
//  Todoey
//
//  Created by REVE Systems on 11/9/23.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()
@property (strong, nonatomic) NSMutableArray<Category *> *categories;
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (nonatomic,strong) AppDelegate* delegate;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = (AppDelegate*) UIApplication.sharedApplication.delegate;
    self.context = self.delegate.persistentContainer.viewContext;
    self.categories = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Category"];
    [self loadCategoriesWith:request];
}

#pragma mark- Data Manipulation Methods
-(void) saveCategories {
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"Error saving context %@, %@", error, [error localizedDescription]);
    }
    [self.tableView reloadData];
}

-(void) loadCategoriesWith:(NSFetchRequest*) request {
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"Failed to retrieve data: %@", error);
    } else {
        self.categories = [NSMutableArray arrayWithArray:results];
    }
    [self.tableView reloadData];
}

#pragma mark- TableView DataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    cell.textLabel.text = self.categories[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"goToItems" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TodoListViewController* destinationVC = (TodoListViewController*) segue.destinationViewController;
    NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        destinationVC.selectedCategory = self.categories[indexPath.row];
    }
}

#pragma mark- IBActions
- (IBAction)addButtonPressed:(id)sender {
    __block UITextField* myTextField = [[UITextField alloc]init];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Category" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Category* newItem = [[Category alloc]initWithContext:self.context];
        newItem.name = myTextField.text;
        [self.categories addObject:newItem];
        [self saveCategories];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Add a new category";
        myTextField = textField;
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
