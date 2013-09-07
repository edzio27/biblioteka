//
//  PositionResultViewController.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 03.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "PositionResultViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "PositionDetail.h"
#import "ProductCell.h"
#import "MapViewViewController.h"
#import "Library.h"
#import "UIImage+MapShot.h"
#import "TMCache.h"

@interface PositionResultViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *positionList;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) NSMutableArray *libraryList;

@end

@implementation PositionResultViewController

- (NSMutableArray *)libraryList {
    if(_libraryList == nil) {
        _libraryList = [[NSMutableArray alloc] init];
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Library" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _libraryList = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        
        NSMutableArray *positionDetailArray = [[NSMutableArray alloc] init];
        NSMutableArray *libraryDetailArray = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < self.positionList.count; i++) {
            PositionDetail *position = [self.positionList objectAtIndex:i];
            NSString *libraryNumber = [[position.library componentsSeparatedByString:@" "] objectAtIndex:0];
            for(int j = 0; j < _libraryList.count; j++) {
                Library *library = [_libraryList objectAtIndex:j];
                if([libraryNumber isEqualToString:library.number]) {
                    [positionDetailArray addObject:position];
                    [libraryDetailArray addObject:library];
                    break;
                }
            }
        }
        _libraryList = libraryDetailArray;
    }
    return _libraryList;
}

- (UIBarButtonItem *)barButtonItem {
    if(_barButtonItem == nil) {
        UIButton *a1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [a1 setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 35.0f)];
        [a1 addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
        [a1 setImage:[UIImage imageNamed:@"mapIcon@2x.png"] forState:UIControlStateNormal];
        _barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:a1];
    }
    return _barButtonItem;
}

- (void)showMap {
    NSMutableArray *listLibrary = [[NSMutableArray alloc] init];
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Library" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    listLibrary = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    NSMutableArray *positionDetailArray = [[NSMutableArray alloc] init];
    NSMutableArray *libraryDetailArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < self.positionList.count; i++) {
        PositionDetail *position = [self.positionList objectAtIndex:i];
        
        NSString *libraryNumber = [[position.library componentsSeparatedByString:@" "] objectAtIndex:0];
        for(int j = 0; j < listLibrary.count; j++) {
            Library *library = [listLibrary objectAtIndex:j];
            if([libraryNumber isEqualToString:library.number]) {
                [positionDetailArray addObject:position];
                [libraryDetailArray addObject:library];
                break;
            }
        }
    }
    
    MapViewViewController *map = [[MapViewViewController alloc] init];
    map.positionDetailArray = positionDetailArray;
    map.libraryDetailArray = libraryDetailArray;
    [self.navigationController pushViewController:map animated:YES];
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (NSMutableArray *)positionList {
    if(_positionList == nil) {
        _positionList = [[NSMutableArray alloc] init];
        
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"PositionDetail" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        _positionList = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    }
    return _positionList;
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
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -
#pragma mark tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.positionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    ProductCell *cell =  (ProductCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if(cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    PositionDetail *position = [self.positionList objectAtIndex:indexPath.row];
    
    cell.rowNumber.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    cell.titleLabel.text = [position.library stringByReplacingOccurrencesOfString:@"(ALEPH)" withString:@""];
    if(position.termin == nil) {
        cell.authorLabel.text = [NSString stringWithFormat:@"Dostępne"];
    } else {
        cell.authorLabel.text = [NSString stringWithFormat:@"Dostępne od: %@", position.termin];
    }
    cell.dateLabel.text = position.amount;
    cell.mapImageView.image = nil;
    if([self.libraryList count] > indexPath.row) {
        Library *library = [self.libraryList objectAtIndex:indexPath.row];
        dispatch_queue_t queue = dispatch_queue_create("download.map.view.library", NULL);
        [[TMCache sharedCache] objectForKey:library.name
                                      block:^(TMCache *cache, NSString *key, id object) {
                                          __block UIImage *image = (UIImage *)object;
                                          if(image) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  cell.mapImageView.image = image;
                                              });
                                          } else {
                                              dispatch_async(queue, ^{
                                                  image = [UIImage getImageMapWithLatitude:[library.latitude floatValue] andLongitude:[library.longitude floatValue]];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      cell.mapImageView.image = image;
                                                      [[TMCache sharedCache] setObject:image forKey:library.name block:nil];
                                                      [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                  });
                                              });
                                          }
                                      }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

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
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
    self.title = @"Dostępność";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
