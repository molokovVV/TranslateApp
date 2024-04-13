//
//  ViewController.swift
//  TranslateApp
//
//  Created by Виталик Молоков on 12.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var translatingFromEnglishToRussian = true
    
    private lazy var sourceTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor.darkGray
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.isEditable = true
        textView.delegate = self
        return textView
    }()
    
    private lazy var translatedTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor.darkGray
        textView.textColor = UIColor.systemCyan
        textView.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.isEditable = false
        return textView
    }()
    
    private lazy var toggleLanguageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EN → RU", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(toggleLanguage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHierarchy()
        setupLayouts()
        setupHideKeyboardGesture()
    }
    
    private func setupHierarchy() {
        view.addSubview(sourceTextView)
        view.addSubview(translatedTextView)
        view.addSubview(toggleLanguageButton)
    }
    
    private func setupLayouts() {
        toggleLanguageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        sourceTextView.snp.makeConstraints { make in
            make.top.equalTo(toggleLanguageButton.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(view).multipliedBy(0.4)
        }
        
        translatedTextView.snp.makeConstraints { make in
            make.top.equalTo(sourceTextView.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    @objc func toggleLanguage() {
            translatingFromEnglishToRussian = !translatingFromEnglishToRussian
            toggleLanguageButton.setTitle(translatingFromEnglishToRussian ? "EN → RU" : "RU → EN", for: .normal)
            translateText()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func translateText() {
        let sl = translatingFromEnglishToRussian ? "en" : "ru"
        let dl = translatingFromEnglishToRussian ? "ru" : "en"
        guard let text = sourceTextView.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            translatedTextView.text = ""
            return
        }
        TranslatorAPI.translate(text: text, from: sl, to: dl) { [weak self] translatedText in
            DispatchQueue.main.async {
                if self?.sourceTextView.text.isEmpty ?? true {
                    self?.translatedTextView.text = ""
                } else {
                    self?.translatedTextView.text = translatedText
                }
            }
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
         translateText()
    }
}


