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
            StagesViewControllerProvider.init,
            ReloadDataViewControllerProvider.init,
            AddStageViewControllerProvider.init,
            HistoriesViewControllerProvider.init,
            HistoryViewControllerProvider.init,
            LineupViewControllerProvider.init
        ]
    }
}
