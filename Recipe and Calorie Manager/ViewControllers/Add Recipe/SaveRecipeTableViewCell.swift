//
//  SaveRecipeTableViewCell.swift
//  Recipe and Calorie Manager
//
//  Created by Macbook Pro on 2021-01-22.
//

import UIKit

protocol SaveRecipeTableViewCellDelegate: class {
    func save(_ mealType: Meal, _ recipe: RecipeFinal)
    func discardRecipe()
}

class SaveRecipeTableViewCell: UITableViewCell {
    
    static let identifier = "saveRecipe"
    var newRecipe: RecipeFinal?
    var mealType: Meal?
    weak var delegate: SaveRecipeTableViewCellDelegate?
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.Theme1.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.widthAnchor.constraint(equalToConstant: 85).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = #colorLiteral(red: 0.6553853061, green: 0.8888800762, blue: 0.3222138089, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveRecipe(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var discardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Discard", for: .normal)
        button.setTitleColor(UIColor.Theme1.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.widthAnchor.constraint(equalToConstant: 85).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.backgroundColor = UIColor.Theme1.orange
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(discardRecipe(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [discardButton, UIView(), saveButton])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(hStackView)
        contentView.backgroundColor = UIColor.Theme1.white
        contentView.heightAnchor.constraint(equalTo: hStackView.heightAnchor, multiplier: 1).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        hStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveRecipe(_ sender: UIButton) {
        UIView.animate(withDuration: 0.10) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { (_) in
            UIView.animate(withDuration: 0.10) {
                sender.transform = CGAffineTransform.identity
            }
        }
        
        //temporary code for testing
        guard let meal = mealType, let recipe = newRecipe else { return }
        delegate?.save(meal, recipe)
    }
    
    @objc func discardRecipe(_ sender: UIButton) {
        UIView.animate(withDuration: 0.10) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { (_) in
            UIView.animate(withDuration: 0.10) {
                sender.transform = CGAffineTransform.identity
            }
        }
        
        delegate?.discardRecipe()
    }
}

