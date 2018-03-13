//
//  ViewController.m
//  ARKit-Learn23
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()
@property (nonatomic,weak) SCNView *scnView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scnView];
    self.scnView = scnView;
    
    SCNScene *scene = [SCNScene scene];
    scnView.scene = scene;
    
    SCNText *text = [SCNText textWithString:@"好好学习" extrusionDepth:1];
    text.font = [UIFont systemFontOfSize:1];
    SCNNode * textNode = [SCNNode nodeWithGeometry:text];
    textNode.position = SCNVector3Make(-2, -0.5, -2);
    [scnView.scene.rootNode addChildNode:textNode];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [scnView addGestureRecognizer:tap];
    
    
    
}
- (void)tap:(UITapGestureRecognizer *)ges{
    ;
    NSArray *results = [self.scnView hitTest:[ges locationInView:self.scnView] options:nil];
    SCNHitTestResult *hitResult = results.firstObject;
    SCNNode *node = hitResult.node;
    SCNVector3 vec = node.position;
    
}

/*
 
 26-如何获取单击节点事件
 
 ####本节学习目标
 
 掌握如何获取用户单机节点的时间
 
 先认识一个方法,这个方法在SCNView 里面
 
 public func hitTest(_ point: CGPoint, options: [SCNHitTestOption : Any]? = nil) -> [SCNHitTestResult]
 
 当我们手点击屏幕时,要知道我们都点到了那些节点,我们应该怎么处理呢？
 
 首先我们添加一个手势到视图中去
 
 let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle(gesture:)))
 scnView.addGestureRecognizer(tap)
 
 然后，我们获取点击到的第一个节点
 
 func tapHandle(gesture:UITapGestureRecognizer){
 let results:[SCNHitTestResult] = (self.scnView?.hitTest(gesture.location(ofTouch: 0, in: self.scnView), options: nil))!
 guard let firstNode  = results.first else{
 return
 }
 // 点击到的节点
 print(firstNode.node)
 }
 
 ####认识类SCNHitTestResult
 
 open class SCNHitTestResult : NSObject {
 
 /// 击中的几点
 open var node: SCNNode { get }
 
 /// 击中的几何体索引
 open var geometryIndex: Int { get }
 
 /// 击中的面的索引
 open var faceIndex: Int { get }
 
 /// 击中的本地坐标系统
 open var localCoordinates: SCNVector3 { get }
 
 
 /// 击中的世界坐标系统
 open var worldCoordinates: SCNVector3 { get }
 
 
 /// 击中节点的本地法线坐标
 open var localNormal: SCNVector3 { get }
 
 
 /// 击中的世界坐标系统的法线坐标
 open var worldNormal: SCNVector3 { get }
 
 
 / World transform of the node intersected. /
open var modelTransform: SCNMatrix4 { get }


/ The bone node hit. Only available if the node hit has a SCNSkinner attached. /
@available(iOS 10.0, *)
open var boneNode: SCNNode { get }


/
 @method textureCoordinatesWithMappingChannel:
 @abstract Returns the texture coordinates at the point of intersection, for a given mapping channel.
 @param channel The texture coordinates source index of the geometry to use. The channel must exists on the geometry otherwise {0,0} will be returned.
 /
open func textureCoordinates(withMappingChannel channel: Int) -> CGPoint
}

 */


@end
