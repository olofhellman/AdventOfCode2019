//
//  Tree.swift
//  AOC2019D6
//
//  Created by Olof Hellman on 12/6/19.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation

struct NodeInfo {
   let name:String
}

class TreeNode {
   let name:String
   var parent:TreeNode?
   var children:[TreeNode]

   init(name:String, parent:TreeNode) {
        self.name = name
        self.parent = parent
        self.children = []
    }
    
    func add(child:TreeNode) {
        children.append(child)
    }
    
    func countChildren() -> Int {
       return children.reduce(0, {$0 + 1 + $1.countChildren()} )
    }
 
    func listOfSupernodeNames() -> [String] {
          guard let parent = self.parent else {
              return []
          }
          return [parent.name] + parent.listOfSupernodeNames()
    }

     func has(subnode:TreeNode) -> Bool {
          let listOfSupernodes = subnode.listOfSupernodeNames()
          return listOfSupernodes.contains(self.name)
     }
     
     func countJumpsTo(supernode:TreeNode) -> Int {
         guard let myParent = parent else {
             print ("no orbitee")
             return -1
         }
         if (supernode.name == myParent.name) {
             return 1
         } else {
             return 1 + myParent.countJumpsTo(supernode:supernode)
         }
     }

}

class Tree {
   var root:TreeNode?
   var nodeDict:[String:TreeNode]

   init() {
       self.root = nil
       self.nodeDict = [:]
   }
   
   func insert(info:NodeInfo,  under parentNode:TreeNode) -> TreeNode? {
       guard nodeDict[info.name] == nil else {
          print ("node \(info.name) already exists")
          return nil
       }
       let newNode = TreeNode(name:info.name, parent:parentNode)
       nodeDict[info.name] = newNode
       return newNode
   }
 
   func countJumps(from start:String, to dest:String) -> Int {
       var jumps = 0
       guard let startNode = nodeDict[start] else
       {
           print ("cant find start")
           return -1
       }
       guard let destNode = nodeDict[dest] else
       {
           print ("cant find dest")
           return -1
       }
       guard var candidateNode = startNode.parent else {
            print ("no parent")
            return -1
       }

       while (!candidateNode.has(subnode:destNode)) {
           jumps = jumps + 1
           guard let nextNodeUp = candidateNode.parent  else {
              print ("no parent case B")
              return -1
           }
           candidateNode = nextNodeUp
       }
       return jumps + destNode.countJumpsTo(supernode:candidateNode) - 1
   }
}
