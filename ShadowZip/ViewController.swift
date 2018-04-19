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
    }
    
    @IBAction func cleanUpTmpDir(_ sender: NSButton) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: TMP_DIR.absoluteString)
            print("移除缓存文件成功")
        }
        catch {
            print("移除缓存文件失败")
        }
    }
    
    @IBAction func quitApp(_ sender: NSButton) {
        NSApp.terminate(self)
    }
    
}

