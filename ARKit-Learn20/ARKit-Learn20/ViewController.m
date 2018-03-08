//
//  ViewController.m
//  ARKit-Learn20
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建游戏专用视图
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scnView];
    
    //创建一个场景
    SCNScene *scene = [SCNScene scene];
    scnView.scene = scene;
    
    //创建一个照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = true;
    cameraNode.position = SCNVector3Make(0, 1000, 1000);
    cameraNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_4);
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    //天际一个灯罩
    SCNCone *cone = [[SCNCone alloc]init];
    cone.topRadius = 1;
    cone.bottomRadius = 25;
    cone.height = 50;
    cone.radialSegmentCount = 10;
    cone.heightSegmentCount = 5;
    
    //创建一个点光源，然后添加到场景中去
    SCNNode *spotLight = [SCNNode node];
    spotLight.geometry = cone;
    spotLight.geometry.firstMaterial.emission.contents = [UIColor yellowColor];
    spotLight.light = [SCNLight light];
    spotLight.position = SCNVector3Make(0, 0, 0);
    spotLight.light.type = SCNLightTypeSpot;
    //spotLight.light?.castsShadow = true
    //spotLight.light?.shadowMode = .forward
    spotLight.light.spotOuterAngle = 30;
    
    /// 注意默认为100 ,由于我们将灯的指点放在1000 灯光照射不到那个距离,所以我们需要调节灯光照射的最远距离
    spotLight.light.zFar = 2000;
    
    //增加一个灯光支点
    SCNNode *handleSpot = [SCNNode node];
    handleSpot.position = SCNVector3Make(0, 1000, 40);
    [handleSpot addChildNode:spotLight];
    [scnView.scene.rootNode addChildNode:handleSpot];
    
    //增加一个移动的行为给灯光
    SCNAction *moveRight = [SCNAction moveTo:SCNVector3Make(100, 1000, 40) duration:2];
    SCNAction *moveLeft = [SCNAction moveTo:SCNVector3Make(-100, 1000, 40) duration:2];
    SCNAction *sequence = [SCNAction sequence:@[moveLeft,moveRight]];
    [handleSpot runAction:[SCNAction repeatActionForever:sequence]];
    
    //让灯光执行
    SCNNode *ambient = [SCNNode node];
    ambient.light = [SCNLight light];
    ambient.light.type = SCNLightTypeAmbient;
    [scene.rootNode addChildNode:ambient];
    
    //创建一个地板
    SCNFloor *floor = [SCNFloor floor];
    floor.firstMaterial.diffuse.contents = @"floor.jpeg";
    SCNNode *floorNode = [SCNNode nodeWithGeometry:floor];
    [scnView.scene.rootNode addChildNode:floorNode];
    
    //添加一个树模型
    SCNNode *treeNode = [[SCNScene sceneNamed:@"palm_tree.dae"].rootNode childNodeWithName:@"tree" recursively:YES];
    treeNode.rotation = SCNVector4Make(1, 0, 0, -M_PI_2);
    [scene.rootNode addChildNode:treeNode];
    
    SCNLookAtConstraint *constaint = [SCNLookAtConstraint lookAtConstraintWithTarget:treeNode];
    spotLight.constraints = @[constaint];
    
    //贴图阴影
    spotLight.light.castsShadow = NO;
    spotLight.light.gobo.contents = @"mip.jpg";
    spotLight.light.gobo.intensity = 0.65;
    spotLight.light.shadowMode = SCNShadowModeModulated;
    
}

