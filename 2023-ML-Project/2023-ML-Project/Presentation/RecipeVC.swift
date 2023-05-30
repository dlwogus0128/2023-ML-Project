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

    private var provider = MoyaProvider<RecipeRouter>()
    
    let photo = UIImagePickerController()
    var imageData: NSData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        openPhoto()
        uploadImage(imageData: imageData as Data?)
        self.photo.delegate = self
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

// MARK: - Network

extension RecipeVC {
    private func uploadImage(imageData: Data?) {
        guard let imageData = self.imageData else { return }
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
                            let recipes = try decoder.decode([RecipeResponseDto].self, from: responseData)

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
