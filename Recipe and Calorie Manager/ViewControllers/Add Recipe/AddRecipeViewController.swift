//
//  AddRecipeViewController.swift
//  Recipe and Calorie Manager
//
//  Created by Kazunobu Someya on 2021-01-19.
//

import UIKit

class AddRecipeViewController: UIViewController {
    
    let recipeTextField: UITextField = {
       let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Chicken Parmigiano"
        tf.font = .systemFont(ofSize: 25)
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.becomeFirstResponder()
        tf.layer.borderWidth = 0.8
        tf.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tf.layer.cornerRadius = 8
        tf.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private var meals = ["breakfast", "lunch", "dinner", "snack"]
    private var breakfastButton = UIButton()
    private var snacksButton = UIButton()
    private var lunchButton = UIButton()
    private var dinnerButton = UIButton()
    
    private var mealButtons: [UIButton] {
        let arr = [breakfastButton, lunchButton, dinnerButton, snacksButton]
        return arr
    }
    
    let vStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill
        sv.spacing = 40
        return sv
    }()
    
    fileprivate func makeButtons(with image: String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: image), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(mealSelected(_:)), for: .touchUpInside)
        return btn
    }
    
    func makeMealLabel(with string: String) -> UILabel {
        let label = UILabel()
        label.text = string
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.layer.cornerRadius = 6
        label.alpha = 0.80
        return label
    }
    
    fileprivate func arrangeHStackViews(with buttons: [UIButton], and labels: [UILabel]) -> UIStackView {
        let hSVButtonLabels1 = UIStackView()
        let hSVButtonLabels2 = UIStackView()
        for (index, _) in buttons.enumerated(){
            let sv = UIStackView(arrangedSubviews: [buttons[index], labels[index]])
            sv.axis = .vertical
            sv.distribution = .fill
            sv.widthAnchor.constraint(equalToConstant: 110).isActive = true
            sv.alignment = .center
            sv.spacing = 2
            index > 1 ? hSVButtonLabels2.addArrangedSubview(sv) : hSVButtonLabels1.addArrangedSubview(sv)
        }
        
        hSVButtonLabels1.axis = .horizontal
        hSVButtonLabels1.alignment = .center
        hSVButtonLabels1.distribution = .fill
        hSVButtonLabels1.spacing = 30
        
        hSVButtonLabels2.axis = .horizontal
        hSVButtonLabels2.alignment = .center
        hSVButtonLabels2.distribution = .fill
        hSVButtonLabels2.spacing = 30
        
        let sv = UIStackView(arrangedSubviews: [hSVButtonLabels1, hSVButtonLabels2])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 25
        return sv
    }
    
    @objc func mealSelected(_ sender: UIButton) {
        UIView.animate(withDuration: 0.10) {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { (_) in
            UIView.animate(withDuration: 0.10) {
                sender.transform = CGAffineTransform.identity
            }
        }
        guard let image = sender.currentImage else { return }
        var selectedMeal: Meal?
        for meal in meals {
            if image == UIImage(named: meal) {
                selectedMeal = Meal(rawValue: meal)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let newRecipeVC = AddIngredientsViewController()
            newRecipeVC.recipeTitle = self.recipeTextField.text
            newRecipeVC.meal = selectedMeal
            self.navigationController?.pushViewController(newRecipeVC, animated: true)
        }
    }

    fileprivate func setupLayout() {
        breakfastButton = makeButtons(with: "breakfast")
        lunchButton = makeButtons(with: "lunch")
        snacksButton = makeButtons(with: "snack")
        dinnerButton = makeButtons(with: "dinner")
        
        var mealLabels = [UILabel]()
        for meal in meals {
            let label = makeMealLabel(with: meal)
            mealLabels.append(label)
        }
        let vMealStackView = arrangeHStackViews(with: [breakfastButton, lunchButton, dinnerButton, snacksButton], and: mealLabels)
        vStackView.addArrangedSubview(recipeTextField)
        vStackView.addArrangedSubview(vMealStackView)
        view.addSubview(vStackView)
        vStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Theme1.blue, NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 35)!]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Recipe"
        view.backgroundColor = UIColor.Theme1.white
        setupLayout()
    }
    
    @objc func addNewRecipe() {
        let newRecipeVC = AddIngredientsViewController()
        newRecipeVC.recipeTitle = recipeTextField.text
        recipeTextField.text?.removeAll()
        navigationController?.pushViewController(newRecipeVC, animated: true)
    }
    
    @objc func textEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, text.count > 3 else {
            for button in mealButtons {
                button.alpha = 0.5
                button.isEnabled = false
            }
            return
        }
        for button in mealButtons {
            button.alpha = 1.0
            button.isEnabled = true
        }
    }
}
