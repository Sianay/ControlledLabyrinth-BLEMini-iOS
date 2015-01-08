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
        cell.dateLabel.text = [NSString stringWithFormat:@"%@ le %@",[dict objectForKey:@"pseudo"],[dict objectForKey:@"date"]];
        cell.trouLabel.text = [NSString stringWithFormat:@"Trou #%@",[dict objectForKey:@"hole"] ];
    };
    
    NSDictionary *data = [[HistoriqueDataHandler sharedInstance] readData];
    NSArray *array = [data objectForKey:@"tab"];


    self.historiqueArrayDataSource = [[ArrayDataSource alloc] initWithItems:array                                                           cellIdentifier:CellIdentifier
        configureCellBlock:configureCell];
    
    self.historiqueTableView.dataSource = self.historiqueArrayDataSource;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
