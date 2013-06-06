//
//  ParseViewController.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 27.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ParseViewController.h"
#import "AFNetworking.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "HTMLParser.h"
#import "PositionDetail.h"

#define URL @"http://80.53.118.28"

@interface ParseViewController ()

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ParseViewController

- (void)hideIndicator {
    NSLog(@"hide");
}

- (NSOperationQueue *)queue {
    if(_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = appDelegate.managedObjectContext;
    }
    return _managedObjectContext;
}

- (void)findSearchPathWithCookie:(void(^)(NSString *result))handler {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/F", URL]]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* responseString = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSLog(@"res %@", responseString);
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        NSString *string = nil;
        HTMLNode *bodyNode = [parser body];
        NSArray *selectNode = [bodyNode findChildTags:@"tr"];
        for(int j = 0; j < selectNode.count; j++) {
            if([[[selectNode objectAtIndex:j] getAttributeNamed:@"class"] isEqualToString:@"middlebar"]) {
                NSArray *inputNodes = [[selectNode objectAtIndex:j]  findChildTags:@"a"];
                if(inputNodes.count > 1) {
                    NSLog(@"%@", [[inputNodes objectAtIndex:1] getAttributeNamed:@"href"]);
                    string = [[inputNodes objectAtIndex:1] getAttributeNamed:@"href"];
                    NSArray *array = [string componentsSeparatedByString:@"?"];
                    string = [array objectAtIndex:0];
                }
            }
        }
        NSLog(@"strin %@", string);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.cookieString = string;
        handler(string);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}


