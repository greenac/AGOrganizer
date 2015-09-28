//
//  AGUnknownDataSourceAndDelegate.swift
//  Organizer
//
//  Created by Andre Green on 9/27/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Cocoa

class AGUnknownDataSourceAndDelegate: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    var data:[AGFile]
    let tableView:NSTableView
    
    init(tableView: NSTableView, data: [AGFile]) {
        self.data = data
        self.tableView = tableView
        
        super.init()
        
        self.tableView.setDelegate(self)
        self.tableView.setDataSource(self)
    }

    @objc func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return data.count
    }
    
    @objc func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = NSView(frame: NSMakeRect(0, 0, tableView.bounds.width, tableView.rowHeight))
        view.layer?.backgroundColor = row % 2 == 0 ? NSColor.greenColor().CGColor : NSColor.blueColor().CGColor
        return view
    }
}