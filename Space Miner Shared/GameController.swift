import SceneKit
import TSKit_Core


#if os(watchOS)
    import WatchKit
#endif

#if os(macOS)
    typealias SCNColor = NSColor
    typealias SCNImage = NSImage
#else
    typealias SCNColor = UIColor
    typealias SCNImage = UIImage
#endif

class GameController: NSObject, SCNSceneRendererDelegate {

    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    private var tileScale: CGFloat = 1
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene(named: "Art.scnassets/grid.scn")!
        
        super.init()
        
        sceneRenderer.delegate = self
        
        sceneRenderer.scene = scene
        
        scene.background.contents = [SCNImage(named: "right")!,
                                     SCNImage(named: "left")!,
                                     SCNImage(named: "top")!,
                                     SCNImage(named: "bottom")!,
                                     SCNImage(named: "front")!,
                                     SCNImage(named: "back")!
                                    ]
               
        
        scene.rootNode.addChildNode(GridNode(radius: 4))
    }
    
    
    func highlightNodes(atPoint point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        for result in hitResults {
            guard let hexagon = result.node as? HexagonNode,
                  let originalGeometry = hexagon.geometry as? HexagonGeometry,
                  let originalMaterial = originalGeometry.firstMaterial else { return }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            let highlightedGeometry = originalGeometry.copySelf()
            let highlightedMaterial = originalMaterial.copySelf()
            highlightedGeometry.firstMaterial = highlightedMaterial
            hexagon.geometry = highlightedGeometry
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                highlightedMaterial.emission.contents = SCNColor.black
                hexagon.position.z = 0
                
                SCNTransaction.completionBlock = {
                    hexagon.geometry = originalGeometry
                }

                SCNTransaction.commit()
            }
            
            highlightedMaterial.emission.contents = SCNColor.green
            hexagon.position.z = 0.01
            
            SCNTransaction.commit()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Called before each frame is rendered
    }

}


extension NSObject {
    
    func copySelf() -> Self {
        copy() as! Self
    }
}
