//
//  ViewController.m
//  ARKit-Learn19
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


/*
 22-动态更新属性
 学习目标
 1.学会使用SceneKit中一种原子修改机制(事务)
 2.熟练掌握使用SCNTransaction类中的方法动态的修改属性
 
 认识SCNTransaction
 先认识下面几个方法吧!
 
 在当前线程开始一个新的事务
 
 + (void)begin;
 
 提交当前事务中所做的所有更改
 
 + (void)commit;
 
 提交所有隐式事务,等当前所有事物完成后提交
 
 + (void)flush;
 
 解锁和加锁事务
 
 + (void)lock;
 + (void)unlock;
 
 动画执行时间,默认为( 1/4s)
 
 @property(class, nonatomic) CFTimeInterval animationDuration;
 
 创建动态事物组的时间函数
 
 @property(class, nonatomic, copy, nullable) CAMediaTimingFunction *animationTimingFunction __WATCHOS_PROHIBITED;
 
 是否启用动画
 
 @property(class, nonatomic) BOOL disableActions;
 
 在事物动画完成或者取消后执行
 
 @property(class, nonatomic, copy, nullable) void (^completionBlock)(void);
 
 设置或者获取属性值
 
 + (nullable id)valueForKey:(NSString *)key;
 + (void)setValue:(nullable id)value forKey:(NSString *)key;
 
 如何使用
 方式1
 
 [SCNTransaction setAnimationDuration:3.0];
 sunNode.position = SCNVector3Make(0, 0, 0);
 
 方式2
 
 下面演示的是事物嵌套
 [SCNTransaction begin];
 [SCNTransaction setAnimationDuration:0.5];
 // 0.5 秒执行完毕后 会执行block块
 [SCNTransaction setCompletionBlock:^{
 // 有事一个新的事务
 [SCNTransaction begin];
 [SCNTransaction setAnimationDuration:0.5];
 material.emission.contents = [UIColor blackColor];
 [SCNTransaction commit];
 }];
 material.emission.contents = [UIColor redColor];
 [SCNTransaction commit];
 
 总结
 本节的内容很简单,之前我们讲过行为动画也可以实现动画效果,你觉得两者的区别在哪里,自己思考。
 
 赞赏
 */


@end
