//
//  TextViewController.swift
//  ScrollViewPlay
//
//  Created by 马磊 on 2016/10/26.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

func arcRandomColor() -> UIColor {
    return UIColor(red:CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
}


class TextViewController: UIViewController {

    var pagePlayer: ScrollViewPagePlayer<Model>?
    
    var pageView: UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        let rect: CGRect = CGRect(x: 0, y: 20, width: view.frame.size.width, height: 200)
        
        pagePlayer = ScrollViewPagePlayer<Model>(frame: rect, registCellClass: PagePlayerCell.classForCoder() as! ScrollViewPageCellContent<Model>.Type)
        pagePlayer?.playDelegate = self
        view.addSubview(pagePlayer!)
        
        pageView = UIPageControl(frame: CGRect(x: (UIScreen.main.bounds.size.width - 100) * 0.5, y: 200, width: 100, height: 20))
        view.addSubview(pageView!)
        pagePlayer!.dataSource = getDate(2)
        pageView?.numberOfPages = pagePlayer!.dataSource!.count
        pageView?.currentPage = pagePlayer!.selectedPage
        addSubButtons()
        
    }
    // 数据来源
    func getDate(_ number: Int) -> [Model] {
        let model1: Model = Model(name: "第一个视图", age: 8, phoneNumber: 1222, color: UIColor.red, textColor: arcRandomColor())
        
        let model2: Model = Model(name: "第二个视图", age: 14, phoneNumber: 124343, color: UIColor.red, textColor: arcRandomColor())
        let model3: Model = Model(name: "第三个视图", age: 28, phoneNumber: 44343, color: UIColor.red, textColor: arcRandomColor())
        let model4: Model = Model(name: "第四个视图", age: 15, phoneNumber: 435443, color: UIColor.red, textColor: arcRandomColor())
        let model5: Model = Model(name: "第五个视图", age: 66, phoneNumber: 437843, color: UIColor.red, textColor: arcRandomColor())
        switch number {
        case 1:
            return [model1]
        case 2:
            return [model1, model2]
        case 5:
            return [model1,model2,model3,model4,model5]
        default:
            return []
        }
        
    }
    //  子按钮组
    func addSubButtons() {
        let lineCount: Int = 2
        let buttonH: CGFloat = 44
        let buttonW: CGFloat = 150
        let padding: CGFloat = (UIScreen.main.bounds.size.width - buttonW * CGFloat(lineCount))/CGFloat(lineCount + 1)
        let btnTitles: [String] = [
            "默认水平方向 两个分页" , "竖直方向 两个分页",
            "水平 只有一个"        , "竖直 只有一个",
            "水平 五个分页"        , "竖直 五个分页",
            ]
        
        for i in 0 ..< btnTitles.count {
            let btn: UIButton = UIButton(type: .custom)
            let buttonX:CGFloat = padding + CGFloat( i % lineCount ) * buttonW
            let buttonY: CGFloat = 300 + CGFloat( i / lineCount ) * buttonH
            btn.setTitle(btnTitles[i], for: .normal)
            btn.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.titleLabel?.autoresizesSubviews = true
            btn.tag = i
            btn.addTarget(self, action: #selector(TextViewController.btnHasClick(_:)), for: .touchUpInside)
            view.addSubview(btn)
        }
        
    }
    // 按钮组的点击事件
    func btnHasClick(_ btn: UIButton) {
        
        switch btn.tag % 2 {
        case 0:
            pagePlayer!.direction = .horizontal
        case 1:
            pagePlayer!.direction = .vertical
        default:
            break
        }
        switch btn.tag / 2 {
        case 0:
            pagePlayer!.dataSource = getDate(2)
        case 1:
            pagePlayer!.dataSource = getDate(1)
        case 2:
            pagePlayer!.dataSource = getDate(5)
        default:
            break
        }
        pageView?.numberOfPages = pagePlayer!.dataSource!.count
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TextViewController: ScrollViewPagePlayerDelegate {
    // 代理
    func scrollViewDidChange(lastPage page: Int) {
        pageView?.currentPage = pagePlayer!.selectedPage
    }
    
    func scrollViewDidChange(nextPage page: Int) {
        pageView?.currentPage = pagePlayer!.selectedPage
    }
    
}
