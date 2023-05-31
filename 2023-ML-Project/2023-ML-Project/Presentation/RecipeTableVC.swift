//
//  RecipeTableVC.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import UIKit

import SnapKit
import Then

final class RecipeTableVC: UIViewController {
    
    var recipes: [RecipeList] = []

    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "내가 가진 재료로 만들 수 있는\n손쉬운 레시피예요"
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
    
    private lazy var recipeTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.contentInset = UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0)
        $0.isScrollEnabled = false
        $0.allowsSelection = true
        $0.isUserInteractionEnabled = true
    }
    
    private let teamMolangLabel = UILabel().then {
        $0.text = "Team Molang"
        $0.font = .semiBold17
        $0.textColor = .black
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        register()
    }
}

// MARK: - UITableViewDelegate

extension RecipeTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 70 // 셀 간의 간격
        let text = recipes[indexPath.row].name
        
        let font = UIFont.medium16 // 사용하는 폰트 설정
        let textHeight = text.height(withConstrainedWidth: tableView.bounds.width - 54, font: font)
        
        return textHeight + spacing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let recipeDetailVC = RecipeDetailVC()
        let recipe = recipes[indexPath.row]
        recipeDetailVC.setData(model: recipe)

        // 이전에 생성된 RecipeDetailVC를 사용하여 모달로 표시
        present(recipeDetailVC, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension RecipeTableVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: RecipeTableTVC.identifier, for: indexPath) as? RecipeTableTVC else { return UITableViewCell()}
        recipeTableViewCell.selectionStyle = .none
        recipeTableViewCell.isUserInteractionEnabled = true
        let recipe = recipes[indexPath.row]
        recipeTableViewCell.setData(recipe: recipe)
        return recipeTableViewCell
    }
}


// MARK: - Methods

extension RecipeTableVC {
    private func setDelegate() {
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
    }
}

// MARK: - General Helpers

extension RecipeTableVC {
    private func register() {
        recipeTableView.register(RecipeTableTVC.self, forCellReuseIdentifier: RecipeTableTVC.identifier)
    }
}

// MARK: - UI & Layout

extension RecipeTableVC {
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(titleLabel, recipeTableView, teamMolangLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(29)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(38)
        }
        
        recipeTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(48)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        teamMolangLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
