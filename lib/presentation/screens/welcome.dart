part of 'screens.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late InterstitialAd _interstitialAd;
  _loadIntel() async {
    if (!showAds) {
      return false;
    }
    InterstitialAd.load(
        adUnitId: kInterstitial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint("Ads is Loaded");
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    context.read<FavoritesCubit>().initialData();
    context.read<WatchingCubit>().initialData();
    _loadIntel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        width: getSize(context).width,
        height: getSize(context).height,
        decoration: kDecorBackground,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: [
            const AppBarWelcome(),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<LiveCatyBloc, LiveCatyState>(
                        builder: (context, state) {
                          final size = state is LiveCatySuccess
                              ? state.categories.length
                              : '';

                          return CardWelcomeTv(
                            title: "LIVE TV",
                            autoFocus: true,
                            subTitle: "$size Channels",
                            icon: kIconLive,
                            onTap: () {
                              Get.toNamed(screenLiveCategories)!
                                  .then((value) async {
                                debugPrint("show interstitial");
                                _interstitialAd.show();
                                await _loadIntel();
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: BlocBuilder<MovieCatyBloc, MovieCatyState>(
                        builder: (context, state) {
                          final size = state is MovieCatySuccess
                              ? state.categories.length
                              : '';

                          return CardWelcomeTv(
                            title: "Movies",
                            subTitle: "$size Channels",
                            icon: kIconMovies,
                            onTap: () {
                              Get.toNamed(screenMovieCategories)!
                                  .then((value) async {
                                await _interstitialAd.show();
                                await _loadIntel();
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: BlocBuilder<SeriesCatyBloc, SeriesCatyState>(
                        builder: (context, state) {
                          final size = state is SeriesCatySuccess
                              ? state.categories.length
                              : '';

                          return CardWelcomeTv(
                            title: "Series",
                            subTitle: "$size Channels",
                            icon: kIconSeries,
                            onTap: () {
                              Get.toNamed(screenSeriesCategories)!
                                  .then((value) async {
                                await _interstitialAd.show();
                                await _loadIntel();
                              });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 2.w),
                    SizedBox(
                      width: 20.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CardWelcomeSetting(
                            title: 'Catch up',
                            icon: FontAwesomeIcons.rotate,
                            onTap: () {
                              Get.toNamed(screenCatchUp);
                            },
                          ),
                          CardWelcomeSetting(
                            title: 'Favourites',
                            icon: FontAwesomeIcons.heart,
                            onTap: () {
                              Get.toNamed(screenFavourite);
                            },
                          ),
                          CardWelcomeSetting(
                            title: 'Settings',
                            icon: FontAwesomeIcons.gear,
                            onTap: () {
                              Get.toNamed(screenSettings);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By using this application, you agree to the',
                  style: Get.textTheme.titleSmall!.copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await launchUrlString(kPrivacy);
                  },
                  child: Text(
                    ' Terms of Services.',
                    style: Get.textTheme.titleSmall!.copyWith(
                      fontSize: 12.sp,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            AdmobWidget.getBanner(),
          ],
        ),
      ),
    );
  }
}
