import SceneKit

protocol AnyDebuggableNode {
    
    func addDebugInfo()
}

extension AnyDebuggableNode where Self: SCNNode {
    
    func addChildrenDebugInfo() {
        childNodes
            .compactMap { $0 as? AnyDebuggableNode }
            .forEach { $0.addDebugInfo() }
    }
    
    func addDebugInfo() {
        addChildrenDebugInfo()
    }
}

extension SCNScene: AnyDebuggableNode {
    
    func addDebugInfo() {
        (rootNode as? AnyDebuggableNode)?.addDebugInfo()
    }
}
