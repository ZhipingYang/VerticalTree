import UIKit
import VerticalTree

final class DemoViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let previewCardView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "VerticalTree"
        view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Console",
            style: .plain,
            target: self,
            action: #selector(printPreviewTree)
        )

        buildInterface()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runLaunchScenarioIfNeeded()
    }

    private func buildInterface() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 18
        contentStackView.layoutMargins = UIEdgeInsets(top: 20, left: 18, bottom: 28, right: 18)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        contentStackView.addArrangedSubview(makeHeaderSection())
        contentStackView.addArrangedSubview(makeActionSection(
            title: "Tree Data",
            rows: [
                [
                    actionButton(title: "Sample Forest", color: Palette.blue, action: #selector(showSampleTree)),
                    actionButton(title: "Pretty Print", color: Palette.green, action: #selector(printSampleTree))
                ]
            ]
        ))

        buildPreviewCard()
        contentStackView.addArrangedSubview(makePreviewSection())
        contentStackView.addArrangedSubview(makeActionSection(
            title: "UIKit Structures",
            rows: [
                [
                    actionButton(title: "Preview View", color: Palette.orange, action: #selector(showPreviewViewTree)),
                    actionButton(title: "Window View", color: Palette.purple, action: #selector(showWindowViewTree))
                ],
                [
                    actionButton(title: "Preview Layer", color: Palette.gray, action: #selector(showPreviewLayerTree)),
                    actionButton(title: "Show Alert", color: Palette.red, action: #selector(showAlert))
                ]
            ]
        ))
    }

    private func makeHeaderSection() -> UIView {
        let section = roundedPanel(backgroundColor: .white)

        let titleLabel = label(
            "Deterministic trees for custom data, views, and layers",
            font: .systemFont(ofSize: 24, weight: .bold),
            color: Palette.ink
        )
        let bodyLabel = label(
            "The sample app is generated from project.yml and installed as a development pod, matching the lightweight workflow used by XYDebugView.",
            font: .systemFont(ofSize: 15, weight: .regular),
            color: Palette.secondaryText
        )
        bodyLabel.numberOfLines = 0

        let badgeRow = UIStackView(arrangedSubviews: [
            pill("XcodeGen"),
            pill("CocoaPods"),
            pill("Pure Code Demo")
        ])
        badgeRow.axis = .horizontal
        badgeRow.spacing = 8
        badgeRow.alignment = .leading

        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel, badgeRow])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        section.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: section.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -18)
        ])

        return section
    }

    private func makePreviewSection() -> UIView {
        let section = roundedPanel(backgroundColor: UIColor(red: 0.98, green: 0.99, blue: 1.0, alpha: 1.0))

        let titleLabel = label("Inspectable Preview", font: .systemFont(ofSize: 19, weight: .semibold), color: Palette.ink)
        let bodyLabel = label(
            "Nested UIKit content used by the view and layer tree demos.",
            font: .systemFont(ofSize: 14, weight: .regular),
            color: Palette.secondaryText
        )

        let stack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel, previewCardView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        section.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: section.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -18)
        ])

        return section
    }

    private func makeActionSection(title: String, rows: [[UIButton]]) -> UIView {
        let section = roundedPanel(backgroundColor: .white)
        var arranged: [UIView] = [
            label(title, font: .systemFont(ofSize: 19, weight: .semibold), color: Palette.ink)
        ]

        rows.forEach { buttons in
            let row = UIStackView(arrangedSubviews: buttons)
            row.axis = .horizontal
            row.spacing = 10
            row.distribution = .fillEqually
            arranged.append(row)
        }

        let stack = UIStackView(arrangedSubviews: arranged)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        section.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: section.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -18)
        ])

        return section
    }

    private func buildPreviewCard() {
        previewCardView.translatesAutoresizingMaskIntoConstraints = false
        previewCardView.backgroundColor = Palette.ink
        previewCardView.layer.cornerRadius = 22

        let avatar = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = Palette.yellow
        avatar.layer.cornerRadius = 24

        let nameLabel = label("Preview Node", font: .systemFont(ofSize: 18, weight: .semibold), color: .white)
        let subtitleLabel = label(
            "A nested card with rows, badges, and chart bars",
            font: .systemFont(ofSize: 13, weight: .regular),
            color: UIColor.white.withAlphaComponent(0.7)
        )

        let nameStack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 4

        let status = pill("LIVE")
        status.backgroundColor = Palette.green

        let header = UIStackView(arrangedSubviews: [avatar, nameStack, status])
        header.axis = .horizontal
        header.spacing = 12
        header.alignment = .center

        let metricRow = UIStackView(arrangedSubviews: [
            metricCard(title: "Roots", value: "3"),
            metricCard(title: "Depth", value: "5"),
            metricCard(title: "Mode", value: "Fold")
        ])
        metricRow.axis = .horizontal
        metricRow.spacing = 10
        metricRow.distribution = .fillEqually

        let chart = UIStackView(arrangedSubviews: [
            chartBar(height: 46, color: Palette.orange),
            chartBar(height: 72, color: Palette.blue),
            chartBar(height: 58, color: Palette.green),
            chartBar(height: 34, color: Palette.purple)
        ])
        chart.axis = .horizontal
        chart.alignment = .bottom
        chart.spacing = 10
        chart.distribution = .fillEqually

        let chartPanel = roundedPanel(backgroundColor: UIColor(red: 0.15, green: 0.18, blue: 0.26, alpha: 1.0))
        chartPanel.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [header, metricRow, chartPanel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        previewCardView.addSubview(stack)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalToConstant: 48),
            previewCardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 236),

            chart.topAnchor.constraint(equalTo: chartPanel.topAnchor, constant: 18),
            chart.leadingAnchor.constraint(equalTo: chartPanel.leadingAnchor, constant: 16),
            chart.trailingAnchor.constraint(equalTo: chartPanel.trailingAnchor, constant: -16),
            chart.bottomAnchor.constraint(equalTo: chartPanel.bottomAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: previewCardView.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: previewCardView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: previewCardView.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: previewCardView.bottomAnchor, constant: -18)
        ])
    }

    private func metricCard(title: String, value: String) -> UIView {
        let card = roundedPanel(backgroundColor: UIColor(red: 0.20, green: 0.24, blue: 0.33, alpha: 1.0))
        let titleLabel = label(title, font: .systemFont(ofSize: 12, weight: .medium), color: UIColor.white.withAlphaComponent(0.65))
        let valueLabel = label(value, font: .systemFont(ofSize: 18, weight: .bold), color: .white)

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        card.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])

        return card
    }

    private func chartBar(height: CGFloat, color: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = 9
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }

    private func roundedPanel(backgroundColor: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 18
        return view
    }

    private func pill(_ text: String) -> UILabel {
        let label = label(text, font: .systemFont(ofSize: 12, weight: .semibold), color: .white)
        label.textAlignment = .center
        label.backgroundColor = Palette.badge
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        (label as? InsetLabel)?.contentInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
        return label
    }

    private func label(_ text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = InsetLabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    private func actionButton(title: String, color: UIColor, action: Selector) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = color
        configuration.baseForegroundColor = .white
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 10, bottom: 13, trailing: 10)
        configuration.background.cornerRadius = 14
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .systemFont(ofSize: 15, weight: .semibold)
            return attributes
        }

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func showSampleTree() {
        let controller = VerticalTreeListController<DemoTreeNode>(style: .plain)
        controller.title = "Sample Forest"
        controller.rootNodes = DemoTreeNode.sampleForest()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func showPreviewViewTree() {
        let wrapper = NodeWrapper(obj: previewCardView).changeProperties { node in
            node.length = .index(180)
            node.isFold = node.currentDeep > 2
            if let view = node.obj {
                node.nodeDescription = "\(type(of: view)) frame: \(view.frame)"
            }
        }

        let controller = VerticalTreeListController(source: wrapper)
        controller.title = "Preview View"
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func showWindowViewTree() {
        guard let targetView = view.window ?? view else { return }
        let wrapper = NodeWrapper(obj: targetView).changeProperties { node in
            node.length = .index(200)
            node.isFold = node.currentDeep > 2
            if let view = node.obj {
                node.nodeDescription = "\(type(of: view)) subviews: \(view.subviews.count)"
            }
        }

        let controller = VerticalTreeListController(source: wrapper)
        controller.title = "Window View"
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func showPreviewLayerTree() {
        let wrapper = NodeWrapper(obj: previewCardView.layer).changeProperties { node in
            node.length = .index(180)
            node.isFold = node.currentDeep > 2
            if let layer = node.obj {
                node.nodeDescription = "\(type(of: layer)) frame: \(layer.frame)"
            }
        }

        let controller = VerticalTreeListController(source: wrapper)
        controller.title = "Preview Layer"
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func printSampleTree() {
        DemoTreeNode.sampleForest().forEach {
            print($0.subTreePrettyText(moreInfoIfHave: true))
        }
        showMessage(title: "Printed", message: "Sample tree text was printed to the Xcode console.")
    }

    @objc private func printPreviewTree() {
        print(previewCardView.treePrettyText(inDebug: true))
        showMessage(title: "Printed", message: "Preview view tree was printed to the Xcode console.")
    }

    @objc private func showAlert() {
        let controller = UIAlertController(
            title: "Presented Controller",
            message: "This adds another UIKit branch that can be inspected from Window View.",
            preferredStyle: .alert
        )
        controller.addAction(UIAlertAction(title: "Close", style: .cancel))
        controller.addAction(UIAlertAction(title: "Show Window Tree", style: .default) { [weak self] _ in
            self?.showWindowViewTree()
        })
        present(controller, animated: true)
    }

    private func showMessage(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default))
        present(controller, animated: true)
    }

    private func runLaunchScenarioIfNeeded() {
        let arguments = ProcessInfo.processInfo.arguments
        guard arguments.contains("-VerticalTreeDemoOpenSample") else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.showSampleTree()
        }
    }
}

private enum Palette {
    static let ink = UIColor(red: 0.10, green: 0.13, blue: 0.20, alpha: 1.0)
    static let secondaryText = UIColor(red: 0.35, green: 0.39, blue: 0.47, alpha: 1.0)
    static let badge = UIColor(red: 0.24, green: 0.29, blue: 0.39, alpha: 1.0)
    static let blue = UIColor(red: 0.17, green: 0.49, blue: 0.82, alpha: 1.0)
    static let green = UIColor(red: 0.15, green: 0.62, blue: 0.46, alpha: 1.0)
    static let orange = UIColor(red: 0.91, green: 0.43, blue: 0.26, alpha: 1.0)
    static let purple = UIColor(red: 0.45, green: 0.39, blue: 0.74, alpha: 1.0)
    static let red = UIColor(red: 0.78, green: 0.24, blue: 0.28, alpha: 1.0)
    static let gray = UIColor(red: 0.30, green: 0.35, blue: 0.43, alpha: 1.0)
    static let yellow = UIColor(red: 0.96, green: 0.76, blue: 0.25, alpha: 1.0)
}

private final class InsetLabel: UILabel {
    var contentInsets = UIEdgeInsets.zero

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }
}
