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
            LineupViewControllerProvider.init,
            StagesViewControllerProvider.init,
            AddStageViewControllerProvider.init,
            HistoriesViewControllerProvider.init,
            HistoryViewControllerProvider.init,
            SettingsViewControllerProvider.init,
            ReloadDataViewControllerProvider.init
        ]
    }
}
