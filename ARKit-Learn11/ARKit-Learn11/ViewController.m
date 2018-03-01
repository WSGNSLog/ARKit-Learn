//
//  ViewController.m
//  ARKit-Learn11
//
//  Created by shiguang on 2018/3/1.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"

#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //添加SCNView到View中去
    
    SCNView *scnView  = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor blackColor];
    scnView.scene = [SCNScene scene];
    scnView.allowsCameraControl = TRUE; // 允许手动控制
    [self.view addSubview:scnView];
    
    //添加照相机到场景中去
    
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    camera.automaticallyAdjustsZRange = TRUE;
    cameraNode.position = SCNVector3Make(0, 0, 10);
    [scnView.scene.rootNode addChildNode:cameraNode];
    // 增加一个木板
    
    SCNNode *floorNode = [SCNNode nodeWithGeometry:[SCNFloor floor]];
    floorNode.geometry.firstMaterial.diffuse.contents = @"floor.jpg";
    floorNode.physicsBody = [SCNPhysicsBody staticBody];
    [scnView.scene.rootNode addChildNode:floorNode];
    
    SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
    box.firstMaterial.diffuse.contents = @"1.PNG";
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
    boxNode.physicsBody =[SCNPhysicsBody staticBody];
    boxNode.position = SCNVector3Make(0, 10, 0);
    [scnView.scene.rootNode addChildNode:boxNode];
    
    //添加文字几何对象模型，并且设置他们的身体为动态身体
    SCNNode *text1 = [self createTextNodeWithString2:@"好"];
    SCNNode *text2 = [self createTextNodeWithString2:@"好"];
    SCNNode *text3 = [self createTextNodeWithString2:@"学"];
    SCNNode *text4 = [self createTextNodeWithString2:@"习"];
    
    [scnView.scene.rootNode addChildNode:text1];
    [scnView.scene.rootNode addChildNode:text2];
    [scnView.scene.rootNode addChildNode:text3];
    [scnView.scene.rootNode addChildNode:text4];
    
    
    //创建物理身体之前的物理行为
    SCNPhysicsHingeJoint *joint0 = [SCNPhysicsHingeJoint jointWithBodyA:boxNode.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text1.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0.5, 1, 0)];
    SCNPhysicsHingeJoint *joint1 = [SCNPhysicsHingeJoint jointWithBodyA:text1.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text2.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0, 0.5, 0)];
    SCNPhysicsHingeJoint *joint2 = [SCNPhysicsHingeJoint jointWithBodyA:text2.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text3.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0, 0.5, 0)];
    SCNPhysicsHingeJoint *joint3 = [SCNPhysicsHingeJoint jointWithBodyA:text3.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text4.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0, 0.5, 0)];
    
    // 将物理行为添加物理世界中去
    [scnView.scene.physicsWorld addBehavior:joint0];
    [scnView.scene.physicsWorld addBehavior:joint1];
    [scnView.scene.physicsWorld addBehavior:joint2];
    [scnView.scene.physicsWorld addBehavior:joint3];
    
}



// 创建文字的函数
-(SCNNode*)createTextNodeWithString:(NSString*)string{
    SCNText *text = [SCNText textWithString:string extrusionDepth:1];
    text.font = [UIFont systemFontOfSize:1];
    text.firstMaterial.diffuse.contents = @"1.PNG";
    SCNNode *node =[SCNNode nodeWithGeometry:text];
    // 创建一个物理身体,使用指定的形状
    node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithGeometry:[SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0]options:nil]];
    return node;
}
-(SCNNode*)createTextNodeWithString2:(NSString*)string{
    SCNText *text = [SCNText textWithString:string extrusionDepth:1];
    text.font = [UIFont systemFontOfSize:1];
    text.firstMaterial.diffuse.contents = @"1.PNG";
    SCNNode *node =[SCNNode nodeWithGeometry:text];
    // 创建一个物理身体,使用指定的形状
    node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithGeometry:[SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0]options:nil]];
    
    //给每个字体几何模型添加粒子特效
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
    // 创建一个节点添加粒子系统
    SCNNode *particleNode = [SCNNode node];
    [particleNode addParticleSystem:particleSystem];
    particleNode.position = SCNVector3Make(0.5, 0, 0);
    
    [node addChildNode:particleNode];
    
    
    return node;
    
}

