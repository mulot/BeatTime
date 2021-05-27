//
//  BeatTimeMenuBarApp.swift
//  BeatTimeMenuBar
//
//  Created by Julien Mulot on 27/05/2021.
//

import SwiftUI

@main
struct BeatTimeMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {}
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var timer: Timer!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.hide(nil)
        let contentView = ContentView()
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 100, height: 100)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        /*
         let view = NSHostingView(rootView: contentView)
         // Don't forget to set the frame, otherwise it won't be shown.
         view.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
         let menuItem = NSMenuItem()
         menuItem.view = view
         let menu = NSMenu()
         menu.addItem(menuItem)
         */
        // StatusItem is stored as a class property.
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        //self.statusItem?.menu = menu
        self.statusItem?.button?.title = "@" + BeatTime().beats()
        self.statusItem?.button?.action = #selector(showPopover(_:))
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self]timer in
            self.statusItem?.button?.title = "@" + BeatTime().beats()
            let contentView = ContentView()
            self.popover?.contentViewController = NSHostingController(rootView: contentView)
        }
    }
    
    @objc func showPopover(_ sender: AnyObject?) {
        if let button = self.statusItem?.button
        {
            if self.popover!.isShown {
                self.popover?.performClose(sender)
            } else {
                self.popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
