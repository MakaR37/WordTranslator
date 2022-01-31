//
//  ViewController.swift
//  WordTranslator
//
//  Created by Артем Мак on 09.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private let throttle = Throttle(delay: 1)
    public lazy var words: [Word] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var wordSearchStatusImageView: UIImageView = {
        let wordSearchStatusImageView = UIImageView()
        wordSearchStatusImageView.image = UIImage(named: "loupe")
        wordSearchStatusImageView.translatesAutoresizingMaskIntoConstraints = false
        wordSearchStatusImageView.isHidden = false
        return wordSearchStatusImageView
    }()
    
    private lazy var wordSearchStatusLabel: UILabel = {
        let wordSearchStatusLabel = UILabel()
        wordSearchStatusLabel.text = "Введите слово чтобы увидеть перевод"
        wordSearchStatusLabel.textAlignment = .center
        wordSearchStatusLabel.textColor = UIColor(red: (65/225.0), green: (66/225.0), blue: (68/225.0), alpha: 1)
        wordSearchStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        wordSearchStatusLabel.isHidden = false
        return wordSearchStatusLabel
    }()
    
    public lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск новых слов"
        searchController.searchBar.setValue("Готово", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        searchController.isActive = true
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(WordsSimilarTableViewCell.self, forCellReuseIdentifier: WordsSimilarTableViewCell.identifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public func showErrorAlert(title: String, message: String) {
        let errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionRepeatButton = UIAlertAction(title: "Повторить", style: .default) {_ in
            guard let text = self.searchController.searchBar.text else {
                return
            }
            WordSearchNetworkService.shared.getWord(by: text) { [weak self] resuls in
                switch resuls {
                case .success(let words):
                    self?.words = words
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    self?.showErrorAlert(title: "Error", message: error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self?.conditionsChangingView()
                }
            }
        }
        let actionCloseButton =  UIAlertAction(title: "Выйти", style: .cancel, handler: nil)
        errorAlertController.addAction(actionRepeatButton)
        errorAlertController.addAction(actionCloseButton)
        present(errorAlertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraintsView()
        searchController.isActive = true
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(wordSearchStatusImageView)
        self.view.addSubview(wordSearchStatusLabel)
        navigationItem.searchController = self.searchController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        setupNavigationBar()
    }
    
    public func setupNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .lightGray
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupConstraintsView() {
        NSLayoutConstraint.activate ([
            wordSearchStatusImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            wordSearchStatusImageView.centerYAnchor.constraint(equalTo: self.view!.centerYAnchor),
            wordSearchStatusImageView.widthAnchor.constraint(equalToConstant: 70),
            wordSearchStatusImageView.heightAnchor.constraint(equalToConstant: 70)
            ])
        
        NSLayoutConstraint.activate([
            wordSearchStatusLabel.topAnchor.constraint(equalTo: wordSearchStatusImageView.bottomAnchor, constant: 20),
            wordSearchStatusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            wordSearchStatusLabel.widthAnchor.constraint(equalToConstant: 400),
            wordSearchStatusLabel.heightAnchor.constraint(equalToConstant: 40),
            ])
    }
    
    func conditionsChangingView() {
        if searchController.searchBar.text!.isEmpty {
            self.wordSearchStatusImageView.isHidden = false
            self.wordSearchStatusLabel.isHidden = false
            self.wordSearchStatusImageView.image = UIImage(named: "loupe")
            self.wordSearchStatusLabel.text = "Введите слово чтобы увидеть перевод"
            self.tableView.isHidden = true
        } else {
            self.wordSearchStatusImageView.isHidden = true
            self.wordSearchStatusLabel.isHidden = true
            self.tableView.isHidden = false
        }
        if words.isEmpty {
            self.wordSearchStatusImageView.image = UIImage(named: "folder")
            self.wordSearchStatusLabel.text = "Ничего не найдено"
            self.wordSearchStatusImageView.isHidden = false
            self.wordSearchStatusLabel.isHidden = false
            self.tableView.isHidden = true
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WordsSimilarTableViewCell.identifire, for: indexPath) as?
            WordsSimilarTableViewCell {
            cell.configurate(with: words[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = words[indexPath.row]
        let detailVc = WordDetailsViewController()
        guard let wordId = words[indexPath.row].meanings[0].id else {
            self.showErrorAlert(title: "Ошибка", message: "")
            return
        }
        detailVc.wordId = wordId
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        throttle.run {
            WordSearchNetworkService.shared.getWord(by: searchText) { [weak self] resuls in
                switch resuls {
                case .success(let words):
                    self?.words = words
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    self?.showErrorAlert(title: "Error", message: error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self?.conditionsChangingView()
                }
            }
        }
    }
}

