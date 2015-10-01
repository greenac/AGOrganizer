//
//  AGUnknownDataSourceAndDelegate.swift
//  Organizer
//
//  Created by Andre Green on 9/27/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Cocoa

class AGUnknownDataSourceAndDelegate: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    var files:[AGFile]
    let tableView:NSTableView
    
    init(tableView: NSTableView, files: [AGFile]) {
        self.files = files
        self.tableView = tableView
        
        super.init()
        
        self.tableView.setDelegate(self)
        self.tableView.setDataSource(self)
    }

    @objc func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.files.count
    }
    
    @objc func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let file = self.files[row]
        let text = tableColumn?.identifier == "IndexColumn" ? String(file.index!) : file.originalName
        let cellId = tableColumn?.identifier == "IndexColumn" ? "IndexCell" : "FileNameCell"
        let cellView = tableView.makeViewWithIdentifier(cellId, owner: self) as! NSTableCellView
        cellView.textField!.stringValue = text
        return cellView
    }
}