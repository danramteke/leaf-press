import Foundation
import LeafKit

protocol Renderable {
  var source: FileLocation { get }
  var target: FileLocation { get }
  var leafData: LeafData { get }
}