/*
 
 14-认识物理行为

 物理行为的定义
 
 定义一个或多个物理组织的高级行为，行为包括连接多个物体的关节，可以让他们一起移动,也可以定义车轮这种行为，让身体想骑车一样滚动。
 
 相关的类(SCNPhysicsBehavior)
 
 你不会直接使用这个类,你实例化这个类的一个子类,定义你想要的行为,并且添加到物理世界去。
 
 接下来,我们介绍这个类都有哪些属性
 
 我去在文档中找,只要这样一句话
 
 SCNPhysicsBehavior is an abstract class that represents a behavior in the physics world.
 
 看来这个类是物理行为的一个基类
 
 这个类是一个抽象的类,我们没法设置它的属性,但是它有四个子类,我们就从它的四个子类入手,去发掘子类的作用。
 
 SCNPhaysicBehavior 子类的介绍
 
 a.SCNPhysicsHingeJoint
 
 作用:
 
 连接两个物体，并允许他们在一个单一的轴上围绕对方转动
 
 b.SCNPhysicsBallSocketJoint
 
 作用:
 
 连接两个物体，并允许他们在任何方向上围绕对方转动
 
 c.SCNPhysicsSliderJoint
 
 作用:
 
 连接两个物体，并允许他们彼此之间滑动或旋转。滑块关节像电机一样工作，在两个物理身体之间施加力或转矩。
 
 d.SCNPhysicsVehicle
 
 作用:
 
 组合物理身体成为类似汽车底盘的东西,你可以控制汽车的驾驶,刹车和加速。使用SCNPhysicsVehicleWheel 对象定义车轮的外观和物理属性。
 
 使用步骤
 
 创建一个或者多个SCNPhysicsBody 绑定他们到每个节点上,作为物理行为的执行者。
 创建配置上面列表中的行为
 使用物理世界(SCNPhysicsWorld)的方法addBehavior: 添加到行为到物理世界中去。
 在进入下一个话题,有必要介绍一个方法
 
 @interface SCNPhysicsHingeJoint : SCNPhysicsBehavior
 + (instancetype)jointWithBodyA:(SCNPhysicsBody *)bodyA axisA:(SCNVector3)axisA anchorA:(SCNVector3)anchorA bodyB:(SCNPhysicsBody *)bodyB axisB:(SCNVector3)axisB anchorB:(SCNVector3)anchorB;
 
 参数:
 
 bodyA bodyB 物理身体没啥好说的. axisA axisB 沿着哪个轴转动,比如(1,0,0)沿着X轴转动 anchorA anchorB 锚点A,锚点B。有些几何体的锚点不在几何体的中心,比如字体的这样几何体,它的锚点在左下角,使用时请注意一下。
 
 走进代码的世界
 1.创建工程
 
 2.添加SceneKit框架
 
 3.添加SCNView到View中去
 
 SCNView *scnView  = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView.backgroundColor = [UIColor blackColor];
 scnView.scene = [SCNScene scene];
 scnView.allowsCameraControl = TRUE; // 允许手动控制
 [self.view addSubview:scnView];
 
 4.添加照相机到场景中去
 
 SCNCamera *camera = [SCNCamera camera];
 SCNNode *cameraNode = [SCNNode node];
 cameraNode.camera = camera;    camera.automaticallyAdjustsZRange = TRUE;
 cameraNode.position = SCNVector3Make(0, 0, 10);
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 5.添加四个文字几何对象模型，并且设置他们的身体为动态身体
 
 SCNNode *text1 = [self createTextNodeWithString:@"库"];
 SCNNode *text2 = [self createTextNodeWithString:@"走"];
 SCNNode *text3 = [self createTextNodeWithString:@"天"];
 SCNNode *text4 = [self createTextNodeWithString:@"涯"];
 
 [scnView.scene.rootNode addChildNode:text1];
 [scnView.scene.rootNode addChildNode:text2];
 [scnView.scene.rootNode addChildNode:text3];
 [scnView.scene.rootNode addChildNode:text4];
 
 // 创建文字的函数
 -(SCNNode*)createTextNodeWithString:(NSString*)string{
 SCNText *text = [SCNText textWithString:string extrusionDepth:1];
 text.font = [UIFont systemFontOfSize:1];
 text.firstMaterial.diffuse.contents = @"1.PNG";
 SCNNode *node =[SCNNode nodeWithGeometry:text];
 // 创建一个物理身体,使用指定的形状
 node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithGeometry:[SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0]options:nil]];
 return node;
 }
 
 6.创建物理身体之前的物理行为
 
 SCNPhysicsHingeJoint *joint0 = [SCNPhysicsHingeJoint jointWithBodyA:boxNode.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text1.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0.5, 1, 0)];
 SCNPhysicsHingeJoint *joint1 = [SCNPhysicsHingeJoint jointWithBodyA:text1.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text2.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0, 0.5, 0)];
 SCNPhysicsHingeJoint *joint2 = [SCNPhysicsHingeJoint jointWithBodyA:text2.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text3.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0, 0.5, 0)];
 SCNPhysicsHingeJoint *joint3 = [SCNPhysicsHingeJoint jointWithBodyA:text3.physicsBody axisA:SCNVector3Make(1, 0, 0) anchorA:SCNVector3Make(0, -0.5, 0) bodyB:text4.physicsBody axisB:SCNVector3Make(1, 0, 0) anchorB:SCNVector3Make(0, 0.5, 0)];
 
 // 将物理行为添加物理世界中去
 [scnView.scene.physicsWorld addBehavior:joint0];
 [scnView.scene.physicsWorld addBehavior:joint1];
 [scnView.scene.physicsWorld addBehavior:joint2];
 [scnView.scene.physicsWorld addBehavior:joint3];
 
 运行:
 

 
 结合上一节的内容可以制作下面的效果:
 
 
 思路很简单，给每个字体几何模型添加粒子特效,代码如下:
 
 SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
 // 创建一个节点添加粒子系统
 SCNNode *particleNode = [SCNNode node];
 [particleNode addParticleSystem:particleSystem];
 particleNode.position = SCNVector3Make(0.5, 0, 0);
 [node addChildNode:particleNode];
 
 总结
 由于本篇作为入门篇,就先做这样一个小的练习,帮助大家理解一下概念,后面在高级篇的时候,我会把其他几个的使用方法详细进行讲解。你有进步了,给自己点个赞!加油!给哥点个赞呗!
 
 赞赏
 */
@end