/*
 
 23-阴影的使用
 
 掌握SceneKit 框架中的三种阴影创建方式
 
 阴影
 阴影类型 :静态,动态,投射
 
 静态
 这个方式很简单,就是给物体节点增加一个子节点,子节点设置一个图片作为它的阴影
 
 动态
 设置灯光的属性castsShadow 为YES 则,物体移动时,阴影也会跟着变化
 
 投射
 通过设置灯光的属性gobo，来捕捉阴影
 
 ---
 一起敲代码
 第一步 先创建工程

 第二步 添加库SceneKit
 
 第三步 创建游戏视图
 
 let scnView = SCNView(frame: self.view.bounds)
 scnView.backgroundColor = UIColor.black
 self.view.addSubview(scnView)
 
 第四步 创建游戏场景
 
 let scene = SCNScene()
 scnView.scene = scene
 
 第五步 创建一个照相机
 
 let cameraNode  = SCNNode()
 cameraNode.camera = SCNCamera()
 cameraNode.camera?.automaticallyAdjustsZRange = true
 cameraNode.position = SCNVector3(x: 0, y: 1000, z: 1000)
 cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: -Float(M_PI/4))
 scnView.scene?.rootNode.addChildNode(cameraNode)
 
 提示:
 
 摄像机默认方向为 -Z 轴, 我设置它的位置为(0,1000,1000) ,沿自身坐标系x轴顺时针旋转了45度,这个是由于我的模型比较大,一般摄像机的位置是根据模型的大小进行调节的。
 
 第六步 创建一个聚光灯
 
 /// 1.先创建一个灯罩
 let cone = SCNCone(topRadius: 1, bottomRadius: 25, height: 50)
 cone.radialSegmentCount = 10
 cone.heightSegmentCount = 5
 /// 2.创建一个灯节点
 let spotLight  = SCNNode()
 spotLight.geometry = cone
 spotLight.geometry?.firstMaterial?.emission.contents = UIColor.yellow
 spotLight.position = SCNVector3(0, 0, 0)
 spotLight.light = SCNLight()
 spotLight.light?.type = .spot
 spotLight.light?.castsShadow = true
 spotLight.light?.shadowMode = .forward
 spotLight.light?.spotOuterAngle = 60
 spotLight.light?.zFar = 2000
 ///  创建一个支点，放等源
 let handleSpot = SCNNode()
 handleSpot.position = SCNVector3(0, 1000, 40)
 handleSpot.addChildNode(spotLight)
 scnView.scene?.rootNode.addChildNode(handleSpot)
 
 提示:
 
 灯光对象的属性 shadowMode 默认为.forward,如果你设置了这个属性,灯光效应下的阴影效果才能呈现出来,它会根据灯光效应去调节阴影颜色的阿尔法分量值
 
 问题1:知道为什么要设置灯光的最远距离为2000吗？
 
 因为灯光的最远注意默认值为100 ,由于我们将灯的指点放在1000 灯光照射不到那个距离,所以我们需要调节灯光照射的最远距离
 
 问题2:为什么要给灯光添加一个支点,不添加可以吗？
 
 不添加支点,是可以的,但是你要给灯光添加约束，让其对着模型,然后,你让这个灯光移动,这个时候,你会发现灯光节点一动不动,这里为什么不动,猜测是,行为和约束都要计算位置和角度,然而两者冲突了,优先使用约束。
 
 第七步 为了效果明显,给灯光支点添加一个移动的行为
 
 let moveRight = SCNAction.move(to:SCNVector3(100, 1000, 40) , duration: 2)
 let moveLeft = SCNAction.move(to:SCNVector3(-100, 1000, 40) , duration: 2)
 let sequence = SCNAction.sequence([moveLeft,moveRight])
 handleSpot.runAction(SCNAction.repeatForever(sequence))
 
 第八步，添加一个地板，让阴影有地方显示
 
 let floor = SCNFloor()
 floor.firstMaterial?.diffuse.contents = "floor.jpeg"
 let floorNode = SCNNode(geometry: floor)
 scnView.scene?.rootNode .addChildNode(floorNode)
 
 第九步.添加一个模型对象到场景中去
 
 let treeNode  = SCNScene(named: "palm_tree.dae")?.rootNode.childNode(withName: "tree", recursively: true)
 treeNode?.rotation = SCNVector4(x: 1, y: 0, z: 0, w: -Float(M_PI/2))
 scene.rootNode.addChildNode(treeNode!)
 
 第十步 我们想让灯光在移动过程中一直对着我们的模型,所以我们添加一个约束
 
 let constaint = SCNLookAtConstraint(target: treeNode)
 spotLight.constraints = [constaint]
 
 友情提示:
 
 各位小伙伴,注意了,一定要搞清楚这个约束谁是执行者添加给谁，这里的执行是是灯光节点自己,不是支点
 
 以上我们演示了动态阴影的实现过程,我们运行看一下效果
 
 让学习成为一种习惯
 
 接下来演示一下,让灯光发射有形状的光
 
 随便找一张图片
 
 让学习成为一种习惯
 
 修改上面的灯光代码
 
 spotLight.light?.castsShadow = false
 spotLight.light?.gobo?.contents = "mip.jpg"
 spotLight.light?.gobo?.intensity = 0.65
 
 运行效果
 
 让学习成为一种习惯
 
 提示
 
 一般如果我们使用这种效果的话,需要做如下设置
 
 spotLight.light?.shadowMode = .modulated
 
 再次运行
 
 Scenekit_11.gif
 
 今天我们的内容就学习到这里,希望对你有所帮助!
 
 赞赏
 */

@end
