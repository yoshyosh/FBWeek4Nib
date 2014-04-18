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
float startDragHeight;
float initialPosition;
float newHeadlineHeight;
float scrollInitialXPosition;
float scrollInitialYPosition;
float scrollStartXPosition;
float scrollNewPosition;

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
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideHeadline:)];
    [self.headlineView addGestureRecognizer:pan];
    
    UIPanGestureRecognizer *panNews = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideNews:)];
    //[self.scrollNews addGestureRecognizer:panNews];
    
    self.scrollView.contentSize = self.scrollNews.frame.size;
    
    startDragHeight = 0; //initialize drag height
    initialPosition = 0;
    newHeadlineHeight = 0;
    scrollInitialYPosition = self.scrollNews.frame.origin.y;
    scrollInitialXPosition = 0;
    scrollStartXPosition = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)slideHeadline:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint tapPoint = [panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    CGRect frame = self.headlineView.frame;
    frame.origin.x = 0;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        startDragHeight = tapPoint.y;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        int currentDragHeight = tapPoint.y;
        newHeadlineHeight = initialPosition + (currentDragHeight - startDragHeight);
        if (newHeadlineHeight < 0){
            newHeadlineHeight = newHeadlineHeight/10;
        }
        frame.origin.y = newHeadlineHeight;
        self.headlineView.frame = frame;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        initialPosition = newHeadlineHeight;
        //Need to know if user is swiping up or down, based on that we can
        if (newHeadlineHeight < 150.0 || velocity.y < 0) {
            [self performSelector:@selector(elasticSlideUp:) withObject:self afterDelay:0];
        } else {
            [self performSelector:@selector(elasticSlideDown:) withObject:self afterDelay:0]; //What is self in this case?
        }
    }
}

- (void)elasticSlideUp:(id)sender { //Want to play with these passed variables, think this can be UIView instead
    [UIView animateWithDuration:.35 animations:^{
        CGRect frame = self.headlineView.frame;
        frame.origin.y = 0;
        self.headlineView.frame = frame;
    } completion:^(BOOL finished) {
        initialPosition = 0;
    }];
}

- (void)elasticSlideDown:(id)sender {
    [UIView animateWithDuration:.5 animations:^{
        CGRect frame = self.headlineView.frame;
        frame.origin.y = 520;
        self.headlineView.frame = frame;
    } completion:^(BOOL finished) {
        initialPosition = 520;
    }];
}

- (void)slideNews:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.view];

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        scrollStartXPosition = point.x;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        scrollNewPosition = scrollInitialXPosition + (point.x - scrollStartXPosition);
        if (scrollNewPosition > 0) {
            scrollNewPosition = scrollNewPosition/3;
        }
        CGRect frame = self.scrollNews.frame;
        frame.origin.x = scrollNewPosition;
        self.scrollNews.frame = frame;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        scrollInitialXPosition = scrollNewPosition;
    }
}

@end
