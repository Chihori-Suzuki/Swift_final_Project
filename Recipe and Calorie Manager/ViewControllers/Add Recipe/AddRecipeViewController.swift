//
//  AddRecipeViewController.swift
//  Recipe and Calorie Manager
//
//  Created by Gil Jetomo on 2021-01-19.
//

import UIKit

class AddRecipeViewController: UIViewController {
    lazy var recipeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Chicken Adobo       "
        tf.font = .systemFont(ofSize: 23)
        tf.becomeFirstResponder()
        tf.layer.cornerRadius = 8
        tf.widthAnchor.constraint(equalToConstant: 255).isActive = true
        tf.backgroundColor = .white
        tf.textColor = UIColor.Theme1.brown
        return tf
    }()
    private var meals = Meal.allCases
    private var breakfastButton = UIButton()
    private var snackButton = UIButton()
    private var lunchButton = UIButton()
    private var dinnerButton = UIButton()
    
    private var mealButtons: [UIButton] {
        let arr = [breakfastButton, lunchButton, dinnerButton, snackButton]
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
        let hStackViewButtons = UIStackView()
        let hStackViewLabels = UIStackView()
        for (index, _) in buttons.enumerated(){
            let sv = UIStackView(arrangedSubviews: [buttons[index], labels[index]])
            sv.axis = .vertical
            sv.distribution = .fill
            sv.widthAnchor.constraint(equalToConstant: 110).isActive = true
            sv.alignment = .center
            sv.spacing = 2
            index > 1 ? hStackViewLabels.addArrangedSubview(sv) : hStackViewButtons.addArrangedSubview(sv)
        }
        hStackViewButtons.axis = .horizontal
        hStackViewButtons.alignment = .center
        hStackViewButtons.distribution = .fill
        hStackViewButtons.spacing = 20
        
        hStackViewLabels.axis = .horizontal
        hStackViewLabels.alignment = .center
        hStackViewLabels.distribution = .fill
        hStackViewLabels.spacing = 20
        
        let sv = UIStackView(arrangedSubviews: [hStackViewButtons, hStackViewLabels])
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
        guard let text = recipeTextField.text, text.count > 3 else {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: sender.center.x - 12, y: sender.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: sender.center.x + 12, y: sender.center.y))
            sender.layer.add(animation, forKey: "position")
            return
        }
        guard let image = sender.currentImage else { return }
        var selectedMeal: Meal?
        for meal in meals {
            if image == UIImage(named: meal.rawValue) {
                selectedMeal = meal
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
        breakfastButton = makeButtons(with: Meal.breakfast.rawValue)
        lunchButton = makeButtons(with: Meal.lunch.rawValue)
        snackButton = makeButtons(with: Meal.snack.rawValue)
        dinnerButton = makeButtons(with: Meal.dinner.rawValue)
        
        var mealLabels = [UILabel]()
        for meal in meals {
            let label = makeMealLabel(with: meal.rawValue)
            mealLabels.append(label)
        }
        let vMealStackView = arrangeHStackViews(with: [breakfastButton, lunchButton, snackButton, dinnerButton], and: mealLabels)
        vStackView.addArrangedSubview(recipeTextField)
        
        vStackView.addArrangedSubview(vMealStackView)
        view.addSubview(vStackView)
        vStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let savedRecipe = Recipe.loadFromDraft() {
            let draftVC = AddIngredientsViewController()
            draftVC.recipeTitle = savedRecipe.title
            draftVC.meal = savedRecipe.meal
            draftVC.ingredients = savedRecipe.ingredients
            navigationController?.pushViewController(draftVC, animated: false)
        } else {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Theme1.blue, NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 30)!]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add New Recipe"
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.Theme1.white
        
        setupLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        recipeTextField.text?.removeAll()
    }
}
