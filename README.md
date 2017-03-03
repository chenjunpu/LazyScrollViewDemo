# iOS 高性能异构滚动视图构建方案 —— LazyScrollView
思路来自阿里天猫团队的[高性能异构滚动视图构建方案](http://pingguohe.net/2016/01/31/lazyscroll.html)

LazyScrollView 继承自ScrollView，目标是解决异构（与TableView的同构对比）滚动视图的复用回收问题。它可以支持跨View层的复用，用易用方式来生成一个高性能的滚动视图。

个人实现，细节还有待完善......
官方已推出请[查看](https://github.com/alibaba/LazyScrollView)

![image](https://github.com/chenjunpu/LazyScrollView/blob/master/Preview.gif)
