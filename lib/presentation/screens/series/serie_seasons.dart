part of '../screens.dart';

class SerieSeasons extends StatefulWidget {
  const SerieSeasons({super.key, required this.serieDetails});
  final SerieDetails serieDetails;

  @override
  State<SerieSeasons> createState() => _SerieSeasonsState();
}

class _SerieSeasonsState extends State<SerieSeasons> {
  late SerieDetails serieDetails;
  int selectedSeason = 0;
  int selectedEpisode = 0;

  List<String> seasons = [];
  @override
  void initState() {
    serieDetails = widget.serieDetails;
    super.initState();

    if (serieDetails.episodes != null && serieDetails.episodes!.isNotEmpty) {
      serieDetails.episodes!.forEach((k, v) {
        seasons.add(k);
      });

      if (serieDetails.episodes != null && serieDetails.episodes!.isNotEmpty) {
        // Get the first season (key) from the map
        String firstSeason = serieDetails.episodes!.keys.first;
        // Set selectedSeason to the list of episodes for the first season
        selectedSeason = int.parse(firstSeason);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("EPISOD: ${serieDetails.episodes}");

    return Scaffold(
      body: Ink(
        decoration: kDecorBackground,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              final userAuth = state.user;
              return Stack(
                children: [
                  CardMovieImagesBackground(
                    listImages: serieDetails.info!.backdropPath ?? [],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 10, right: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100.w,
                          width: 22.w,
                          child: Center(
                            child: ListView.builder(
                              itemCount: seasons.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (_, i) {
                                return CardSeasonItem(
                                  isSelected: int.tryParse(seasons[i]) ==
                                      selectedSeason,
                                  number: seasons[i],
                                  onTap: () {
                                    setState(() {
                                      selectedSeason = int.parse(seasons[i]);
                                    });
                                  },
                                  onFocused: (val) {},
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: serieDetails
                                .episodes!["${selectedSeason}"]!.length,
                            itemBuilder: (_, i) {
                              final model = serieDetails
                                  .episodes!["${selectedSeason}"]![i];

                              return CardEpisodeItem(
                                isSelected: selectedEpisode == i,
                                index: i + 1,
                                episode: model,
                                onTap: () {
                                  setState(() {
                                    selectedEpisode = i;
                                  });
                                  final link =
                                      "${userAuth.serverInfo!.serverUrl}/series/${userAuth.userInfo!.username}/${userAuth.userInfo!.password}/${model!.id}.${model.containerExtension}";

                                  debugPrint("Link: $link");
                                  Get.to(() => FullVideoScreen(
                                            link: link,
                                            title: model.title ?? "",
                                          ))!
                                      .then((slider) {
                                    debugPrint("DATA: $slider");
                                    if (slider != null) {
                                      var modell = WatchingModel(
                                        sliderValue: slider[0],
                                        durationStrm: slider[1],
                                        stream: link,
                                        title: model.title ?? "",
                                        image: model.info!.movieImage ??
                                            widget.serieDetails.info!.cover ??
                                            "",
                                        streamId: model.id.toString(),
                                      );
                                      context
                                          .read<WatchingCubit>()
                                          .addSerie(modell);
                                    }
                                  });
                                },
                                onFocused: (val) {
                                  setState(() {
                                    selectedEpisode = i;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppBarSeries(
                    top: 3.h,
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
