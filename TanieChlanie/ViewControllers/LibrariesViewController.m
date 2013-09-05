//
//  LibrariesViewController.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 02.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "LibrariesViewController.h"
#import "ViewController.h"
#import "ProductCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Library.h"
#import "UIImage+MapShot.h"
#import "TMCache.h"

@interface LibrariesViewController ()

@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *libraryList;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation LibrariesViewController

#pragma mark -
#pragma mark implementation

- (NSMutableDictionary *)libraryDictionary {
    if(_libraryDictionary == nil) {
        _libraryDictionary = [[NSMutableDictionary alloc] init];
    }
    return _libraryDictionary;
}

- (NSMutableArray *)tagArray {
    if(_tagArray == nil) {
        _tagArray = [[NSMutableArray alloc] init];
    }
    return _tagArray;
}

- (NSMutableArray *)titleArray {
    if(_titleArray == nil) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)libraryList {
    if(_libraryList == nil) {
        _libraryList = [[NSMutableArray alloc] init];
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Library" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _libraryList = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    return _libraryList;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (UITableView *)tableView {
    if(_tableView == nil) {
        CGRect rectTableView = CGRectMake(0,
                                          0,
                                          [[UIScreen mainScreen] bounds].size.width,
                                          [[UIScreen mainScreen] bounds].size.height
                                          - self.navigationController.navigationBar.frame.size.height
                                          - [UIApplication sharedApplication].statusBarFrame.size.height - 30);
        _tableView = [[UITableView alloc] initWithFrame:rectTableView style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -
#pragma mark tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *arrayKeys = [self.libraryDictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in arrayKeys) {
        [self.tagArray addObject:key];
        [self.titleArray addObject:[self.libraryDictionary objectForKey:key]];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.libraryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    ProductCell *cell =  (ProductCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if(cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.rowNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    cell.titleLabel.frame = CGRectMake(30, 0, 200, 63);
    cell.titleLabel.text = [[self.titleArray objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"(ALEPH)" withString:@""];
    cell.circleView.backgroundColor = RED_COLOR;
    
    Library *library = [self.libraryList objectAtIndex:indexPath.row];
    dispatch_queue_t queue = dispatch_queue_create("download.map.view.library", NULL);
    
    [[TMCache sharedCache] objectForKey:library.name
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      UIImage *image = (UIImage *)object;
                                      if(image) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              cell.mapImageView.image = image;
                                          });
                                      } else {
                                          dispatch_async(queue, ^{
                                              UIImage *image = [UIImage getImageMapWithLatitude:[library.latitude floatValue] andLongitude:[library.longitude floatValue]];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  cell.mapImageView.image = image;
                                                  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                  [[TMCache sharedCache] setObject:image forKey:library.name block:nil];
                                              });
                                          });
                                      }
                                  }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.delegate libraryWasChecked:[self.titleArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

#pragma mark -
#pragma mark view implementation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.title = @"Wybierz filie";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
