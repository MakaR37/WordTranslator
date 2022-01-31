//
//  ExampleView.swift
//  WordTranslator
//
//  Created by Skyeng on 27.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import UIKit
import AVKit

class ExampleView: UIView {
    private var player: AVPlayer?
    private let soundUrl: URL
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton()
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 15
        playButton.clipsToBounds = true
        playButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        return playButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .gray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    init(title: String, soundUrl: URL) {
        self.soundUrl = soundUrl
        
        super.init(frame: .zero)
        titleLabel.text = title
        
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(playButton)
        addSubview(titleLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 30),
            playButton.widthAnchor.constraint(equalToConstant: 30)
            ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            ])
    }
    
    @objc private func playSound() {
        player?.pause()
        player = nil
        
        player = AVPlayer(
            playerItem: AVPlayerItem(url: soundUrl)
        )
        player?.play()
    }
}
