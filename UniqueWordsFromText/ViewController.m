//
//  ViewController.m
//  UniqueWordsFromText
//
//  Created by Fede Cugliandolo on 05/06/14.
//  Copyright (c) 2014 Fede. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *getWordsButton;
@property (strong, nonatomic) IBOutlet UIButton *removeDuplicatedWordsButton;

@end

@implementation ViewController

#define NEW_BOOK_NAME @"stoneSoup"
#define BOOK_TO_REMOVE_DUPLICATES @"NewWordsWithDuplicates"

- (void)getUniqueWordsFromText {
    // Read from origin with unique words
    NSString *path = [[NSBundle mainBundle] pathForResource:@"origin" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableSet *baseWordsSet = [NSMutableSet setWithArray:lines];
    
    // Read from new file
    NSString *pathToNewBook = [[NSBundle mainBundle] pathForResource:NEW_BOOK_NAME ofType:@"txt"];
    NSString *newBookString = [NSString stringWithContentsOfFile:pathToNewBook encoding:NSUTF8StringEncoding error:NULL];
    // Cleaning puntuaction
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"." withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"," withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@":" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@")" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"[" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"]" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"{" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"}" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"–" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"!" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@";" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"’" withString:@"'"];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"“" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"”" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"…" withString:@""];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"´" withString:@"'"];
    newBookString = [newBookString stringByReplacingOccurrencesOfString:@"\"" withString:@""]; // leave it last
    newBookString = [newBookString lowercaseString];
    // Getting the new words set
    NSArray *newWordsArray = [newBookString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray *wordsToEliminate = [[NSMutableArray alloc] initWithArray:newWordsArray];
    for (NSString *word in newWordsArray) {
        if ([word isEqualToString:@""]) [wordsToEliminate removeObject:word];
    }
    newWordsArray = wordsToEliminate;
    NSSet *newWordsReadySet = [NSSet setWithArray:newWordsArray];
    
    // compare base set with the new one and get a unique set
    NSMutableSet *uniqueWordsSet = [[NSMutableSet alloc] init];
    for (NSString *word in newWordsReadySet) {
        if (![baseWordsSet containsObject:word]) [uniqueWordsSet addObject:word];
    }
    NSLog(@"All: %@", newWordsArray);
    NSLog(@"Unique words: %@", uniqueWordsSet);
    
    // adding new words to base set
    NSLog(@"\nbase: %d\nunique: %d", baseWordsSet.count, uniqueWordsSet.count);
    [baseWordsSet addObjectsFromArray:[uniqueWordsSet allObjects]];
    NSLog(@"\nnueva base: %d", baseWordsSet.count);
    
    // Save new file with unique words
    NSString *strUniqueFromSet = @"";
    for (NSString *word in uniqueWordsSet) {
        strUniqueFromSet = [strUniqueFromSet stringByAppendingString:[NSString stringWithFormat:@"%@\n",word]];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *docFile = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"UniqueWords-%@.txt", NEW_BOOK_NAME ]];
    [[NSFileManager defaultManager] createFileAtPath:docFile contents:nil attributes:nil];
    [strUniqueFromSet writeToFile:docFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Guardado en: %@", docFile);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.getWordsButton setTitle:[NSString stringWithFormat:@"Get words from Book: %@", NEW_BOOK_NAME] forState:UIControlStateNormal];
}

- (IBAction)getWordsFromBook:(id)sender {
    [self getUniqueWordsFromText];
}

- (IBAction)removeDuplicatedWordsTapped:(id)sender {
    NSString *pathToNewBook = [[NSBundle mainBundle] pathForResource:BOOK_TO_REMOVE_DUPLICATES ofType:@"txt"];
    NSString *newBookString = [NSString stringWithContentsOfFile:pathToNewBook encoding:NSUTF8StringEncoding error:NULL];

    NSSet *newWordsReadySet = [NSSet setWithArray:[newBookString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *docFile = [docDir stringByAppendingPathComponent:@"UniqueWordsWithNoDuplicates.txt"];
    [[NSFileManager defaultManager] createFileAtPath:docFile contents:nil attributes:nil];

    // Save new file with unique words
    NSString *strUniqueFromSet = @"";
    for (NSString *word in newWordsReadySet) {
        strUniqueFromSet = [strUniqueFromSet stringByAppendingString:[NSString stringWithFormat:@"%@\n",word]];
    }
    [strUniqueFromSet writeToFile:docFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Guardado en: %@", docFile);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Worning macho!");
}

@end
