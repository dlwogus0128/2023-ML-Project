//
//  RecipeDetailStepTVC.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/31.
//

import UIKit

import SnapKit
import Then

final class RecipeDetailStepTVC: UITableViewCell {
    
    // MARK: - identifier
    
    static let identifier = "RecipeDetailStepTVC"
    
    // MARK: - UI Components
    
    private let stepLabel = UILabel().then {
        $0.font = .semiBold24
        $0.textColor = .black
        $0.text = "ㅇ"
    }
    
    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension RecipeDetailStepTVC {
    func setData(step: Step, indexPath: IndexPath) {
        self.stepLabel.text = "step \(indexPath.row + 1)"
    }
}
// MARK: - UI & Layout

extension RecipeDetailStepTVC {
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews(stepLabel)
        
        stepLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
    }
}
