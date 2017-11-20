//
//  PagePlayerCell.swift
//  ScrollViewPlay
//
//  Created by 马磊 on 2016/10/25.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit
import PageScrollPlayer

class PagePlayerCell: ScrollViewPageCellContent<Model> {
   
    lazy var nameButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 50, y: 30, width: 100, height: 44)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()
    
    required init() {
        super.init()
        
        self.addSubview(nameButton)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setValues(For source: Model?) {
        super.setValues(For: source)
        nameButton.setTitle(source?.name, for: .normal)
        
        nameButton.backgroundColor = source?.color
        
        nameButton.setTitleColor(source?.textColor, for: .normal)
        
        backgroundColor = source?.textColor
        
    }
    
}
