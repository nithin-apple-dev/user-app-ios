//
//  DropdownView.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit

class DropdownView: UIView {
    var dropDownItems:[String] = []
    var selectedItem:String?
    var tableView: UITableView!
    var isVisible = false
    var didSelectDropdownItem: ((_ item: String) -> Void)?
    private let cellIdentifier = "DropdownItemCell"
    
    convenience init(items: [String], frame: CGRect) {
        self.init()
        dropDownItems = items
        self.frame = frame
        setupDropdown()
    }
    
    private func setupDropdown() {
        tableView = UITableView(frame: CGRect(x: 4, y: 4, width: self.bounds.width - 4*2, height: self.bounds.height - 4*2))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropdownItemCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.reloadData()
        self.addSubview(tableView)
        self.roundCorners(corners: .allCorners, radius: 4)
        self.borderColor(color: .systemGray5)
        self.layer.borderWidth = 2
    }
}

extension DropdownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dropdownCell: DropdownItemCell
        if  let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DropdownItemCell {
            dropdownCell = cell
        } else {
            dropdownCell = DropdownItemCell(style: .default, reuseIdentifier: cellIdentifier)
        }

        dropdownCell.configure(title: dropDownItems[indexPath.row])
        dropdownCell.isItemSelected = dropDownItems[indexPath.row] == selectedItem
        return dropdownCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = dropDownItems[indexPath.row]
        tableView.reloadData()
        if let dropdownAction = didSelectDropdownItem {
            dropdownAction(selectedItem!)
        }
    }
}

class DropdownItemCell: UITableViewCell {
    var rowView: UIView!
    var itemTitle: UILabel!

    var isItemSelected: Bool = false {
        didSet {
            setSelected(isItemSelected)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func configure(title: String) {
        if rowView == nil {
            rowView = UIView(frame: self.contentView.frame)
            itemTitle = UILabel(frame: CGRect(x: 20, y: 0, width: self.contentView.bounds.width-20, height: 40))
        }
        itemTitle.text = title
        rowView.addSubview(itemTitle)
        contentView.addSubview(rowView)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    func setSelected(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        } else {
            contentView.backgroundColor = .white
        }
    }
}
