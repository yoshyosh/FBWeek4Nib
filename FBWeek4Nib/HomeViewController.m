//
//  HomeViewController.m
//  FBWeek4Nib
//
//  Created by Joseph Anderson on 4/17/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
int startDragHeight;
int initialPosition;

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
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideDownHeadline:)];
    [self.headlineView addGestureRecognizer:pan];
    
    startDragHeight = 0; //initialize drag height
    initialPosition = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)slideDownHeadline:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.view];
    CGRect frame = self.headlineView.frame;
    frame.origin.x = 0;
    
    if (tapGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startDragHeight = tapPoint.y;
    } else if (tapGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        int currentDragHeight = tapPoint.y;
        float newHeight = initialPosition + (currentDragHeight - startDragHeight);
        NSLog(@"%f", newHeight);
        frame.origin.y = newHeight;
        self.headlineView.frame = frame;
    } else if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        initialPosition = frame.origin.y;
    }
}

@end
