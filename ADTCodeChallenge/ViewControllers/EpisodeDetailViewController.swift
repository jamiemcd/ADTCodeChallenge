//
//  EpisodeDetailViewController.swift
//  ADTCodeChallenge
//
//  Created by Jamie McDaniel on 9/8/20.
//  Copyright © 2020 Jamie McDaniel. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    
    // MARK: Internal Properties
    
    // MARK: UIViewController Properties
    
    // MARK: IBOutlets

    // MARK: Private Properties
    
    private var textView: UITextView!
    
    private var episode: Episode!
    
    // MARK: Init / Deinit
    
    static func make(_ episode: Episode) -> EpisodeDetailViewController {
        let episodeDetailViewController = EpisodeDetailViewController()
        episodeDetailViewController.episode = episode
        return episodeDetailViewController
    }
    
    // MARK: Public Methods
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        var constraints: [NSLayoutConstraint] = []
        constraints.append(textView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(textView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(textView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(textView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
        
        updateUI()
    }
    // MARK: IBActions
    
    // MARK: Private Methods
    
    private func updateUI() {
        title = episode.shortName
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: episode.name, font: UIFont.preferredFont(forTextStyle: .largeTitle), color: .black))
        attributedText.append(NSAttributedString(string: "\n\(episode.airDate)", font: UIFont.preferredFont(forTextStyle: .body), color: .darkGray))
        textView.attributedText = attributedText
    }
    
    // MARK: - Extension for Protocol conformance
    
}

