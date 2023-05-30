//
//  LoadingVC.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import UIKit

import SnapKit
import Then
import Lottie

final class LoadingVC: UIViewController {
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = ImageLiterals.imgBackground
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "나를 위한 맞춤형\n레시피를 추천해주고 있어요"
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
    
    private lazy var loadingAnimationView: LottieAnimationView = .init(name: "loading").then {
        $0.frame = self.view.bounds
        $0.center = self.view.center
        $0.contentMode = .scaleAspectFit
        $0.play()
        $0.loopMode = .loop
    }
    
    private let teamMolangLabel = UILabel().then {
        $0.text = "Team Molang"
        $0.font = .semiBold17
        $0.textColor = .white
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension LoadingVC {
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(backgroundImageView, titleLabel, loadingAnimationView, teamMolangLabel)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(95)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(38)
        }
        
        loadingAnimationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        teamMolangLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
