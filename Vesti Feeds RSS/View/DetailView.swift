//
//  DetailView.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    //ui elements
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceHorizontal = false
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let imageView: WebImageView = {
        let iv = WebImageView()
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private let descriptionTextView: TextView = {
        let textView = TextView()
        textView.sideInset = 5
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 17)
        return textView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionTextView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    //initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: FeedCellViewModel) {
        descriptionTextView.text = viewModel.fullText
        titleLabel.text = viewModel.title
        guard let imageUrl = viewModel.enclosures.first else { return }
        imageView.set(imageUrl: imageUrl)
    }
    
    //setting up layout
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        backgroundColor = .white
        
        NSLayoutConstraint.activate([
            
            //scroll view constraints
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // image view
            imageView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.71),
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1, constant: -20),
            
            //stackView constraints
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        stackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
    }
}











