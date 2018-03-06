//
//  ViewController.m
//  ARKit-Learn15
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SCNView *scnView;

@property (nonatomic,strong) SCNNode *thirdViewCamera;

@property (nonatomic,strong) SCNNode *firstViewCamera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建游戏场景

    self.scnView.scene = [SCNScene scene];
    self.scnView.backgroundColor = [UIColor blackColor];
   
    //创建太阳系
    SCNNode *sunNode = [SCNNode node];
    sunNode.geometry = [SCNSphere sphereWithRadius:3];
    sunNode.geometry.firstMaterial.diffuse.contents = @"sun.jpg";
    [self.scnView.scene.rootNode addChildNode:sunNode];
    //太阳绕着Y轴自传
    SCNAction *sunRotate = [SCNAction repeatActionForever:[SCNAction rotateByAngle:0.1 aroundAxis:SCNVector3Make(0, 1, 0) duration:0.3]];
    [sunNode runAction:sunRotate];
    
    //创建一个地月系节点
    SCNNode *earthmoonNode = [SCNNode node];
    earthmoonNode.position = SCNVector3Make(10, 0, 0);
    [sunNode addChildNode:earthmoonNode];
    
    //创建一个地球节点，添加到地月系节点上去
    SCNNode *earthNode = [SCNNode node];
    earthNode.geometry = [SCNSphere sphereWithRadius:1];
    earthNode.position = SCNVector3Make(0, 0, 0);
    earthNode.geometry.firstMaterial.diffuse.contents = @"earth.jpg";
    [earthmoonNode addChildNode:earthNode];
    
    //地球绕着Y轴自传
    SCNAction *earthRotate = [SCNAction repeatActionForever:[SCNAction rotateByAngle:0.1 aroundAxis:SCNVector3Make(0, 1, 0) duration:0.05]];
    [earthNode runAction:earthRotate];
    
    //创建一个月球节点，添加到地球节点上去
    SCNNode *moonNode = [SCNNode node];
    moonNode.geometry = [SCNSphere sphereWithRadius:0.5];
    moonNode.geometry.firstMaterial.diffuse.contents = @"moon.png";
    moonNode.position = SCNVector3Make(2, 0, 0);
    [earthNode addChildNode:moonNode];
    
    

    
    
    //创建一个场景范围内的第三视角
    self.thirdViewCamera = [SCNNode node];
    self.thirdViewCamera.camera = [SCNCamera camera];
    self.thirdViewCamera.camera.automaticallyAdjustsZRange = true;
    self.thirdViewCamera.position = SCNVector3Make(0, 0, 30);
    [self.scnView.scene.rootNode addChildNode:self.thirdViewCamera];
    
    //创建一个地月系的第一视角
    self.firstViewCamera = [SCNNode node];
    self.firstViewCamera.camera = [SCNCamera camera];
    self.firstViewCamera.position = SCNVector3Make(0, 0, 10);
    [earthmoonNode addChildNode:self.firstViewCamera];
    
    
    //决定你视角是哪个
    self.scnView.pointOfView = self.thirdViewCamera;
    
    
    
}

 // 进入太阳系
- (IBAction)enterSunSystem:(UIButton *)sender {
    self.scnView.pointOfView = self.thirdViewCamera;
    
    SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 30) duration:1];
    [self.thirdViewCamera runAction:move];
    
    
}
 // 进入地月系
- (IBAction)enterEarthMoonSystem:(UIButton *)sender {
    
    self.scnView.pointOfView = self.firstViewCamera;
    
}
 // 离开太阳系
- (IBAction)exitSunSystem:(UIButton *)sender {
    
    SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 400) duration:1];
    [self.thirdViewCamera runAction:move];
}


