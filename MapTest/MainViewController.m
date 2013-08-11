//
//  MainViewController.m
//  MapTest
//
//  Created by Axel Rivera on 8/10/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "MainViewController.h"

#import "MapViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init
{
    self = [super initWithNibName:@"MainViewController" bundle:nil];
    if (self) {
        self.title = @"Main View";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect textRect = CGRectMake(0.0, 0.0, self.view.frame.size.width - 40.0, 30.0);

    self.textField = [[UITextField alloc] initWithFrame:textRect];
    self.textField.placeholder = @"Enter an address";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryView = self.textField;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0) {
        title = @"Location Address";
    }
    
    return title;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    if (section == 0) {
        CGRect viewRect = CGRectMake(0.0,
                                     0.0,
                                     tableView.frame.size.width,
                                     64.0);

        view = [[UIView alloc] initWithFrame:viewRect];
        view.backgroundColor = [UIColor clearColor];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Find Address" forState:UIControlStateNormal];
        button.frame = CGRectMake(10.0,
                                  10.0,
                                  view.frame.size.width - 20.0,
                                  44.0);

        SEL buttonSelector = @selector(findAddressAction:);
        [button addTarget:self action:buttonSelector forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:button];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.0;
    if (section == 0) {
        height = 64.0;
    }
    return height;
}

- (void)findAddressAction:(id)sender
{
    NSString *string = self.textField.text;
    if (string == nil || [string isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Empty address"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    [self.view endEditing:YES];

    MapViewController *mapController = [[MapViewController alloc] initWithAddressString:string];

//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapController];
//    [self.navigationController presentViewController:navController animated:YES completion:nil];

    [self.navigationController pushViewController:mapController animated:YES];
}

@end
