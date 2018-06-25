//
//  TodoItemTableViewCell.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 21/06/18.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
    @IBOutlet weak var txtIndex: UILabel!
    
    @IBOutlet weak var txtTodoItem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withViewModel viewModel: TodoItemPresentable) -> (Void) {
        txtIndex.text = viewModel.id
        let attributeString =  NSMutableAttributedString(string: viewModel.textValue!)
        if viewModel.isDone! {
            let range = NSMakeRange(0, attributeString.length)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.lightGray, range: range)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: range)
            attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: range )
        }
        
        txtTodoItem.attributedText = attributeString
    }
    
}