/*

 18-如何实现照相机视角切换
 
 在游戏中,我们经常可以看到,有视角切换这个功能,第一视角,第三视角切换,那在SceneKit中怎么进行视角切换了,今天就带大家练习这个功能!
 
 今天教大家实现下面的效果:
 
 
 不想多少一句废话,直接上干活,如果前面的知识都掌握了,后面的东西学起来很快!加油!
 
 走进代码的世界
 1.创建工程(略)
 
 2.添加素材(自己截图,放到工程中去)
 
 太阳
 
 月球
 
 地球
 
 3.创建3个按钮和SCNView页面
 
 在.m文件中添加对应的三个事件
 
 4.添加框架#import
 
 5.创建游戏场景(这个简单)
 
 self.scnView.scene = [SCNScene scene];
 self.scnView.backgroundColor = [UIColor blackColor];
 
 6.创建太阳系(也很简单)
 
 SCNNode *sunNode = [SCNNode node];
 sunNode.geometry = [SCNSphere sphereWithRadius:3];
 sunNode.geometry.firstMaterial.diffuse.contents = @"sun.jpg";
 [self.scnView.scene.rootNode addChildNode:sunNode];
 
 7.创建地月系(有点复杂哦)
 
 // 1.我们需要先创建一个地月系节点.并且设置它为太阳系的子节点
 SCNNode *earthMoonNode = [SCNNode node];
 earthMoonNode.position = SCNVector3Make(10, 0, 0);
 [sunNode addChildNode:earthMoonNode];
 
 //2.创建一个地球节点,添加到地月系节点上去
 SCNNode *earthNode = [SCNNode node];
 earthNode.geometry = [SCNSphere sphereWithRadius:1];
 earthNode.geometry.firstMaterial.diffuse.contents = @"earth.jpg";
 earthNode.position = SCNVector3Make(0, 0, 0);
 [earthMoonNode  addChildNode:earthNode];
 
 // 3.创建一个月球系，让它添加到地球节点上去
 SCNNode *moonNode = [SCNNode node];
 moonNode.geometry = [SCNSphere sphereWithRadius:0.5];
 moonNode.geometry.firstMaterial.diffuse.contents = @"moon.jpg";
 moonNode.position = SCNVector3Make(2, 0, 0);
 [earthNode addChildNode:moonNode];
 
 8.接下来是,执行运动了
 
 //1.太阳绕着Y轴自传
 SCNAction *sunRotate = [SCNAction repeatActionForever:[SCNAction rotateByAngle:0.1 aroundAxis:SCNVector3Make(0, 1, 0) duration:0.3]];
 [sunNode runAction:sunRotate];
 
 // 2.地球绕着Y轴自传
 SCNAction *rotation =[SCNAction repeatActionForever:[SCNAction rotateByAngle:0.1 aroundAxis:SCNVector3Make(0, 1, 0) duration:0.05]];
 [earthNode runAction:rotation];
 
 完成上面的步骤，太阳系我们创建好了,运行一下试试吧！
 
 9.创建两个视角
 
 // 1.我们创建一个场景范围内的第三视角
 @property(nonatomic,strong)SCNNode *thirdViewCamera;
 self.thirdViewCamera = [SCNNode node];
 self.thirdViewCamera.camera = [SCNCamera camera];
 self.thirdViewCamera.camera.automaticallyAdjustsZRange = true;
 self.thirdViewCamera.position = SCNVector3Make(0, 0, 30);
 [self.scnView.scene.rootNode addChildNode:self.thirdViewCamera];
 
 // 2.我们创建一个地月系的第一视角
 @property(nonatomic,strong)SCNNode *firstViewCamera;
 self.firstViewCamera = [SCNNode node];
 self.firstViewCamera.camera =[SCNCamera camera];
 self.firstViewCamera.position = SCNVector3Make(0, 0, 10);
 [earthMoonNode addChildNode:self.firstViewCamera];
 
 10.下面就是决定你视角是哪个的重要代码，请认真记住
 
 self.scnView.pointOfView = self.thirdViewCamera;
 
 11.下面是和我们界面上绑定的三个button的事件
 
 // 进入太阳系
 - (IBAction)enterSunSystem:(id)sender {
 self.scnView.pointOfView = self.thirdViewCamera;
 SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 30) duration:1];
 [self.thirdViewCamera runAction:move];
 }
 // 进入地月系
 - (IBAction)enterEarthMoonSystem:(id)sender {
 self.scnView.pointOfView = self.firstViewCamera;
 }
 // 离开太阳系
 - (IBAction)exitSunSystem:(id)sender {
 SCNAction *move = [SCNAction moveTo:SCNVector3Make(0, 0, 400) duration:1];
 [self.thirdViewCamera runAction:move];
 }
 
 如果你想要理解三个星球的运动原理,请看下面这张图
 

 
 你应该知道的
 
 系统提供给我们的旋转方法,是只能沿着轴转动,比如你的节点在(0,1,0) 你让他沿着X轴旋转,它旋转后的坐标还是(0,1,0),因为它是沿着自身坐标系旋转的。
 
 上图原理:
 
 我们首先创建一个地月节点,将其设置为太阳的自节点，这样太阳旋转的时候，我们的地月节点，就会围绕这太阳转动,然后我们创建一个地球节点,让其成为地月节点的子节点，这样地球就能和地月节点一起围绕太阳节点转动了,同样的道理，月球节点成为地球节点的子节点，那么地球自身的时候，也能带动月球转动了。
 

 */

@end
