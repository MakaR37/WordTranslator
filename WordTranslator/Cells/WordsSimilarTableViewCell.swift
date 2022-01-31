//
//  File.swift
//  WordTranslator
//
//  Created by Артем Мак on 13.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import UIKit

class WordsSimilarTableViewCell: UITableViewCell {
    static var identifire = "WordsSimilarTableViewCell"
    
    public lazy var wordPictureImageView: UIImageView = {
        let wordPictureImageView = UIImageView()
        wordPictureImageView.layer.cornerRadius = 15
        wordPictureImageView.clipsToBounds = true
        wordPictureImageView.translatesAutoresizingMaskIntoConstraints = false
        wordPictureImageView.image = UIImage(named: "placeholder")
        return wordPictureImageView
    }()
    
    private lazy var wordNameLabel: UILabel = {
        let wordNameLabel = UILabel()
        wordNameLabel.font = UIFont.systemFont(ofSize: 18)
        wordNameLabel.textColor = .black
        wordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return wordNameLabel
    }()
    
    private lazy var wordTranslationLabel: UILabel = {
        let wordTranslationLabel = UILabel()
        wordTranslationLabel.font = UIFont.systemFont(ofSize: 15)
        wordTranslationLabel.textColor = .lightGray
        wordTranslationLabel.translatesAutoresizingMaskIntoConstraints = false
        return wordTranslationLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurate(with meaning: Word) {
        wordNameLabel.text = meaning.text
        wordTranslationLabel.text = meaning.meanings[0].translation?.text
        imageRequest(with: meaning.meanings[0])
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 25
        contentView.layer.borderColor = UIColor.green.cgColor
        contentView.addSubview(wordPictureImageView)
        contentView.addSubview(wordNameLabel)
        contentView.addSubview(wordTranslationLabel)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: (42/255.0), green: (200/255.0), blue: (236/255.0), alpha: 0.76)
        selectedBackgroundView = backgroundView
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            wordPictureImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            wordPictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            wordPictureImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            wordPictureImageView.widthAnchor.constraint(equalToConstant: 65),
            ])
        
        NSLayoutConstraint.activate([
            wordNameLabel.topAnchor.constraint(equalTo:  wordPictureImageView.topAnchor),
            wordNameLabel.leadingAnchor.constraint(equalTo: wordPictureImageView.trailingAnchor, constant: 13),
            wordNameLabel.heightAnchor.constraint(equalToConstant: 25),
            wordNameLabel.widthAnchor.constraint(equalToConstant: 150),
            ])
        
        NSLayoutConstraint.activate([
            wordTranslationLabel.topAnchor.constraint(equalTo: wordNameLabel.bottomAnchor, constant: 5),
            wordTranslationLabel.leadingAnchor.constraint(equalTo: wordNameLabel.leadingAnchor),
            wordTranslationLabel.bottomAnchor.constraint(equalTo: wordPictureImageView.bottomAnchor),
            wordTranslationLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width + 120)
            ])
    }
    
    private func imageRequest(with word: Meaning) {
        guard let imageUrlPath = word.previewUrl,
            let imageUrl = URL(string:"https:\(imageUrlPath)") else {
                wordPictureImageView.image = UIImage(named: "placeholder")
                return
        }
        DispatchQueue.global(qos: .utility).async {
            guard let pictureData = NSData(contentsOf: imageUrl as URL),
                let picture = UIImage(data: pictureData as Data) else {
                    self.wordPictureImageView.image = UIImage(named: "placeholder")
                    return
            }
            DispatchQueue.main.async {
                self.wordPictureImageView.image = picture
            }
        }
    }
}

