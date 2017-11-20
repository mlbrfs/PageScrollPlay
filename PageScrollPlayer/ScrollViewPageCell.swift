//
//  ScrollViewPageCell.swift
//  ScrollViewPlay
//
//  Created by 马磊 on 2016/10/25.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

class ScrollViewPageCell<DATASOURCE>: UIView {

    var contentView: ScrollViewPageCellContent<DATASOURCE>?
    
    init() {
        super.init(frame: CGRect())
    }
    
    required convenience init(contentView: ScrollViewPageCellContent<DATASOURCE>) {
        
        self.init()
        
        self.contentView = contentView
        
        self.addSubview(contentView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
