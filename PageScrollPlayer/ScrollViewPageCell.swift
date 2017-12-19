//
//  ScrollViewPageCell.swift
//  ScrollViewPlay
//
//  Created by 马磊 on 2016/10/25.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

class ScrollViewPageCell<DATASOURCE>: UIView {

    var selected: (()->())?
    
    var contentView: ScrollViewPageCellContent<DATASOURCE>?
    
    init() {
        super.init(frame: CGRect())
//        self.contentView = contentView
//        self.addSubview(contentView)
//        let ges = UITapGestureRecognizer.init(target: self, action: #selector(didTap))
//        addGestureRecognizer(ges)
    }
    
    required convenience init(contentView: ScrollViewPageCellContent<DATASOURCE>) {
        
        self.init()
        
        self.contentView = contentView
        self.addSubview(contentView)
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(didTap))
        addGestureRecognizer(ges)
    }
    
    @objc private func didTap() {
        
        selected?()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
