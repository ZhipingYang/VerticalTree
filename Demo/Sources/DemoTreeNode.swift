import Foundation
import VerticalTree

final class DemoTreeNode: NSObject, VerticalTreeNode {

    weak var parent: DemoTreeNode?
    var childs: [DemoTreeNode]
    var indexPath: IndexPath
    var length: TreeNodeLength
    var isFold: Bool

    var info: Infomation { return self }
    var nodeTitle: String { return titleText }
    var nodeDescription: String? { return detailText }

    private let titleText: String
    private let detailText: String?

    init(
        _ title: String,
        detail: String? = nil,
        isFold: Bool = false,
        length: TreeNodeLength = .index(180),
        children: [DemoTreeNode] = []
    ) {
        self.titleText = title
        self.detailText = detail
        self.childs = []
        self.indexPath = IndexPath(index: 0)
        self.length = length
        self.isFold = isFold
        super.init()
        setChildren(children)
    }

    static func sampleForest() -> [DemoTreeNode] {
        let dataPipeline = DemoTreeNode(
            "Data Pipeline",
            detail: "A deterministic sample tree that shows nested structured data.",
            children: [
                DemoTreeNode(
                    "Ingestion",
                    detail: "Inputs collected before normalization.",
                    children: [
                        DemoTreeNode("REST API", detail: "Orders, accounts, inventory"),
                        DemoTreeNode("Webhook Queue", detail: "Retryable event stream"),
                        DemoTreeNode("CSV Import", detail: "Manual back-office upload")
                    ]
                ),
                DemoTreeNode(
                    "Transform",
                    detail: "Business rules grouped by processing stage.",
                    children: [
                        DemoTreeNode("Validate", detail: "Schema and required field checks"),
                        DemoTreeNode(
                            "Enrich",
                            detail: "Attach labels, owners, and score bands.",
                            isFold: true,
                            children: [
                                DemoTreeNode("Geo Lookup", detail: "Region metadata"),
                                DemoTreeNode("Risk Score", detail: "Rules + historical signals")
                            ]
                        ),
                        DemoTreeNode("Normalize", detail: "Canonical object shape")
                    ]
                ),
                DemoTreeNode(
                    "Delivery",
                    detail: "Final consumers.",
                    isFold: true,
                    children: [
                        DemoTreeNode("Dashboard", detail: "Visible to operators"),
                        DemoTreeNode("Warehouse", detail: "Long-term analytics storage"),
                        DemoTreeNode("Audit Log", detail: "Append-only compliance trail")
                    ]
                )
            ]
        )

        let organization = DemoTreeNode(
            "Organization",
            detail: "A compact org chart with mixed folded branches.",
            children: [
                DemoTreeNode(
                    "Product",
                    detail: "Roadmap and discovery.",
                    children: [
                        DemoTreeNode("Research", detail: "Interview synthesis"),
                        DemoTreeNode("Design", detail: "Interaction and visual language")
                    ]
                ),
                DemoTreeNode(
                    "Engineering",
                    detail: "Feature delivery teams.",
                    children: [
                        DemoTreeNode("iOS", detail: "UIKit demo and package integration"),
                        DemoTreeNode("Backend", detail: "Tree data APIs"),
                        DemoTreeNode("QA", detail: "Regression and edge cases")
                    ]
                ),
                DemoTreeNode("Support", detail: "Customer feedback loop")
            ]
        )

        let expression = DemoTreeNode(
            "Expression AST",
            detail: "A syntax tree style structure.",
            children: [
                DemoTreeNode(
                    "BinaryExpression +",
                    detail: "Root operator.",
                    children: [
                        DemoTreeNode(
                            "CallExpression sum()",
                            detail: "Function call subtree.",
                            children: [
                                DemoTreeNode("Identifier revenue"),
                                DemoTreeNode("Identifier refunds")
                            ]
                        ),
                        DemoTreeNode(
                            "BinaryExpression *",
                            detail: "Nested operator.",
                            children: [
                                DemoTreeNode("Identifier taxRate"),
                                DemoTreeNode("NumberLiteral 0.0825")
                            ]
                        )
                    ]
                )
            ]
        )

        let roots = [dataPipeline, organization, expression]
        roots.enumerated().forEach { $0.element.reindex(IndexPath(index: $0.offset)) }
        return roots
    }

    private func setChildren(_ children: [DemoTreeNode]) {
        childs = children
        children.enumerated().forEach { offset, child in
            child.parent = self
            child.reindex(indexPath.appending(offset))
        }
    }

    private func reindex(_ path: IndexPath) {
        indexPath = path
        childs.enumerated().forEach { offset, child in
            child.parent = self
            child.reindex(path.appending(offset))
        }
    }
}
