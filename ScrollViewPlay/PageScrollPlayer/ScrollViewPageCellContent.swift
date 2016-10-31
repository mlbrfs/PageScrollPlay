//
//  ScrollViewPageCellContent.swift
//  ScrollViewPlay
//
//  Created by 马磊 on 2016/10/26.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

open class ScrollViewPageCellContent<DATASOURCE> : UIView{
    
    open var modelData: DATASOURCE?
    
    required public init() {
        super.init(frame: CGRect())
    }
    
    public convenience init(_ dataSource: DATASOURCE) {
        self.init()
        self.modelData = dataSource
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setValues(For source: DATASOURCE?) {
        modelData = source
    }
    
}
