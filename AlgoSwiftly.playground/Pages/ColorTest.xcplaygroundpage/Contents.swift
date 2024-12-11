//
//  System Colors Playground
//  fivestars.blog
//
//  Created by Federico Zanetello on 9/6/19.
//

import PlaygroundSupport
import UIKit

final class ContainerViewController: UIViewController {

    lazy var lightViewController: ColorViewController = {
        $0.overrideUserInterfaceStyle = .light
        return $0
    }(ColorViewController())

    lazy var darkViewController: ColorViewController = {
        $0.overrideUserInterfaceStyle = .dark
        return $0
    }(ColorViewController())

    override func loadView() {
        super.loadView()

        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical

        stackView.addArrangedSubview(lightViewController.view)
        stackView.addArrangedSubview(darkViewController.view)

        view = stackView
    }
}

class ColorViewController: UIViewController {
    private let systemColors: [UIColor] = [
        .systemBlue,
        .systemGray,
        .systemGreen,
        .systemIndigo,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemTeal,
        .systemYellow,
    ]
    override func loadView() {
        super.loadView()

        let horizontalStackView = UIStackView()
        horizontalStackView.distribution = .fillEqually

        for color in systemColors {
            let view = UIView()
            view.backgroundColor = color
            horizontalStackView.addArrangedSubview(view)
        }

        view = horizontalStackView
    }
}

let containerViewController = ContainerViewController()
containerViewController.preferredContentSize = CGSize(width: 600, height: 100)
PlaygroundPage.current.liveView = containerViewController
