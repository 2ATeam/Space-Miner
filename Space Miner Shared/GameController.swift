import SceneKit
import SpriteKit

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
    
    private var tiles: SKTileMapNode!
    
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
            // get its material
            guard let material = result.node.geometry?.firstMaterial else {
                return
            }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = SCNColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = SCNColor.red
            
            SCNTransaction.commit()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Called before each frame is rendered
    }

}
