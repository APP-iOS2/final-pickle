//
//  Publisher.swift
//  Pickle
//
//  Created by 박형환 on 11/15/23.
//

import Foundation
import Combine

extension Publisher {
    
    func sinkToResult<T: AnyObject>(with object: T,
                                    _ result: @escaping (T, Result<Output, Failure>) -> Void) -> AnyCancellable {
        sink(receiveCompletion: { [weak object] completion in
            guard let object = object else { return }
            switch completion {
            case let .failure(error):
                result(object, .failure(error))
            default: break
            }
        }, receiveValue: { [weak object] value in
            guard let object = object else { return }
            result(object, .success(value))
        })
    }
    
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}
