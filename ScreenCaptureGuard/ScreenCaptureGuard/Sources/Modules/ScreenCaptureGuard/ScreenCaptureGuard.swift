//
//  ScreenCaptureGuard.swift
//  ScreenCaptureGuard
//
//  Created by Agatai Embeev on 26.02.2024.
//

import UIKit
import SnapKit

/// Класс, отвечающий за предотвращение записи экрана и скриншота  в приложении
final class ScreenCaputreGuard {
    
    // MARK: - Static Properties
    
    /// Создание `ScreenCaputreGuard` общего класса, который гарантирует, что в приложении существует только один экземпляр
    static let shared: ScreenCaputreGuard = .init()
    
    // MARK: - Private Properties
    
    private var secureField: UITextField?
    private let alertView = UIView()
    
    private var appWindow: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    // MARK: - Deinit
    /// Деинициализирует instance `ScreenCaputreGuard` и удаляет notification observers.
    deinit {
        removeNotificationObservers()
    }
}

// MARK: - Methods

extension ScreenCaputreGuard {
    
    /// Активирует предотвращение записи экрана, сделав экран безопасным и добавив notification observers.
    func startPreventing() {
        makeScreenSecure()
        addNotificationObservers()
    }
    
    /// Деактивирует предотвращение записи экрана, убирает secure field
    func stopPreventing() {
        guard secureField != nil else { return }
        
        secureField?.isSecureTextEntry = false
        removeNotificationObservers()
    }
}

// MARK: - Private Methods

private extension ScreenCaputreGuard {
    
    /// Создает secure text field на область всего окна экрана, не давая пользователям  делать записи и скриншоты.
    func makeScreenSecure() {
        guard let window = appWindow, secureField == nil else {
            secureField?.isSecureTextEntry = true
            return
        }
        
        let field = UITextField()
        field.isSecureTextEntry = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height))
        
        window.addSubview(field)
        window.layer.superlayer?.addSublayer(field.layer)
        
        field.layer.sublayers?.last?.addSublayer(window.layer)
        field.leftView = view
        field.leftViewMode = .always
        
        secureField = field
    }
    
    /// Создает и отображает view при обнаружении попытки записи экрана.
    func makeScreenCaptureView(window: UIWindow) {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: nil)
        blurVisualEffectView.frame = window.bounds
        
        UIView.animate(withDuration: 0.5) {
            blurVisualEffectView.effect = blurEffect
        }
        
        alertView.frame = window.bounds
        
        let titleLabel = createLabel(font: .boldSystemFont(ofSize: 24), text: "Внимание", color: .black)
        let subtitleLabel = createLabel(font: .boldSystemFont(ofSize: 16), text: "Запись экрана запрещена", color: .black.withAlphaComponent(0.8))
        let stackView = createStackView(with: [createImageView(), titleLabel, subtitleLabel])
        
        alertView.addSubviews(blurVisualEffectView, stackView)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
        }
        
        window.addSubview(alertView)
    }
    
    /// Добавляет notification observers для событий снятия экрана и скриншотов.
    func addNotificationObservers() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.preventScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.preventScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        }
    }
    
    /// Удаляет notification observers.
    func removeNotificationObservers() {
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        }
    }
}

// MARK: Action

private extension ScreenCaputreGuard {
    
    /// Предотвращает снятие экрана, отображая предупреждение в случае его обнаружения.
    @objc private func preventScreenRecording() {
        if UIScreen.main.isCaptured {
            guard let window = appWindow else { return }
            makeScreenCaptureView(window: window)
        } else {
            alertView.removeFromSuperview()
        }
    }
    
    /// Предотвращает снятие скриншота, отображая верхнее предупреждение.
    @objc private func preventScreenshot() {
        makeScreenSecure()
    }
}

// MARK: - Create UI

private extension ScreenCaputreGuard {
    ///  Создание UI элементов для вью
    func createImageView() -> UIImageView {
        let imageView: UIImageView = {
            $0.image = UIImage(systemName: "atom")
            $0.contentMode = .scaleAspectFit
            return $0
        }(UIImageView())
        
        return imageView
    }
    
    func createLabel(font: UIFont, text: String, color: UIColor) -> UILabel {
        let titleLabel: UILabel = {
            $0.numberOfLines = 0
            $0.font = font
            $0.text = text
            $0.textAlignment = .center
            $0.textColor = color
            return $0
        }(UILabel())
        
        return titleLabel
    }
    
    func createStackView(with arrangedSubviews: [UIView]) -> UIStackView {
        let stackView: UIStackView = {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .center
            $0.distribution = .fill
            return $0
        }(UIStackView(arrangedSubviews: arrangedSubviews))
        
        return stackView
    }
}
