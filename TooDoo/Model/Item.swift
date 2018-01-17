//
//  ItemInList.swift
//  TooDoo
//
//  Created by Henrik Anthony Odden Sandberg on 16.01.2018.
//  Copyright © 2018 Henrik Anthony Odden Sandberg. All rights reserved.
//

import Foundation

class Item{
    private var _itemName:String
    private var _isChecked:Bool = false
    
    init(_ item: String) {
        _itemName = item
    }
    
    var check: Bool{
        get{
            return _isChecked
        }
    }
    
    func changeCheck(){
        _isChecked = !_isChecked
    }
    
    var item:String{
        get{
            return _itemName
        }
    }
    
}
