//
//  PopoverFix.swift
//  ShadowZip
//
//  Created by 陈晓龙 on 19/04/2018.
//  Copyright © 2018 陈晓龙. All rights reserved.
//

import Cocoa

class PopoverFix: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func viewDidMoveToWindow() {
        
        guard let frameView = window?.contentView?.superview else {
            return
        }
        
        let backgroundView = NSView(frame: frameView.bounds)
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = .black // colour of your choice
        backgroundView.autoresizingMask = [.width, .height]
        
        frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
        
    }
}
