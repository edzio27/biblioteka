//
//  LibrariesViewController.m
//  Biblioteka
//
//  Created by Edzio27 Edzio27 on 02.06.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "LibrariesViewController.h"
#import "ViewController.h"

@interface LibrariesViewController ()

@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UITableView *tableView;

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
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.delegate libraryWasChecked:[self.titleArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
