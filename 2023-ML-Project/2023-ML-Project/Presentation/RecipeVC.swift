//
//  RecipeVC.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import UIKit
import AVFoundation
import Photos

import SnapKit
import Then
import Moya

final class RecipeVC: UIViewController {

    // MARK: - Provider
    
    private var provider = MoyaProvider<RecipeRouter>()
    
    // MARK: - Properties
    
    private let photo = UIImagePickerController()
    var imageData: NSData? = nil
    
    
    // MARK: - UI Components
    
    private let backgroundGreenUIImageView = UIImageView().then {
        $0.image = ImageLiterals.imgMain
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "2023S ML Project"
        $0.font = .semiBold17
        $0.textColor = .white
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "내 냉장고 속 재료를 찍어\n업로드하면\n레시피를 추천해요"
        label.font = .semiBold24
        label.textColor = .white
        
        // 행간 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8 
        
        let attributedText = NSMutableAttributedString(string: label.text ?? "")
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        label.attributedText = attributedText
        
        return label
    }()

    private let burgerUIImageView = UIImageView().then {
        $0.image = ImageLiterals.imgBurger
    }
    
    private let teamMolangLabel = UILabel().then {
        $0.text = "Team Molang"
        $0.font = .semiBold17
        $0.textColor = .darkGreen
    }
    
    private let cameraButton: UIButton = UIButton(type: .custom).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semiBold24,
            .foregroundColor: UIColor.darkGreen,
        ]
        let attributedString = NSAttributedString(string: "카메라로 찍기", attributes: attributes)
        
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.darkGreen.cgColor
        $0.layer.borderWidth = 1
    }
    
    private let galaryButton: UIButton = UIButton(type: .custom).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.semiBold24,
            .foregroundColor: UIColor.white,
        ]
        let attributedString = NSAttributedString(string: "갤러리에서 업로드하기", attributes: attributes)
        
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .darkGreen
    }

    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        setLayout()
        setDelegate()
        setAddTarget()
    }
}

// MARK: - Methods

extension RecipeVC {
    private func setDelegate() {
        self.photo.delegate = self
    }
    
    private func setAddTarget() {
        self.galaryButton.addTarget(self, action: #selector(galaryButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - @objc Function

extension RecipeVC {
    @objc func galaryButtonDidTap() {
        openPhoto()
        uploadImage(imageData: imageData as Data?)
    }
}

extension RecipeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 갤러리 오픈
    func openPhoto(){
        DispatchQueue.main.async {
            print("")
            print("===============================")
            print("[A_Image >> openPhoto() :: 앨범 열기 수행 실시]")
            print("===============================")
            print("")
            // -----------------------------------------
            // [사진 찍기 카메라 호출]
            
            self.photo.sourceType = .photoLibrary // 앨범 지정 실시
            self.photo.allowsEditing = false // 편집을 허용하지 않음
            self.present(self.photo, animated: false, completion: nil)
            // -----------------------------------------
        }
    }
    
    // MARK: [사진, 비디오 선택을 했을 때 호출되는 메소드]
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage]{
            
            // [앨범에서 선택한 사진 정보 확인]
            print("")
            print("====================================")
            print("[A_Image >> imagePickerController() :: 앨범에서 선택한 사진 정보 확인 및 사진 표시 실시]")
            //print("[사진 정보 :: ", info)
            print("====================================")
            print("")
            
            
            // [이미지 데이터에 선택한 이미지 지정 실시]
            self.imageData = (img as? UIImage)!.jpegData(compressionQuality: 0.8) as NSData? // jpeg 압축 품질 설정
            
            // [멀티파트 서버에 사진 업로드 수행]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // [1초 후에 동작 실시]
                self.uploadImage(imageData: self.imageData as Data?)
            }
        }
        // [이미지 파커 닫기 수행]
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: [사진, 비디오 선택을 취소했을 때 호출되는 메소드]
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("")
        print("===============================")
        print("[A_Image >> imagePickerControllerDidCancel() :: 사진, 비디오 선택 취소 수행 실시]")
        print("===============================")
        print("")
        
        // [이미지 파커 닫기 수행]
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout Helpers

extension RecipeVC {
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(backgroundGreenUIImageView, subTitleLabel, titleLabel, burgerUIImageView, cameraButton, galaryButton, teamMolangLabel)
        
        backgroundGreenUIImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(364)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(38)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(13)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(38)
        }
        
        burgerUIImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(180)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(117)
            make.width.equalTo(294)
            make.height.equalTo(256)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(52)
            make.top.equalTo(burgerUIImageView.snp.bottom).offset(39)
            make.height.equalTo(103)
        }
        
        galaryButton.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(cameraButton)
            make.top.equalTo(cameraButton.snp.bottom).offset(26)
        }
        
        teamMolangLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Network

extension RecipeVC {
    private func uploadImage(imageData: Data?) {
        guard let imageData = self.imageData else { return }
        let loadingVC = LoadingVC()
        loadingVC.modalPresentationStyle = .overFullScreen
        self.present(loadingVC, animated: false)
        provider.request(.uploadImage(imageData: imageData as NSData)) {[weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseData = result.data
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .iso8601

                        do {
                            let recipes = try decoder.decode([RecipeList].self, from: responseData)

                            for recipe in recipes {
                                print("Name: \(recipe.name)")
                                print("Thumb: \(recipe.thumb)")
                                print("Ingredients: \(recipe.ingredients)")
                                print("Steps:")
                                for step in recipe.steps {
                                    print("- \(step.summury)")
                                }
                                print("-------------------")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                loadingVC.dismiss(animated: false)
                                let recipeTableVC = RecipeTableVC()
                                recipeTableVC.modalPresentationStyle = .overFullScreen
                                recipeTableVC.recipes = recipes // recipes 데이터를 recipeTableVC에 전달
                                self.present(recipeTableVC, animated: false)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
