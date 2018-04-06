//
//  GameScene.swift
//  SnakeVsMath
//
//  Created by Alejandro on 05/04/18.
//  Copyright © 2018 AleyBrenda. All rights reserved.
//

import SpriteKit
import GameplayKit
struct CuerpoFisico {
    static let cabeza : UInt32 = 0x1 << 0
    static let operacion : UInt32 = 0x1 << 1
    static let cola : UInt32 = 0x1 << 2
    static let respuesta : UInt32 = 0x1 << 3
    static let respuestaCorrecta : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var cabeza = SKSpriteNode()
    private var operacionLabel = SKLabelNode()
    private var resupuesta = SKSpriteNode()
    private var textRespuesta = SKLabelNode()
    private var textMalaRes = SKLabelNode()
    private var cola1 = SKSpriteNode()
    private var cola = [SKSpriteNode()]
    private var numero = [Bool](repeating: false, count: 20)
    private var index = 0
    private var background = SKSpriteNode(imageNamed: "Orange_BG")
     var numeroColas = 0
     var numeroVidas = 1
    private var gana = SKSpriteNode()
    private var pierde = SKSpriteNode()
    private var respuestaCorrecta = SKSpriteNode()
    private var res = ""
    var numero1 = Int()
    var numero2 = Int()
    var animacionTime : Double = 10
    
