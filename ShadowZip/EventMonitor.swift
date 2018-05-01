//
//  EventMonitor.swift
//  ShadowZip
//
//  Created by Aiello on 19/04/2018.
//  Copyright © 2018 Aiello. All rights reserved.
//

import Cocoa

open class EventMonitor {
    
    fileprivate var monitor: AnyObject?
    fileprivate let mask: NSEvent.EventTypeMask
    fileprivate let handler: (NSEvent?) -> ()
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
        // 通过在屏幕上增加遮罩
        //  监听全局事件
        self.mask = mask
        // 调用指定回调函数
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    open func start() {
        // 获得监听对象
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject?
    }
    
    open func stop() {
        // 移除监听对象
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}

