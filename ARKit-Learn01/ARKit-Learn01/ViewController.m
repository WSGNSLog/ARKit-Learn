//
//  ViewController.m
//  ARKit-Learn01
//
//  Created by shiguang on 2018/2/27.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScnview];
}
- (void)setupScnview{
    
    SCNView *scnview = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnview.scene = [SCNScene scene];
    
    scnview.backgroundColor = [UIColor lightGrayColor];
    
    SCNNode *textNode = [SCNNode node];
    SCNText *text = [SCNText textWithString:@"hello world" extrusionDepth:0.5];
    textNode.geometry = text;
    [scnview.scene.rootNode addChildNode:textNode];
    scnview.allowsCameraControl = true;
    [self.view addSubview:scnview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
