import NIO

extension EventLoopFuture {
  @inlinable
  public static func multiWait<T, U, V>(_ a: EventLoopFuture<T>, _ b: EventLoopFuture<U>, _ c: EventLoopFuture<V>) -> EventLoopFuture<(T, U, V)> {
    return a.and(b).and(c).map { (arg0) -> (T, U, V) in
      let ((t, u), v) = arg0
      return (t, u, v)
    }
  }
}
