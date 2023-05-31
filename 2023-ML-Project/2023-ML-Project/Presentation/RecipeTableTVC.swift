//
//  RecipeTableTVC.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import UIKit

import SnapKit
import Then

final class RecipeTableTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var titleTextView: UITextView = UITextView().then {
        $0.textColor = .black
        $0.font = .medium16
        $0.layer.cornerRadius = 15
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.backgroundColor = .lightGreen
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        $0.isEditable = false
        $0.isSelectable = false
    }

    // MARK: - identifier
    
    static let identifier = "RecipeTableTVC"

    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(titleTextView)

        titleTextView.isScrollEnabled = true // 스크롤 활성화

        let fixedWidth = titleTextView.frame.size.width
        let newSize = titleTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = titleTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        titleTextView.frame = newFrame

        titleTextView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(newFrame.height)
        }

        titleTextView.isScrollEnabled = false // 스크롤 비활성화
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension RecipeTableTVC {
    func setData(recipe: RecipeList) {
        self.titleTextView.text = recipe.name
    }
}

// MARK: - UI & Layout

extension RecipeTableTVC {
    private func setUI() {
        self.backgroundColor = .clear
    }
}
