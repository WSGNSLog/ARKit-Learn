//
//  ViewController.m
//  ARKit-Learn16
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()
@property (nonatomic,weak)SCNView *scnView;
@property (nonatomic,weak)SCNIKConstraint *ikConstrains;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建游戏场景
    
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor blackColor];
    scnView.allowsCameraControl = true;
    scnView.scene = [SCNScene scene];
    scnView.scene.physicsWorld.gravity = SCNVector3Make(0, 90, 0);// 添加一个重力，我们让其方向朝上
    [self.view addSubview:scnView];
    self.scnView = scnView;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, 0, 1000);
    cameraNode.camera.automaticallyAdjustsZRange = true;
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    [self addArmToScene];
}
//添加机械手臂并设置约束
- (void)addArmToScene{
    //创建手掌
    SCNNode *handNode = [SCNNode node];
    handNode.geometry = [SCNBox boxWithWidth:20 height:20 length:20 chamferRadius:0];
    handNode.geometry.firstMaterial.diffuse.contents = [UIColor purpleColor];
    handNode.position = SCNVector3Make(0, -50, 0);
    
    //创建小臂
    SCNNode *lowerArm = [SCNNode node];
    lowerArm.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
    lowerArm.geometry.firstMaterial.diffuse.contents = [UIColor redColor];
    lowerArm.position = SCNVector3Make(0, -50, 0);
    lowerArm.pivot = SCNMatrix4MakeTranslation(0, 50, 0);//连接点
    [lowerArm addChildNode:handNode];
    
    //创建上臂
    SCNNode *upperArm = [SCNNode node];
    upperArm.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
    upperArm.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
    upperArm.pivot = SCNMatrix4MakeTranslation(0, 50, 0);
    [upperArm addChildNode:lowerArm];
    
    //创建控制点
    SCNNode *controNode = [SCNNode node];
    controNode.geometry = [SCNSphere sphereWithRadius:10];
    controNode.geometry.firstMaterial.diffuse.contents = [UIColor blueColor];
    [controNode addChildNode:upperArm];
    controNode.position = SCNVector3Make(0, 100, 0);
    
    //添加到场景中去
    [self.scnView.scene.rootNode addChildNode:controNode];
    
    //创建约束
    SCNIKConstraint *ikConstrains = [SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:controNode];
    self.ikConstrains = ikConstrains;
    //给执行器添加约束
    handNode.constraints  = @[ikConstrains];
    
    //.添加一个手势，每次点击屏幕，随机增加一个球
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
    [self.scnView addGestureRecognizer:tap];
    
}
-(void)tapHandle{
    [self createNodeToScene:self.scnView.scene andConstraint:self.ikConstrains];
}
-(void)createNodeToScene:(SCNScene*)scene andConstraint:(SCNIKConstraint*)ikConstrait{
    
    SCNNode *node = [SCNNode node];
    node.position = SCNVector3Make(arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100));
    [scene.rootNode addChildNode:node];
    
    node.geometry = [SCNSphere sphereWithRadius:10];
    node.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1];
    //创建动画，当手掌接触到小球时，给小球添加一个动态身体
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    self.ikConstrains.targetPosition = node.position;
    [SCNTransaction commit];
    node.physicsBody = [SCNPhysicsBody dynamicBody];
}
/*
 
 19-约束
 
 我们在做应用开发的时候,也会用到约束,应用中的约束,就是当一个视图变化的时候，让和他之间有约束关系的其他视图,按照一定的约束规则变化,那在游戏中,我们的约束是用来干什么的? 官方的解释:
 
 约束能够根据你定义的规则，自动调整这些变化(位置 旋转 和 比例)
 
 认识新朋友
 SCNConstraint
 这个是游戏中的约束类,是一个抽象的类,我们不能直接使用,但是它有3个子类可以供我们使用。
 
 我们看这个类有哪些属性
 
 
  作用: 影响因子，决定约束的强度
 工作原理: 如果设置为1 那么在游戏每一帧渲染的时候,系统都会调整这个约束,如果你设置为0.5 在游戏的某些帧,系统不会进行约束调整 0 完全忽略约束
 注意 SCNTransformConstraint  对这类约束不起作用
 
 var influenceFactor: CGFloat,默认值为 1，这是为0 时,则

接下来我们分析三个子类

SCNLookAtConstraint
1.作用:

让一个节点的方向,总是指向另外一个一个节点

2.怎么用?

我举个简单的例子，帮助大家理解它的用法

如果你想要玩第一视角的游戏,这是我们需要让摄像机捕捉到人物移动时的位置,这是需要给照相机节点添加一个SCNLookAtConstraint 类型的约束,就能实现这个效果。

3.原理

其实这个约束的原理是更改节点的transform的属性

4.怎么创建

// target 就是指向的那个目标节点
+ (instancetype)lookAtConstraintWithTarget:(SCNNode *)target;

5.我们如果想要照相机的视野保持在水平面上,也就是说只沿在Y轴转动跟随目标节点,我们应该怎么做呢?

// 设置下面的属性为YES，就能实现上面的效果，默认为NO
var gimbalLockEnabled: Bool

SCNTransformConstraint
1.作用

创建一个转换约束(提供给节点一个新的转换的计算),当系统进行下一次渲染的时候，会重新计算这个块中的约束,然后调整节点的状态

2.创建方法

/*
 * world 设置为YES 使用世界坐标系，设置为NO 使用自身坐标系
 + (instancetype)transformConstraintInWorldSpace:(BOOL)world  withBlock:(SCNMatrix4 (^)(SCNNode *node,  SCNMatrix4 transform))block
 
 SCNIKConstraint(反向运动约束)
 1.作用
 
 将一个节点链移动到一个目标位置
 
 给张图理解一下:
 
 让学习成为一种习惯
 
 2.使用步骤
 
 1.创建一个节点链
 2.给根节点添加 SCNIKConstraint 约束对象(胳膊)
 3.添加约束給执行器(手)
 3.限定链式节点移动的范围
 4.设置目标位置,这个值可以动态的改变
 
 3.举个例子理解一下
 
 比如机器人的组成身体 上臂 胳膊 和 手,身体是上臂的根节点,上臂是胳膊的根节点,胳膊是手的根节点，手是身体的根节点,如果我们要实现上面的约束的话，需要将约束的根节点设置为上臂,那我们把这个约束应该添加到手(执行)这个节点上去
 
 4.创建反向运动约束
 
 - (instancetype)initWithChainRootNode:(SCNNode *)chainRoot
 + inverseKinematicsConstraintWithChainRootNode:
 
 5.设置约束的最大旋转角度
 
 - (void)setMaxAllowedRotationAngle:(CGFloat)angle
 forJoint:(SCNNode *)node
 
 6.设置目标位置
 
 var targetPosition: SCNVector3
 
 
 友情提示:
 
 第一种约束和第二种约束都很简单,在这里就不写代码了,我们重点研究一下,第三种约束的实现。
 
 制作一个机器手模型
 
 1.创建工程(略)
 2.添加模型文件(略)
 3.添加框架
 4.创建游戏场景
 
 scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView.backgroundColor = [UIColor blackColor];
 scnView.allowsCameraControl = true;
 scnView.scene = [SCNScene scene];
 scnView.scene.physicsWorld.gravity = SCNVector3Make(0, 90, 0);// 添加一个重力，我们让其方向朝上
 [self.view addSubview:scnView];
 
 5.添加照相机
 
 SCNNode *cameraNode = [SCNNode node];
 cameraNode.camera = [SCNCamera camera];
 cameraNode.camera.automaticallyAdjustsZRange = true;
 cameraNode.position = SCNVector3Make(0, 0,1000);
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 6.添加机器手臂并设置约束
 
 -(void)addArmToScene{
 
 // 创建手掌
 SCNNode *handNode = [SCNNode node];
 handNode.geometry = [SCNBox boxWithWidth:20 height:20 length:20 chamferRadius:0];
 handNode.geometry.firstMaterial.diffuse.contents = [UIColor purpleColor];
 handNode.position = SCNVector3Make(0, -50, 0);
 
 // 创建小手臂
 SCNNode *lowerArm = [SCNNode node];
 lowerArm.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
 lowerArm.geometry.firstMaterial.diffuse.contents = [UIColor redColor];
 lowerArm.position = SCNVector3Make(0, -50, 0);
 lowerArm.pivot = SCNMatrix4MakeTranslation(0, 50, 0); // 连接点
 [lowerArm addChildNode:handNode];
 
 // 创建上臂
 SCNNode *upperArm = [SCNNode node];
 upperArm.geometry = [SCNCylinder cylinderWithRadius:1 height:100];
 upperArm.geometry.firstMaterial.diffuse.contents = [UIColor greenColor];
 upperArm.pivot = SCNMatrix4MakeTranslation(0, 50, 0);
 [upperArm addChildNode:lowerArm];
 
 // 创建控制点
 SCNNode *controlNode = [SCNNode node];
 controlNode.geometry = [SCNSphere sphereWithRadius:10];
 controlNode.geometry.firstMaterial.diffuse.contents = [UIColor blueColor];
 [controlNode addChildNode:upperArm];
 controlNode.position= SCNVector3Make(0, 100, 0);
 
 // 添加到场景中去
 [scnView.scene.rootNode addChildNode:controlNode];
 scnView.delegate = self;
 
 // 创建约束
 ikContrait =[SCNIKConstraint inverseKinematicsConstraintWithChainRootNode:controlNode];
 
 // 给执行器添加约束
 handNode.constraints = @[ikContrait];
 }
 
 7.添加一个手，每次点击屏幕，随机增加一个球
 
 // 添加手势
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
 [scnView addGestureRecognizer:tap];
 -(void)tapHandle{
 [self createNodeToScene:scnView.scene andConstraint:ikContrait];
 }
 
 -(void)createNodeToScene:(SCNScene*)scene andConstraint:(SCNIKConstraint*)ikConstrait{
 SCNNode *node = [SCNNode node];
 node.position = SCNVector3Make(arc4random_uniform(100), arc4random_uniform(100), arc4random_uniform(100));
 [scene.rootNode addChildNode:node];
 node.geometry = [SCNSphere sphereWithRadius:10];
 node.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1];
 // 创建动画，当手掌接触到小球时,给小球添加一个动态身体
 [SCNTransaction begin];
 [SCNTransaction setAnimationDuration:0.5];
 ikConstrait.targetPosition = node.position;
 [SCNTransaction commit];
 node.physicsBody = [SCNPhysicsBody dynamicBody];
 }
 
 运行一下试试看:

 */


@end
