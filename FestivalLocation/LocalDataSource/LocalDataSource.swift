import Foundation

protocol LocalDataSource {
}

class DefaultLocalDataSource: LocalDataSource {
    let localStorage: LocalStorage

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
}
