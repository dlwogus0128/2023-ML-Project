//
//  RecipeDetailVC.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/31.
//

import UIKit

import SnapKit
import Then

final class RecipeDetailVC: UIViewController {
    
    // MARK: - Properties

    var steps: [Step] = []
    var stepLabels: [UILabel] = []
    
    // MARK: - UI Components
    
    private lazy var scrollView = UIScrollView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .semiBold24
        label.textColor = .black
        
        // 행간 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let attributedText = NSMutableAttributedString(string: label.text ?? "")
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private let ingredientsTextView = UITextView().then {
        $0.textColor = .black
        $0.font = .semiBold16
        $0.layer.cornerRadius = 15
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.isScrollEnabled = false
        $0.isEditable = false
    }
    
    private let recipeImageView = UIImageView()
    
    private lazy var stepsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        stepsContainerView.addSubview($0)
    }
    
    private lazy var stepsContainerView = UIView()
    

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStepsLabels()
        setUI()
        setLayout()
        ingredientsTextView.delegate = self
    }
}

// MARK: - UITextViewDelegate

extension RecipeDetailVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

// MARK: - Methods

extension RecipeDetailVC {
    func setData(model: RecipeList) {
        self.titleLabel.text = model.name
        let ingredientsString = model.ingredients.compactMap { key, value in
            return "\(key): \(value)"
        }.joined(separator: "\n")
        self.ingredientsTextView.text = ingredientsString
        self.recipeImageView.setImage(with: model.thumb)
        self.steps = model.steps
        print(steps)
    }
    
    private func createStepsLabels() {
        for (index, step) in steps.enumerated() {
            let stepNumberLabel = UILabel().then {
                $0.font = .semiBold24
                $0.textColor = .black
                $0.text = "Step \(index + 1)."
            }
            
            let stepLabel = UILabel().then {
                $0.font = .medium16
                $0.textColor = .black
                $0.text = step.summury
                $0.numberOfLines = 0 // Set the number of lines to 0 for dynamic wrapping
                $0.lineBreakMode = .byWordWrapping // Set the line break mode
                
                // Customize line spacing
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 8 // Set the desired line spacing

                let attributedText = NSMutableAttributedString(string: $0.text ?? "")
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))

                $0.attributedText = attributedText
                stepLabels.append($0)
            }
            
            let stackView = UIStackView().then {
                $0.axis = .vertical
                $0.spacing = 8
                $0.addArrangedSubview(stepNumberLabel)
                $0.addArrangedSubview(stepLabel)
            }
            
            stepsStackView.addArrangedSubview(stackView)
        }
    }
}

// MARK: - UI & Layout

extension RecipeDetailVC {
    private func setUI() {
        view.backgroundColor = .white
        recipeImageView.backgroundColor = .gray
        scrollView.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(scrollView)
        
        scrollView.addSubviews(titleLabel, recipeImageView, ingredientsTextView, stepsContainerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(98)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(38)
        }
        
        recipeImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }
        
        ingredientsTextView.snp.makeConstraints { make in
            make.top.equalTo(recipeImageView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        stepsContainerView.snp.makeConstraints { make in
            make.top.equalTo(ingredientsTextView.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.bottom.equalToSuperview().offset(-45)
        }
        
        stepsContainerView.addSubview(stepsStackView)
        
        stepsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
