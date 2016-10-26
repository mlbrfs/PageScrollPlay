//
//  ScrollViewPagePlayer.swift
//  ScrollViewPlay
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

public enum PagePlayerScrollDirection {
    case vertical     // 纵向
    case horizontal   // 横向
}

 @objc public protocol ScrollViewPagePlayerDelegate: UIScrollViewDelegate {
    
    @objc optional func scrollViewDidChange(lastPage page: Int)
    
    @objc optional func scrollViewDidChange(nextPage page: Int)
    
}

public final class ScrollViewPagePlayer<DATASOURCE>: UIScrollView {
    
    private var leftView: ScrollViewPageCell<DATASOURCE>
    private var centerView: ScrollViewPageCell<DATASOURCE>
    private var rightView: ScrollViewPageCell<DATASOURCE>
    // 滚动方向水平方向
    public var direction: PagePlayerScrollDirection {
        didSet{
            setDefaultContentOffset()
            setContentSizeWithFrame()
        }
    }
    // 代理
    weak public var playDelegate: ScrollViewPagePlayerDelegate?
    
    private var currentPage: Int
    
    public var selectedPage: Int {
        get {
            return currentPage
        }
    }
    
    // 设置切换数据时是否需要刷新当前正在显示视图  默认为false
    public var isChageShowView: Bool = false
    
    // 数据源
    public var dataSource: [DATASOURCE]? {
        didSet {
            // 初始化视图为第一个
            currentPage = 0
            // 改为默认 不可滑动
            self.isScrollEnabled = false
            if let dataSource = dataSource {
                if dataSource.count > 1 {
                    // dataSource大于一时才能滑动
                    self.isScrollEnabled = true
                }
                // 设置视图的内容
                setLeftAndRightDate()
                
                if dataSource.count > 0 {
                    if self.centerView.contentView!.dataSource != nil {
                        if isChageShowView {// 刷新当前显示视图
                            self.centerView.contentView!.setValues(For: dataSource[0])
                        }
                    } else {
                        self.centerView.contentView!.setValues(For: dataSource[0])
                    }
                }
            }
        }
    }
    
    public override var frame: CGRect{
        didSet{
            setDefaultContentOffset()
            setContentSizeWithFrame()
        }
    }
    
    required public init(frame: CGRect, registCellClass className: ScrollViewPageCellContent<DATASOURCE>.Type) {
        //实例化三个子视图
        leftView = ScrollViewPageCell(contentView: className<DATASOURCE>.init())
        centerView = ScrollViewPageCell(contentView: className<DATASOURCE>.init())
        rightView = ScrollViewPageCell(contentView: className<DATASOURCE>.init())
        // 初始化当前显示页
        currentPage = 0
        // 设置默认滑动方向
        direction = .horizontal
        
        super.init(frame: frame)
        addSubview(leftView)
        addSubview(centerView)
        addSubview(rightView)
        
        
        func setDefaultValues() {
            isPagingEnabled = true
            bounces = false
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
            isScrollEnabled = false
            setContentSizeWithFrame()
            // 设置默认ContentOffset
            setDefaultContentOffset()
        }
        // 调用使用
        setDefaultValues()
        
        /* 添加自己为监听者 */
        addObserver(self, forKeyPath: pagePlayerObserKey, options: .new, context: nil)
    }
    
    // 设置默认偏移量
    private func setDefaultContentOffset() {
        if direction == .horizontal {
            contentOffset = CGPoint(x: self.width, y: 0)
        } else {
            contentOffset = CGPoint(x: 0, y: self.height)
        }
    }
    // 设置ContentSize
    private func setContentSizeWithFrame(){
        switch direction {
        case .horizontal:
            contentSize = CGSize(width: width * 3, height: height)
        case .vertical:
            contentSize = CGSize(width: width, height: height * 3)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /* 设置子视图frame */
    public override func layoutSubviews() {
        leftView.frame = self.bounds
        centerView.frame = self.bounds
        rightView.frame = self.bounds
        switch direction {
        case .horizontal:
            leftView.x = 0
            centerView.x = self.width
            rightView.x = self.width * 2
        case .vertical:
            leftView.y = 0
            centerView.y = self.height
            rightView.y = self.height * 2
        }
    }
    
    // 设置左边和右边视图的内容
    private func setLeftAndRightDate() {
        if dataSource != nil && dataSource!.count > 1 {
            let dataSource = self.dataSource!
            // 做一些事情通过选中的page来
            var leftSource: DATASOURCE?
            var rightSource: DATASOURCE?
            if (currentPage == 0) {
                leftSource = dataSource[dataSource.count - 1];
                rightSource = dataSource[currentPage + 1];
            } else if (currentPage == dataSource.count - 1) {
                leftSource = dataSource[currentPage - 1];
                rightSource = dataSource[0];
            } else {
                leftSource = dataSource[currentPage - 1];
                rightSource = dataSource[currentPage + 1];
            }
            leftView.contentView!.setValues(For: leftSource)
            rightView.contentView!.setValues(For: rightSource)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !isUserInteractionEnabled || alpha <= 0.01 || !isScrollEnabled {
            return
        }
        
        func judgeChangeView() {
            // 即将显示上一个试图
            func willlShowLastView() {
                if dataSource!.count > 1 {
                    // 给cell 设置数据
                    centerView.contentView!.setValues(For: leftView.contentView!.dataSource)
                    // 设置当前currentPage
                    currentPage = currentPage == 0 ? dataSource!.count - 1 : currentPage - 1
                    // 代理的回调
                    playDelegate?.scrollViewDidChange!(lastPage: currentPage)
                    // 设置左右的数据
                    setLeftAndRightDate()
                }
            }
            // 即将显示下一个试图
            func willShowNextView() {
                if dataSource!.count > 1 {
                    centerView.contentView!.setValues(For: rightView.contentView!.dataSource)
                    currentPage = currentPage == dataSource!.count - 1 ? 0 : currentPage + 1
                    playDelegate?.scrollViewDidChange!(lastPage: currentPage)
                    setLeftAndRightDate()
                }
            }
            
            if direction == .horizontal {
                if self.contentOffset.x == 0 {
                    contentOffset = CGPoint(x: self.width, y: 0);
                    // 上一个
                    willlShowLastView()
                } else if contentOffset.x == self.width * 2 {
                    contentOffset = CGPoint(x: self.width, y: 0);
                    //下一个
                    willShowNextView()
                }
                
            } else if direction == .vertical {
                if self.contentOffset.y == 0 {
                    contentOffset = CGPoint(x: 0, y: self.height);
                    // 上一个
                    willlShowLastView()
                } else if contentOffset.y == self.height * 2 {
                    contentOffset = CGPoint(x: 0, y: self.height);
                    //下一个
                    willShowNextView()
                }
            }
        }
        
        if dataSource != nil {
            judgeChangeView()
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: pagePlayerObserKey)
    }
    
}
