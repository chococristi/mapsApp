/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation
import SceneKit

class Molecules {
    
    class func methaneMolecule() -> SCNNode {
        var methaneMolecule = SCNNode()
        
        // 1 Carbon
        let carbonNode1 = nodeWithAtom(atom: Atoms.carbonAtom(), molecule: methaneMolecule, position: SCNVector3Make(0, 0, 0))
        
        // 4 Hydrogen
        let hydrogenNode1 = nodeWithAtom(atom: Atoms.hydrogenAtom(), molecule: methaneMolecule, position: SCNVector3Make(-4, 0, 0))
        let hydrogenNode2 = nodeWithAtom(atom: Atoms.hydrogenAtom(), molecule: methaneMolecule, position: SCNVector3Make(+4, 0, 0))
        let hydrogenNode3 = nodeWithAtom(atom: Atoms.hydrogenAtom(), molecule: methaneMolecule, position: SCNVector3Make(0, -4, 0))
        let hydrogenNode4 = nodeWithAtom(atom: Atoms.hydrogenAtom(), molecule: methaneMolecule, position: SCNVector3Make(0, +4, 0))
        
        methaneMolecule.addChildNode(carbonNode1)
        methaneMolecule.addChildNode(hydrogenNode1)
        methaneMolecule.addChildNode(hydrogenNode2)
        methaneMolecule.addChildNode(hydrogenNode3)
        methaneMolecule.addChildNode(hydrogenNode4)
        
        return methaneMolecule
    }
    
    class func ethanolMolecule() -> SCNNode {
        var ethanolMolecule = SCNNode()
        return ethanolMolecule
    }
    
    class func ptfeMolecule() -> SCNNode {
        var ptfeMolecule = SCNNode()
        return ptfeMolecule
    }
    
    class func coladaObject() -> SCNNode {
        
        let nodeName = "cherub"
       guard let modelScene = SCNScene(named:
        "art.scnassets/cherub/cherub.dae") else {
            return SCNNode()
        }
        guard let node = modelScene.rootNode.childNode(withName: nodeName, recursively: true) else {
            return SCNNode()
        }
        return node
    }
    
    class func nodeWithAtom(atom: SCNGeometry, molecule: SCNNode, position: SCNVector3) -> SCNNode {
        let node = SCNNode(geometry: atom)
        node.position = position
        molecule.addChildNode(node)
        return node
    }
}