    func crearCabeza()
    {
    
        cabeza = SKSpriteNode(imageNamed: "cabeza_snake")
        cabeza.position = CGPoint(x: 0, y: -200)
        cabeza.setScale(0.5)
        cabeza.zPosition = 2
        cabeza.physicsBody = SKPhysicsBody(rectangleOf: cabeza.size)
        cabeza.physicsBody?.categoryBitMask = CuerpoFisico.cabeza
        cabeza.physicsBody?.collisionBitMask = CuerpoFisico.respuesta | CuerpoFisico.respuestaCorrecta
       cabeza.physicsBody?.contactTestBitMask = CuerpoFisico.respuesta | CuerpoFisico.respuestaCorrecta
        cabeza.physicsBody?.isDynamic = true
        cabeza.physicsBody?.affectedByGravity = false
        self.addChild(cabeza)
    }
    func crearOperacion()
    {
        numero1 = GKRandomDistribution(lowestValue: 0, highestValue: 99).nextInt()
        numero2 = GKRandomDistribution(lowestValue: 0, highestValue: 99).nextInt()
        
        var string = "\(numero1) + \(numero2)"
   
        operacionLabel = SKLabelNode(text: string)
        operacionLabel.fontSize =  65
        operacionLabel.position = CGPoint(x: 0, y: 400)
        operacionLabel.fontName = "Arial-BoldMT"
        operacionLabel.physicsBody?.isDynamic = false
        operacionLabel.physicsBody?.affectedByGravity = false
        self.addChild(operacionLabel)
    }
    func crearCola()
    {
        
        cola1 = SKSpriteNode(imageNamed: "cuerpo_snake")
        
        switch numeroColas {
        case 15:
            cola1.position = CGPoint(x: 0, y:-700 )
            break
        case 0:
            cola1.position = CGPoint(x: cabeza.position.x, y:-280 )
            break
        case 1:
            cola1.position = CGPoint(x: 0, y:-310 )
            break
        case 2:
            cola1.position = CGPoint(x: 0, y:-340 )
            break
        case 3:
            cola1.position = CGPoint(x: 0, y:-370 )
            break
        case 4:
            cola1.position = CGPoint(x: 0, y:-400 )
        case 5:
            cola1.position = CGPoint(x: 0, y:-430 )
            break
        case 6:
            cola1.position = CGPoint(x: 0, y:-460 )
            break
        case 7:
            cola1.position = CGPoint(x: 0, y: -490 )
            break
        case 8:
            cola1.position = CGPoint(x: 0, y:-510 )
            break
        case 9:
            cola1.position = CGPoint(x: 0, y:-540 )
            break
        case 10:
            cola1.position = CGPoint(x: 0, y:-570 )
            break
        case 11:
            cola1.position = CGPoint(x: 0, y:-600 )
            break
        case 12:
            cola1.position = CGPoint(x: 0, y:-630 )
            break
        case 13:
            cola1.position = CGPoint(x: 0, y:-660 )
            break
        case 14:
            cola1.position = CGPoint(x: 0, y: -690)
            break
        default:
            break
        }
        cola1.zPosition = 1
        cola1.setScale(0.5)
        cola1.physicsBody?.affectedByGravity = false
        cola1.physicsBody?.isDynamic = false
        self.cola.append(cola1)
        numero[index] = true
        index = index + 1
        numeroColas = numeroColas + 1
    }
    func crearMensajeGanador()
    {
        gana = SKSpriteNode(imageNamed: "ganaste")
        gana.setScale(0.5)
        gana.position = CGPoint(x: 0, y: 0)
        gana.zPosition = -1
        addChild(gana)
    }
    func crearMensajePerdedor()
    {
        pierde = SKSpriteNode(imageNamed: "perdiste")
        pierde.setScale(0.5)
        pierde.position = CGPoint(x: 0, y: 0)
        pierde.zPosition = -1
        addChild(pierde)
    }
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -0.7)
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = -1
        addChild(background)
        crearCabeza()
        crearOperacion()
        for index in 1...15
        {
        crearCola()
        }

        let pregunta = SKAction.run({
            ()
            in
            self.operacionLabel.removeFromParent()
            self.crearOperacion()
        })
        let del = SKAction.wait(forDuration: 7)
        let spawn = SKAction.sequence([pregunta, del])
        let spawnForever = SKAction.repeatForever(spawn)
        self.run(spawnForever, withKey: "pregunta")
        
        let respuestaAction = SKAction.run({
            ()
            in self.crearResultNode()
        })
        let delay = SKAction.wait(forDuration: 7)
        let spawnDelay = SKAction.sequence([respuestaAction, delay])
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)
        self.run(spawnDelayForever, withKey: "respuesta")
        
        let respuestaCorrectaAction = SKAction.run({
            ()
            in self.crearResultCorrectaNode()
        })
        let delatC = SKAction.wait(forDuration: 7)
        let spawnDelayC = SKAction.sequence([respuestaCorrectaAction, delatC])
        let spawnDelayForeverC = SKAction.repeatForever(spawnDelayC)
        self.run(spawnDelayForeverC, withKey: "respuestaCorrecta")
        
      
    }
    func crearResultNode()
    {
        animacionTime = animacionTime - 0.5
        resupuesta = SKSpriteNode(imageNamed: "punto")
       
        resupuesta.setScale(0.5)
        resupuesta.physicsBody = SKPhysicsBody(rectangleOf: resupuesta.size)
        resupuesta.physicsBody?.categoryBitMask = CuerpoFisico.respuesta
        resupuesta.physicsBody?.collisionBitMask = CuerpoFisico.cabeza
        resupuesta.physicsBody?.contactTestBitMask = CuerpoFisico.cabeza
        resupuesta.physicsBody?.isDynamic = true
        let miRandomPosition = GKShuffledDistribution(lowestValue: -250, highestValue: 300)
        let posicionXRespuesta  = CGFloat(miRandomPosition.nextInt())
        resupuesta.physicsBody?.affectedByGravity = false
        resupuesta.position = CGPoint(x:posicionXRespuesta, y: 800)
        self.addChild(resupuesta)
      var sum = Int(arc4random_uniform(40)) - 20
        
        res = "\(numero1 + numero2 + sum)"
        print(res)
        textMalaRes = SKLabelNode(text: res)
        textMalaRes.fontSize =  45
        textMalaRes.position = CGPoint(x: resupuesta.position.x, y: resupuesta.position.y - 15)
        textMalaRes.fontName = "Arial-BoldMT"
        textMalaRes.zPosition = 4
        
        self.addChild(textMalaRes)
       
        
        var arrayDeAcciones = [SKAction]()
        
        arrayDeAcciones.append(SKAction.move(to: CGPoint(x:posicionXRespuesta, y: -(self.frame.size.height + 30)), duration: TimeInterval(animacionTime)))
        
        arrayDeAcciones.append(SKAction.removeFromParent())
        
        resupuesta.run(SKAction.sequence(arrayDeAcciones))
        textMalaRes.run(SKAction.sequence(arrayDeAcciones))
    }
    
    func crearResultCorrectaNode()
    {
        
        respuestaCorrecta = SKSpriteNode(imageNamed: "punto")
        respuestaCorrecta.shader = SKShader(fileNamed: "Green_BG")
        respuestaCorrecta.setScale(0.5)
        respuestaCorrecta.physicsBody = SKPhysicsBody(rectangleOf: respuestaCorrecta.size)
        respuestaCorrecta.physicsBody?.categoryBitMask = CuerpoFisico.respuestaCorrecta
        respuestaCorrecta.physicsBody?.collisionBitMask = CuerpoFisico.cabeza
        respuestaCorrecta.physicsBody?.contactTestBitMask = CuerpoFisico.cabeza
        respuestaCorrecta.physicsBody?.isDynamic = true
        let miRandomPosition = GKShuffledDistribution(lowestValue: -250, highestValue: 300)
        let posicionXRespuesta  = CGFloat(miRandomPosition.nextInt())
        respuestaCorrecta.physicsBody?.affectedByGravity = false
        respuestaCorrecta.position = CGPoint(x:posicionXRespuesta, y: 800)
       
        self.addChild(respuestaCorrecta)
        res = "\(numero1 + numero2)"
             print(res)
        textRespuesta = SKLabelNode(text: res)
        textRespuesta.fontSize =  45
        textRespuesta.position = CGPoint(x: respuestaCorrecta.position.x, y: respuestaCorrecta.position.y - 15)
        textRespuesta.zPosition = 4
        textRespuesta.fontName = "Arial-BoldMT"
        
        self.addChild(textRespuesta)
        
        var arrayDeAcciones = [SKAction]()
        
        arrayDeAcciones.append(SKAction.move(to: CGPoint(x:posicionXRespuesta, y: -(self.frame.size.height + 30)), duration: TimeInterval(animacionTime)))
        
        arrayDeAcciones.append(SKAction.removeFromParent())
        textRespuesta.run(SKAction.sequence(arrayDeAcciones))
        respuestaCorrecta.run(SKAction.sequence(arrayDeAcciones))
    }
    
    
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches{
//            let location = touch.location(in: self)
//            
//            cabeza.run(SKAction.moveTo(x: location.x, duration: 0.3))
//            var d = 0.1
//            for i in cola
//            {
//                 i.run(SKAction.moveTo(x: cabeza.position.x, duration: d))
//                d = d + 0.025
//            }
//           
//        }

        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            cabeza.run(SKAction.moveTo(x: location.x, duration: 0.25))
            var d = 0.2
            for i in cola
            {
             i.run(SKAction.moveTo(x: cabeza.position.x, duration: d))
                d = d + 0.025
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
 
    override func update(_ currentTime: TimeInterval) {
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
       
       
        if firstBody.categoryBitMask == CuerpoFisico.cabeza && secondBody.categoryBitMask == CuerpoFisico.respuesta ||
            firstBody.categoryBitMask == CuerpoFisico.respuesta && secondBody.categoryBitMask == CuerpoFisico.cabeza
        {
            if numeroVidas  > 1
            {
            if firstBody.categoryBitMask == CuerpoFisico.respuesta
            {
                
                resupuesta.removeFromParent()
                 textMalaRes.removeFromParent()
                respuestaCorrecta.removeFromParent()
                textRespuesta.removeFromParent()
                numeroVidas = numeroVidas - 1
                cola[numeroVidas].removeFromParent()
            }
            else if secondBody.categoryBitMask == CuerpoFisico.respuesta
            {
                respuestaCorrecta.removeFromParent()
                textRespuesta.removeFromParent()
                resupuesta.removeFromParent()
                textMalaRes.removeFromParent()
                numeroVidas = numeroVidas - 1
                cola[numeroVidas].removeFromParent()
            }
            }
            else
            {
                print("acabado")
                removeAllActions()
                removeAllChildren()
                crearMensajePerdedor()
            }
        }
            
        
        
       else if firstBody.categoryBitMask == CuerpoFisico.cabeza && secondBody.categoryBitMask == CuerpoFisico.respuestaCorrecta ||
            firstBody.categoryBitMask == CuerpoFisico.respuestaCorrecta && secondBody.categoryBitMask == CuerpoFisico.cabeza
        {
            
            if numeroVidas < 10
            {
            if firstBody.categoryBitMask == CuerpoFisico.respuestaCorrecta
            {
                resupuesta.removeFromParent()
                textMalaRes.removeFromParent()
                respuestaCorrecta.removeFromParent()
                textRespuesta.removeFromParent()
                textMalaRes.removeFromParent()
                self.addChild(cola[numeroVidas])
                numeroVidas = numeroVidas + 1
            }
            else if secondBody.categoryBitMask == CuerpoFisico.respuestaCorrecta
                {
                resupuesta.removeFromParent()
                textMalaRes.removeFromParent()
                respuestaCorrecta.removeFromParent()
                textRespuesta.removeFromParent()
                textMalaRes.removeFromParent()
                self.addChild(cola[numeroVidas])
                numeroVidas = numeroVidas + 1
                }
            }
            else
            {
                
                print("acabado")
                removeAllActions()
                removeAllChildren()
                crearMensajeGanador()
            }
            
        }
            
        }
        
    }

