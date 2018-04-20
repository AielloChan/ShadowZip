//
//  AppDelegate.swift
//  ShadowZip
//
//  Created by 陈晓龙 on 19/04/2018.
//  Copyright © 2018 陈晓龙. All rights reserved.
//

import Cocoa
import Zip

let TMP_DIR = URL(string:NSTemporaryDirectory())!.appendingPathComponent("com.aiellochan.shadowzip")
let DEBUG = false

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            let icon = NSImage(named: NSImage.Name(rawValue: "statusBarButtonIcon"))
            icon?.isTemplate = true
            button.image = icon
            button.target = self
            button.action = #selector(self.statusBarMouseClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        let mainViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ViewControllerId")) as! ViewController
        
        popover.contentViewController = mainViewController
        popover.behavior = NSPopover.Behavior.transient
        
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let popover = self?.popover {
                if popover.isShown {
                    self?.closePopover(event)
                }
            }
        }
        eventMonitor?.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    /*
     *
     * 功能函数区
     *
     */
    
    @objc func statusBarMouseClicked(sender: NSStatusBarButton) {
        
        let event = NSApp.currentEvent!
        
        switch event.type {
        case NSEvent.EventType.leftMouseUp:
            handleLeftClick()
        case NSEvent.EventType.rightMouseUp:
            handleRightClick(sender)
        default:
            break
        }
    }
    
    func handleRightClick(_ sender: NSStatusBarButton){
        togglePopover(sender)
    }
    
    func handleLeftClick(){
        // 读取剪贴板文本
        let fileURLs = getClipFileURL()
        if fileURLs.count == 0 {
            HGLog.Log("剪贴板读取出错")
            return
        }
        HGLog.Log("成功读取到文本 " + fileURLs.map{$0.absoluteString}.joined(separator: ","))
        // 建立目录
        if createPath(path: TMP_DIR) == false {
            HGLog.Log("建立目录出错")
            return
        }
        HGLog.Log("成功创建缓存目录 " + TMP_DIR.absoluteString)
        // 初始化压缩文件名字
        let zipFileName = fileURLs[0].lastPathComponent
        let zipFileFullPath = TMP_DIR.appendingPathComponent(zipFileName + ".zip")
        HGLog.Log("成功创建压缩文件地址 " + zipFileFullPath.absoluteString)
        // 创建zip
        if zipFiles(filesPath: fileURLs, zipPath: zipFileFullPath) == false {
            HGLog.Log("压缩文件出错")
            return
        }
        HGLog.Log("成功创建 zip 文件")
        // 粘贴到剪贴板
        if setClipFileURL(zipFileFullPath.absoluteString) == false{
            HGLog.Log("放入剪贴板出错")
            return
        }
        HGLog.Log("成功放入剪贴板")
    }
    
    func getClipFileURL() -> [URL]{
        let paseboard = NSPasteboard.general
        let fileURLs = paseboard.readObjects(forClasses: [NSURL.self], options: nil) as! [URL]
        return fileURLs
    }
    // 将文件放入剪贴板
    func setClipFileURL(_ fileAbsURL: String) -> Bool{
        let paseboard = NSPasteboard.general
        // 清空剪贴板
        paseboard.clearContents()
        // 构造文件类型的 URL
        let filePathURL = URL.init(fileURLWithPath: fileAbsURL).absoluteString
        // 定义文件的粘贴类型
        let deprecatedFilenames = NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")
        // 放入剪贴板
        if paseboard.setPropertyList([filePathURL], forType: deprecatedFilenames) {
            return true
        }
        return true
    }
    
    //
    func zipFiles(filesPath: [URL], zipPath: URL)->Bool{
        do {
            try Zip.zipFiles(paths: filesPath, zipFilePath: zipPath, password: nil, progress: { (progress) -> () in
                print(progress)
            })
            return true
        } catch {
            return false
        }
    }
    
    func createPath(path:URL) -> Bool{
        let fm = FileManager()
        if fm.fileExists(atPath: path.absoluteString) {
            return true
        }
        let filePath = URL.init(fileURLWithPath: path.absoluteString)
        do{
            try fm.createDirectory(at: filePath, withIntermediateDirectories:true)
            return true
        }
        catch let error as NSError{
            print(error)
            return false
        }
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

