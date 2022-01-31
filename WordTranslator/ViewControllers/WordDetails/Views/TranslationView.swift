//
//  ExampleView.swift
//  WordTranslator
//
//  Created by Skyeng on 27.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import UIKit
import AVKit

class TranslationView: UIView {
    private var player: AVPlayer?
    private var wordDetail: WordDetails?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var wordNameLabel: UILabel = {
        let wordNameLabel = UILabel()
        wordNameLabel.numberOfLines = 0
        wordNameLabel.textColor = .white
        wordNameLabel.font = UIFont.boldSystemFont(ofSize: 27)
        wordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return wordNameLabel
    }()
    
    private lazy var wordNameTranslationLabel: UILabel = {
        let wordNameTranslation = UILabel()
        wordNameTranslation.numberOfLines = 0
        wordNameTranslation.textColor = .white
        wordNameTranslation.font = UIFont.systemFont(ofSize: 19)
        wordNameTranslation.translatesAutoresizingMaskIntoConstraints = false
        return wordNameTranslation
    }()
    
    private lazy var speakerButton: UIButton = {
        let speakerButton = UIButton()
        speakerButton.setImage(UIImage(named: "speaker"), for: .normal)
        speakerButton.layer.cornerRadius = 12
        speakerButton.clipsToBounds = true
        speakerButton.translatesAutoresizingMaskIntoConstraints = false
        speakerButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        return speakerButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with wordDetail: WordDetails) {
        self.wordDetail = wordDetail
        
        wordNameLabel.text = wordDetail.text
        wordNameTranslationLabel.text = wordDetail.translation?.text
        
        getPicture()
    }
    
    private func setupView() {
        backgroundColor = UIColor(
            red: (2/255.0),
            green: (173/255.0),
            blue: (251/255.0),
            alpha: 1
        )
        layer.cornerRadius = 20
        clipsToBounds = true
        
        addSubview(imageView)
        addSubview(wordNameLabel)
        addSubview(wordNameTranslationLabel)
        addSubview(speakerButton)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            ])
        
        NSLayoutConstraint.activate([
            wordNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            wordNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            wordNameLabel.rightAnchor.constraint(equalTo: speakerButton.leftAnchor, constant: -8)
            ])
        
        NSLayoutConstraint.activate([
            speakerButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12 ),
            speakerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            speakerButton.widthAnchor.constraint(equalToConstant: 25),
            speakerButton.heightAnchor.constraint(equalToConstant: 25)
            ])
        
        NSLayoutConstraint.activate([
            wordNameTranslationLabel.topAnchor.constraint(equalTo: wordNameLabel.bottomAnchor, constant: 8),
            wordNameTranslationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            wordNameTranslationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            wordNameTranslationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            ])
    }
    
    @objc private func playSound() {
        player = nil
        player?.pause()
        let urlLink = wordDetail?.soundUrl
        if let url = URL(string: "https:\(urlLink ?? " ")") {
            player = AVPlayer(
                playerItem: AVPlayerItem(url: url)
            )
        }
        player?.play()
    }
    
    //MARK: - getPicture
    private func getPicture() {
        guard let imageUrlPath = wordDetail?.images?.first?.url,
            let imageUrl = URL(string:"https:\(imageUrlPath)") else {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "placeholder")
                }
                return
        }
        DispatchQueue.global(qos: .utility).async {
            guard let pictureData = NSData(contentsOf: imageUrl as URL),
                let picture = UIImage(data: pictureData as Data) else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "placeholder")
                    }
                    return
            }
            DispatchQueue.main.async {
                self.imageView.image = picture
            }
        }
    }
}
