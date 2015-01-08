//
//  HistoriqueViewController.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 08/01/2015.
//  Copyright (c) 2015 ARLEM. All rights reserved.
//

#import "HistoriqueViewController.h"
#import "ArrayDataSource.h"
#import "HistoriqueTableViewCell.h"
#import "HistoriqueDataHandler.h"

static NSString *const CellIdentifier = @"Cell";

@interface HistoriqueViewController ()
@property (strong, nonatomic) ArrayDataSource *historiqueArrayDataSource;

@end

@implementation HistoriqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    void (^configureCell)(HistoriqueTableViewCell*, NSDictionary*) = ^(HistoriqueTableViewCell* cell, NSDictionary *dict) {
        
        cell.dateLabel.text = [NSString stringWithFormat:@"%@ le %@",[dict objectForKey:@"pseudo"],[self formatDate:[dict objectForKey:@"date"]]];
        cell.trouLabel.text = [NSString stringWithFormat:@"Score : %@",[dict objectForKey:@"hole"] ];
    };
    
    NSDictionary *data = [[HistoriqueDataHandler sharedInstance] readData];
    NSArray *array = [data objectForKey:@"tab"];

    NSArray *aSortedArray = [array sortedArrayUsingComparator:^(NSMutableDictionary *obj1,NSMutableDictionary *obj2) {
        NSString *num1 =[obj1 objectForKey:@"hole"];
        NSString *num2 =[obj2 objectForKey:@"hole"];
        return (NSComparisonResult) [num2 compare:num1 options:(NSNumericSearch)];
    }];
    

    self.historiqueArrayDataSource = [[ArrayDataSource alloc] initWithItems:aSortedArray                                                           cellIdentifier:CellIdentifier
        configureCellBlock:configureCell];
    
    self.historiqueTableView.dataSource = self.historiqueArrayDataSource;
    
    
}

- (NSString*) formatDate:(NSDate*) date
{
    NSDateFormatter * dateFormatterDate = [NSDateFormatter new];
    [dateFormatterDate setDateFormat:@"dd/MM/YYYY à HH:mm"] ;
    
    return [[dateFormatterDate stringFromDate:date] stringByReplacingOccurrencesOfString:@":" withString:@"h"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
