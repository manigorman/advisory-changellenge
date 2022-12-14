//
//  SignInViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit
import SnapKit

protocol ILogInView: AnyObject {
    func shouldActivityIndicatorWorking(_ flag: Bool)
    func showAlert(message: String)
}

final class LogInViewController: UIViewController {
    
    // Dependencies
    private let presenter: ILogInPresenter
    
    // Private
    
    // UI
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var label = UILabel()
    private lazy var loginField = UITextField()
    private lazy var passwordField = UITextField()
    private lazy var button = UIButton()
    private lazy var indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initialization
    
    init(presenter: ILogInPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpConstraints()
        setUpDelegates()
    }
    
    // MARK: - Actions
    
    @objc private func logInButtonTapped() {
        
        guard let login = loginField.text,
              let password = passwordField.text,
              !login.isEmpty,
              !password.isEmpty else {
            alertInfoError()
            return
        }
        
        presenter.didTapLogIn(login: login, password: password)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        title = "Log in"
        
        label.text = "?????????????? ?????????? ?? ???????????? ?????? ?????????? ?? ???????????????? ????????????????????"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = TextColorScheme.foreground2
        label.numberOfLines = 2
        
        loginField.autocapitalizationType = .none
        loginField.autocorrectionType = .no
        loginField.returnKeyType = .continue
        loginField.backgroundColor = BackgroundColorScheme.background
        loginField.layer.cornerRadius = 8
        loginField.placeholder = "Login"
        loginField.setLeftPaddingPoints(12)
        
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.placeholder = "Password"
        passwordField.backgroundColor = BackgroundColorScheme.background
        passwordField.layer.cornerRadius = 8
        passwordField.isSecureTextEntry = true
        passwordField.setLeftPaddingPoints(12)
        
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        button.setTitleColor(ApplicationColorScheme.fixedWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = ApplicationColorScheme.accent
        button.layer.cornerRadius = 8
        
        indicator.backgroundColor = .systemBackground.withAlphaComponent(0.85)
    }
    
    private func setUpConstraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(loginField)
        loginField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(passwordField)
        passwordField.snp.makeConstraints {
            $0.top.equalTo(loginField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(passwordField.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUpDelegates() {
        loginField.delegate = self
        passwordField.delegate = self
    }
}

// MARK: - ILogInView

extension LogInViewController: ILogInView {
    
    func shouldActivityIndicatorWorking(_ flag: Bool) {
        if flag {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    func showAlert(message: String) {
        self.alertInfoError(message: message)
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginField:
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            logInButtonTapped()
        }
        return true
    }
}
