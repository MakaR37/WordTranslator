//
//  detailedInformationAboutWord.swift
//  WordTranslator
//
//  Created by Артем Мак on 17.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import UIKit


class WordDetailsViewController: UIViewController {
    public var wordId: Int?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .red
        return stackView
    }()
    
    private lazy var translationView: TranslationView = {
        let translationView = TranslationView.init()
        translationView.translatesAutoresizingMaskIntoConstraints = false
        return translationView
    }()
    
    private lazy var transcriptionLabel: UILabel = {
        let transcriptionLabel = UILabel()
        transcriptionLabel.numberOfLines = 0
        transcriptionLabel.textColor = .darkGray
        transcriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return transcriptionLabel
    }()
    
    private lazy var definitionLabel: UILabel = {
        let definitionLabel = UILabel()
        definitionLabel.numberOfLines = 0
        definitionLabel.textColor = .darkGray
        definitionLabel.translatesAutoresizingMaskIntoConstraints = false
        return definitionLabel
    }()
    
    private lazy var wordAddButton: UIButton = {
        let wordAddButton = UIButton()
        wordAddButton.backgroundColor = UIColor(red: (2/255.0), green: (173/255.0), blue: (251/255.0), alpha: 1)
        wordAddButton.setTitle("Добавить в словарь", for: .normal)
        wordAddButton.setTitleColor(.white, for: .normal)
        wordAddButton.layer.cornerRadius = 15
        wordAddButton.translatesAutoresizingMaskIntoConstraints = false
        return wordAddButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        fetchWordDetails()
    }
    
    //MARK: - showErrorAlert
    private func showErrorAlert(title: String, message: String) {
        let errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionRepeatButton = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.fetchWordDetails()
        }
        let actionCloseButton =  UIAlertAction(title: "Выйти", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        errorAlertController.addAction(actionRepeatButton)
        errorAlertController.addAction(actionCloseButton)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    //MARK: - setupViews
    private func setupViews() {
        navigationController?.isNavigationBarHidden = false
        self.view.backgroundColor = .white
        
        view.addSubview(scrollView)
        view.addSubview(wordAddButton)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(translationView)
        stackView.addArrangedSubview(transcriptionLabel)
        stackView.addArrangedSubview(definitionLabel)
    }
    
    //MARK: - setupDataView
    func setupDataView(wordDetail: WordDetails) {
        translationView.configure(with: wordDetail)
        
        transcriptionLabel.text = ("/\(wordDetail.transcription!)/" + " " + "•" + " " + "\(wordDetail.meaningsWithSimilarTranslation?.first?.partOfSpeechAbbreviation ?? "")" )
        definitionLabel.text = wordDetail.definition?.text
        
        if let examples = wordDetail.examples {
            for example in examples {
                if let title = example.text,
                    let soundLink = example.soundUrl,
                    let soundUrl = URL(string: "https:\(soundLink)") {
                    
                    let exampleView = ExampleView(
                        title: title,
                        soundUrl: soundUrl
                    )
                    stackView.addArrangedSubview(exampleView)
                }
            }
        }
    }
    
    // MARK: - private methods
    private func fetchWordDetails() {
        if let wordId = self.wordId {
            WordSearchNetworkService.shared.getWordDetails(id: wordId) { [weak self] resuls in
                switch resuls {
                case .success(let wordDetail):
                    DispatchQueue.main.async {
                        if let wordDetails = wordDetail.first {
                            self?.setupDataView(wordDetail: wordDetails)
                        }
                    }
                case .failure(let error):
                    self?.showErrorAlert(title: "Данные о слове не получены", message: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - setupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: wordAddButton.topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
            ])
        
        NSLayoutConstraint.activate([
            wordAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            wordAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            wordAddButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -25),
            wordAddButton.heightAnchor.constraint(equalToConstant: 48),
            ])
    }
}
