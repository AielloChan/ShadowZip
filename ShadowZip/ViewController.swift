//
//  ViewController.swift
//  ShadowZip
//
//  Created by Aiello on 19/04/2018.
//  Copyright © 2018 Aiello. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // 打开缓存目录
    @IBAction func openTmpDir(_ sender: NSButton) {
        // 通过 Finder 打开指定路径
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: TMP_DIR.absoluteString)
        HGLog.Log("打开缓存目录成功")
    }
    
    // 清空缓存文件夹
    @IBAction func cleanUpTmpDir(_ sender: NSButton) {
        let fileManager = FileManager.default
        do {
            // 清空指定文件夹
            try fileManager.removeItem(atPath: TMP_DIR.absoluteString)
            HGLog.Log("移除缓存文件成功")
        }
        catch {
            HGLog.Log("移除缓存文件失败")
        }
    }
    // 退出应用
    @IBAction func quitApp(_ sender: NSButton) {
        NSApp.terminate(self)
    }
    // 当点击 popover 中的 logo 时，打开项目 github 页面
    @IBAction func logoClick(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/AielloChan/ShadowZip"), NSWorkspace.shared.open(url) {
            HGLog.Log("打开网址成功")
        }
    }
}

