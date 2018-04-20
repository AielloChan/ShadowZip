//
//  ViewController.swift
//  ShadowZip
//
//  Created by 陈晓龙 on 19/04/2018.
//  Copyright © 2018 陈晓龙. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func openTmpDir(_ sender: NSButton) {
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: TMP_DIR.absoluteString)
        HGLog.Log("打开缓存目录成功")
    }
    
    @IBAction func cleanUpTmpDir(_ sender: NSButton) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: TMP_DIR.absoluteString)
            HGLog.Log("移除缓存文件成功")
        }
        catch {
            HGLog.Log("移除缓存文件失败")
        }
    }
    
    @IBAction func quitApp(_ sender: NSButton) {
        NSApp.terminate(self)
    }
    
    @IBAction func logoClick(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/AielloChan/ShadowZip"), NSWorkspace.shared.open(url) {
            HGLog.Log("打开网址成功")
        }
    }
}

