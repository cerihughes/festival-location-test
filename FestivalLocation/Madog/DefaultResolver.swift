import Madog

class DefaultResolver: Resolver {
    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            DefaultServices.init(context:)
        ]
    }

    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Navigation>] {
        [
            AreasViewControllerProvider.init
        ]
    }
}
