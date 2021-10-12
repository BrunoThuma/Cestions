//
//  RoundedButton.swift
//  Cestions
//
//  Created by Bruno Thuma on 12/10/21.
//

import UIKit

class RoundedButton: UIButton {

    var titleText: String? {
        // didSet é chamado quando alteramos o valor da variável
        didSet {
            setTitle(titleText, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: LayoutMetrics.buttonTitleFontSize, weight: .medium)
        }
    }

    // MARK: - Inicialização
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        // Carinhosamente apelidado de tamic. Setar pra falso é necessário para usarmos auto layout programaticamente
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = LayoutMetrics.buttonCornerRadius
    }

    // Compilador briga com a gente se não implementarmos isso
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Métodos de fábrica (boa charles)
    static func createBlueButton(title: String) -> RoundedButton {
        let blueButton = RoundedButton()

        blueButton.titleText = title
        blueButton.backgroundColor = .systemBlue

        return blueButton
    }

    // MARK: - Layout Metrics
    enum LayoutMetrics {
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = buttonHeight / 2
        // HIG recomenda 16 (fonte: schueda)
        static let buttonHorizontalPadding: CGFloat = 20
        static let buttonTitleFontSize: CGFloat = 18
    }
}
