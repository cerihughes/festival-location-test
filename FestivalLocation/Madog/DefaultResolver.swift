import Madog

class DefaultResolver: Resolver {
    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            DefaultServices.init(context:)
        ]
    }

    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Navigation>] {
        [
            AuthorisationViewControllerProvider.init,
            AreasMapViewControllerProvider.init,
            AreasExportViewControllerProvider.init,
            AddAreaViewControllerProvider.init,
            AreasViewControllerProvider.init,
            VisitsViewControllerProvider.init,
            FestivalDataViewControllerProvider.init
        ]
    }
}
