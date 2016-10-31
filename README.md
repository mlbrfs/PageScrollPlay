# PageScrollPlay
一个轮播视图swift3.0

# 使用方式
将ScrollViewPlay下的PageScrollPlay拖入项目即可以使用

 ScrollViewPagePlayer 视图即为轮播视图
 
 实例化时传入Class为继承于ScrollViewPageCellContent的类，该class将被实例化为ScrollViewPagePlayer的cell子视图
 显示的数据通过dataSource传入，dataSource为数组， dataSource装的类型通过泛型赋值，最终会通过
    open func setValues(For source: DATASOURCE?) 方法传入对应的ScrollViewPageCellContent子类中。
  最终完成数据的展示



