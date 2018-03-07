//
//  ViewController.m
//  ARKit-Learn18
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController ()

@property (nonatomic,strong) SCNScene *lastScene;
@property (nonatomic,strong) SCNNode *floorNode;
@property (nonatomic,strong) SCNView *scnView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSCNView];
}

- (void)addSCNView{
    //创建游戏视图和游戏场景
    self.scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    self.scnView.backgroundColor = [UIColor blackColor];
    self.scnView.scene = [SCNScene scene];
    [self.view addSubview:self.scnView];
    self.scnView.allowsCameraControl = true;
    
    //创建照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 30, 30);
    cameraNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_4);
    cameraNode.camera.automaticallyAdjustsZRange = true;
    [self.scnView.scene.rootNode addChildNode:cameraNode];
    
    //创建一个地板
    SCNNode *floorNode = [SCNNode node];
    self.floorNode = floorNode;
    floorNode.geometry = [SCNFloor floor];
    floorNode.geometry.firstMaterial.diffuse.contents = @"floor.jpg";
    floorNode.physicsBody = [SCNPhysicsBody staticBody];
    [self.scnView.scene.rootNode addChildNode:floorNode];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentScene)];
    [self.scnView addGestureRecognizer:tap];
}
- (void)presentScene{
    
    //创建目标转换场景
    SCNScene *scene = [SCNScene scene];
    [scene.rootNode addChildNode:[[SCNScene sceneNamed:@"palm_tree.dae"].rootNode childNodeWithName:@"PalmTree" recursively:true]];
    //添加一个照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, -100, -1000);
    cameraNode.rotation = SCNVector4Make(1, 0, 0, M_PI);
    cameraNode.camera.automaticallyAdjustsZRange = true;
    [scene.rootNode addChildNode:cameraNode];
    
    //引用上一个场景
    self.lastScene = self.scnView.scene;
    
    //  创建转换场景
    SKTransition *transition = [SKTransition doorwayWithDuration:1];
    [self.scnView presentScene:scene withTransition:transition incomingPointOfView:cameraNode completionHandler:^{
        
    }];
}
/*

 21-游戏场景的切换

 学习目标
 掌握SceneKit 游戏框架中的几种场景以及如何使用它们。
 
 ####开始吧 场景切换,你应该想到的更换Scene,最简单的方式就是下面这种写法
 
 self.scnView.scene = scene;
 
 运行一下结果,和我们的预期一模一样。你学会了吧,很简单吧！不过就是有点挫而已,那我们怎么让它变的不这么low,就是给它添加过渡动画,目标明确那就去找方法。SCNScene 是SCNView的属性,那就去它里面找方法
 
 - (void)presentScene:(SCNScene *)scene withTransition:(SKTransition *)transition incomingPointOfView:(nullable SCNNode *)pointOfView completionHandler:(nullable void (^)())completionHandler NS_AVAILABLE(10_11, 9_0);
 
 参数说明:
 
 scene 你要切换到的场景
 transition 过渡动画类型
 pointOfView 切换到的场景中的照相机节点
 completionHandle 完成后的block块
 
 有一个参数我要说一下,transition 过渡动画类型 你会发现他是SKTransition 这个是什么类型呢? 悄悄的告诉你,苹果还有一个2D 游戏框架(SpriteKit) 这个类就是它里面的,简书上有人在写SpriteKit框架的教程,有兴趣的可以去搜。
 
 我们去看看它都过渡动画
 
 + (SKTransition *)crossFadeWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)fadeWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)fadeWithColor:(SKColor *)color duration:(NSTimeInterval)sec;
 + (SKTransition *)flipHorizontalWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)flipVerticalWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)revealWithDirection:(SKTransitionDirection)direction duration:(NSTimeInterval)sec;
 + (SKTransition *)moveInWithDirection:(SKTransitionDirection)direction duration:(NSTimeInterval)sec;
 + (SKTransition *)pushWithDirection:(SKTransitionDirection)direction duration:(NSTimeInterval)sec;
 + (SKTransition *)doorsOpenHorizontalWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)doorsOpenVerticalWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)doorsCloseHorizontalWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)doorsCloseVerticalWithDuration:(NSTimeInterval)sec;
 + (SKTransition *)doorwayWithDuration:(NSTimeInterval)sec;
 
 动画效果还挺多的,就不一一演示了,我在使用这个方法的时候,遇到了一个大坑。看到这个文章的你们可以放心了,我已经把坑填了。
 
 话不多说看代码!
 1.创建工程(略)
 2.添加框架(略)
 3.添加模型文件(略)
 4.添加照相机(略)
 ...
 
 这些代码完全可以省略了,因为你已经记到心里了,接下来,我们只写转换场景的代码
 
 - (void)presentScene1{
 // 创建目标转换场景
 SCNScene *scene = [SCNScene scene];
 [scene.rootNode addChildNode:[[SCNScene sceneNamed:@"palm_tree.dae"].rootNode childNodeWithName:@"PalmTree" recursively:true]];
 
 // 添加一个照相机
 SCNNode *cameraNode1 = [SCNNode node];
 cameraNode1.camera = [SCNCamera camera];
 cameraNode1.position = SCNVector3Make(0, -100, -1000);
 cameraNode1.rotation = SCNVector4Make(1, 0, 0, M_PI);
 cameraNode1.camera.automaticallyAdjustsZRange = true;
 [scene.rootNode addChildNode:cameraNode1];
 
 // 创建转换场景
 SKTransition *transition = [SKTransition doorwayWithDuration:1];
 [self.scnView presentScene:scene withTransition: transition incomingPointOfView:cameraNode1 completionHandler:^{
 
 }];
 
 运行:
 
 呵呵,报错了
 
 从报错找不到有用的信息怎么办了,上官网找资料
 
 When the transition occurs, the scene property is immediately updated to point to the new scene. Then, the animation occurs. Finally, the strong reference to the old scene is removed. If you need to keep the scene around after the transition occurs, your app needs to keep its own strong reference to the old scene
 
 就是说,你要使用这个动画，需要把当前场景进行强引用,不然就不行。
 
 那我们引用一下就是了
 
 self.lastScene = self.scnView.scene;
 
 然后运行
 
 */

@end
