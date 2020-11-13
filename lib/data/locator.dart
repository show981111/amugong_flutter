import 'package:amugong/data/user_provider.dart';
import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/network/web_client.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerSingletonAsync<CachedSharedPreference>(() async {
    final cs = CachedSharedPreference();
    await cs.init();
    return cs;
  });

  locator.registerSingletonWithDependencies<WebClient>(() => WebClient(),
      dependsOn: [CachedSharedPreference]);
//
//  locator.registerSingletonWithDependencies<UserProvider>(() => UserProvider(from : "locator"),
//      dependsOn: [WebClient, CachedSharedPreference]);

  // locator.registerSingletonWithDependencies<AuthenticationService>(() => AuthenticationService(),
  //     dependsOn: [WebClient]);

  // locator.registerSingletonWithDependencies<HomeProvider>(() => HomeProvider(),
  //     dependsOn: [WebClient]);
}