- (void)downloadLibrariesWithTitle:(NSString *)title andHandler:(void(^)(NSMutableDictionary *result))handler {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://80.53.118.28/F/TTU9I31KUQGRP6DUALHQG3GF2V16375YUSII1BCF7XCNNSGFLN-24432?func=find-b&request=%@&find_code=WAU&adjacent=N&local_base=MBP&x=0&y=0&filter_code_1=WLN&filter_request_1=&filter_code_2=WYR&filter_request_2=&filter_code_3=WYR&filter_request_3=&filter_code_4=WFT&filter_request_4=", title]]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* responseString = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSLog(@"res %@", responseString);
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        NSMutableDictionary *diciotnary = [[NSMutableDictionary alloc] init];
        HTMLNode *bodyNode = [parser body];
        NSArray *selectNode = [bodyNode findChildTags:@"select"];
        for(int j = 0; j < selectNode.count; j++) {
            if([[[selectNode objectAtIndex:j] getAttributeNamed:@"name"] isEqualToString:@"local_base"]) {
                NSArray *inputNodes = [[selectNode objectAtIndex:j]  findChildTags:@"option"];
                for (HTMLNode *spanNode in inputNodes) {
                    [diciotnary setObject:spanNode.contents forKey:[spanNode getAttributeNamed:@"value"]];
                }
            }
        }
        handler(diciotnary);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)downloadResultWithTitle:(NSString *)title library:(NSString *)library cookie:(NSString *)cookie andHandler:(void(^)(NSMutableDictionary *result))handler {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://80.53.118.28%@?func=find-b&request=%@&find_code=WRD&adjacent=N&local_base=%@&x=0&y=0&filter_code_1=WLN&filter_request_1=&filter_code_2=WYR&filter_request_2=&filter_code_3=WYR&filter_request_3=&filter_code_4=WFT&filter_request_4=", cookie, title, library]]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* responseString = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.lastDataDownloaded = responseString;
        NSLog(@"res %@", responseString);
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        NSMutableDictionary *diciotnary = [[NSMutableDictionary alloc] init];
        HTMLNode *bodyNode = [parser body];
        NSArray *selectNode = [bodyNode findChildTags:@"tr"];
        [self removeDataFromDatabase];
        for(int j = 0; j < selectNode.count; j++) {
            if([[[selectNode objectAtIndex:j] getAttributeNamed:@"valign"] isEqualToString:@"baseline"]) {
                NSArray *inputNodes = [[selectNode objectAtIndex:j]  findChildTags:@"td"];
                NSArray *ahrefNodes = [[selectNode objectAtIndex:j]  findChildTags:@"a"];
                NSLog(@"%@", [((HTMLNode *)[ahrefNodes objectAtIndex:1]) getAttributeNamed:@"href"]);
                
                NSManagedObject *position = [NSEntityDescription
                                                      insertNewObjectForEntityForName:@"Position"
                                                      inManagedObjectContext:self.managedObjectContext];
                NSString *url = [NSString stringWithFormat:@"%@%@", URL, [((HTMLNode *)[ahrefNodes objectAtIndex:1]) getAttributeNamed:@"href"]];
                [position setValue:url forKey:@"mainURL"];
                [position setValue:((HTMLNode *)[inputNodes objectAtIndex:2]).contents forKey:@"author"];
                [position setValue:((HTMLNode *)[inputNodes objectAtIndex:3]).contents forKey:@"title"];
                [position setValue:((HTMLNode *)[inputNodes objectAtIndex:4]).contents forKey:@"year"];

                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            }
        }
        handler(diciotnary);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)downloadDetailPositionWithURL:(NSString *)url andHandler:(void(^)(NSMutableDictionary *result))handler {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* responseString = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        NSMutableDictionary *diciotnary = [[NSMutableDictionary alloc] init];
        HTMLNode *bodyNode = [parser body];
        NSArray *selectNode = [bodyNode findChildTags:@"tr"];
        [self clearEntity:@"PositionDetail"];
        for(int j = 12; j < selectNode.count - 1; j++) {
            NSArray *inputNodes = [[selectNode objectAtIndex:j]  findChildTags:@"td"];
            /* core data store */
            NSManagedObject *position = [NSEntityDescription
                                         insertNewObjectForEntityForName:@"PositionDetail"
                                         inManagedObjectContext:self.managedObjectContext];
            [position setValue:((HTMLNode *)[inputNodes objectAtIndex:2]).contents forKey:@"status"];
            [position setValue:((HTMLNode *)[inputNodes objectAtIndex:3]).contents forKey:@"termin"];
            [position setValue:((HTMLNode *)[inputNodes objectAtIndex:4]).contents forKey:@"library"];
            [position setValue:((HTMLNode *)[inputNodes objectAtIndex:5]).contents forKey:@"amount"];
            
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
        }
        handler(diciotnary);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)downloadMoreResultsPart:(NSString *) partNumber title:(NSString *)title andHandler:(void (^)(NSMutableDictionary *))handler {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:
                                                                      [NSString stringWithFormat:
                                                                       @"http://80.53.118.28%@?func=short-jump&request=%@&find_code=WRD&adjacent=N&local_base=MBP&x=0&y=0&filter_code_1=WLN&filter_request_1=&filter_code_2=WYR&filter_request_2=&filter_code_3=WYR&filter_request_3=&jump=%@&filter_code_4=WFT&filter_request_4=", appDelegate.cookieString, title, partNumber]]];
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@?func=short-jump&jump=0000%@", URL, appDelegate.cookieString, partNumber]);
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:nil
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* responseString = [[NSString alloc] initWithData:responseObject
                                                         encoding:NSUTF8StringEncoding];
        NSLog(@"res %@", responseString);
        NSError *error = nil;
        HTMLParser *parser = [[HTMLParser alloc] initWithString:responseString error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        NSMutableDictionary *diciotnary = [[NSMutableDictionary alloc] init];
        
        if(![responseString isEqualToString:appDelegate.lastDataDownloaded]) {
            appDelegate.lastDataDownloaded = responseString;
            HTMLNode *bodyNode = [parser body];
            NSArray *selectNode = [bodyNode findChildTags:@"tr"];
            //[self removeDataFromDatabase];
            for(int j = 0; j < selectNode.count; j++) {
                if([[[selectNode objectAtIndex:j] getAttributeNamed:@"valign"] isEqualToString:@"baseline"]) {
                    NSLog(@"%@", [[selectNode objectAtIndex:j] getAttributeNamed:@"valign"]);
                    NSArray *inputNodes = [[selectNode objectAtIndex:j]  findChildTags:@"td"];
                    NSArray *ahrefNodes = [[selectNode objectAtIndex:j]  findChildTags:@"a"];
                    NSLog(@"%@", [((HTMLNode *)[ahrefNodes objectAtIndex:1]) getAttributeNamed:@"href"]);
                    
                    NSManagedObject *position = [NSEntityDescription
                                                 insertNewObjectForEntityForName:@"Position"
                                                 inManagedObjectContext:self.managedObjectContext];
                    NSString *url = [NSString stringWithFormat:@"%@%@", URL, [((HTMLNode *)[ahrefNodes objectAtIndex:1]) getAttributeNamed:@"href"]];
                    [position setValue:url forKey:@"mainURL"];
                    [position setValue:((HTMLNode *)[inputNodes objectAtIndex:2]).contents forKey:@"author"];
                    [position setValue:((HTMLNode *)[inputNodes objectAtIndex:3]).contents forKey:@"title"];
                    [position setValue:((HTMLNode *)[inputNodes objectAtIndex:4]).contents forKey:@"year"];
                    
                    if (![self.managedObjectContext save:&error]) {
                        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    }
                }
            }
        }
        handler(diciotnary);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)cancelAllOperations {
    [self.queue cancelAllOperations];
    [self.delegate hideIndicator];
}

- (void)clearEntity:(NSString *)entity {
    NSFetchRequest *fetchLLObjects = [[NSFetchRequest alloc] init];
    [fetchLLObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext]];

    NSError *error = nil;
    NSArray *allObjects = [self.managedObjectContext executeFetchRequest:fetchLLObjects error:&error];
    for (NSManagedObject *object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }

    NSError *saveError = nil;
    if (![self.managedObjectContext save:&saveError]) {
        NSLog(@"removed");
    }
}

- (void)removeDataFromDatabase {
    [self clearEntity:@"Position"];
    [self clearEntity:@"PositionDetail"];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
