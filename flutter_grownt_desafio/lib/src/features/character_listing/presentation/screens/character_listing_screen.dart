import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/routes.dart';
import '../../domain/entities/character_filters.dart';
import '../cubit/character_listing_cubit.dart';
import '../cubit/filters_cubit.dart';
import '../widgets/custom_text_field.dart';

class CharacterListingScreen extends StatefulWidget {
  const CharacterListingScreen({super.key});

  @override
  State<CharacterListingScreen> createState() => _CharacterListingScreenState();
}

class _CharacterListingScreenState extends State<CharacterListingScreen> {
  late CharacterListingCubit characterListingCubit;
  late FiltersCubit filtersCubit;

  final scrollController = ScrollController();
  final searchController = TextEditingController();
  Timer? _debounce;

  bool isFavoriteFilterActive = false;

  @override
  void initState() {
    super.initState();
    filtersCubit = BlocProvider.of<FiltersCubit>(context);
    characterListingCubit = BlocProvider.of<CharacterListingCubit>(context);
    characterListingCubit.fetchCharacters(filtersCubit.state.filters);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          scrollController.offset != 0 &&
          !isFavoriteFilterActive &&
          !characterListingCubit.state.characterListing.hasReachedMax) {
        filtersCubit.updateFilters(
          filtersCubit.state.filters.copyWith(
            page: characterListingCubit.state.characterListing.nextPage,
          ),
        );
        characterListingCubit.fetchCharacters(filtersCubit.state.filters);
      }
    });

    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted && !isFavoriteFilterActive) {
        filtersCubit.updateFilters(
          filtersCubit.state.filters.copyWith(
            name: searchController.text,
            page: 1,
          ),
        );
        characterListingCubit.fetchCharacters(filtersCubit.state.filters);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: searchController,
                      hintText: 'Search Characters',
                      height: 40,
                      prefixIcon: const Icon(Icons.search),
                      enabled: !isFavoriteFilterActive,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFavoriteFilterActive = !isFavoriteFilterActive;
                      });

                      if (isFavoriteFilterActive) {
                        characterListingCubit.fetchFavoriteCharacters();
                        filtersCubit.updateFilters(
                          CharacterFilters(
                            page: 1,
                            name: '',
                            species: '',
                            status: '',
                            type: '',
                            gender: '',
                          ),
                        );
                        searchController.clear();
                      } else {
                        characterListingCubit.fetchCharacters(
                          filtersCubit.state.filters,
                        );
                      }
                    },
                    child: Icon(
                      isFavoriteFilterActive
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  BlocConsumer<CharacterListingCubit, CharacterListingState>(
                    listener: (context, state) {
                      if (state.status == CharacterListingStatus.error ||
                          state.status == CharacterListingStatus.initialError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.errorMessage ?? 'An error occurred',
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      switch (state.status) {
                        case CharacterListingStatus.error:
                        case CharacterListingStatus.loaded:
                          return state.characterListing.characters.isEmpty
                              ? const SliverFillRemaining(
                                  child: Center(
                                    child: Text('No characters found.'),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return index <
                                              state
                                                  .characterListing
                                                  .characters
                                                  .length
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  child: Card(
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pushNamed(
                                                            context,
                                                            RouteNames
                                                                .character,
                                                            arguments: index,
                                                          ),
                                                      child: ListTile(
                                                        leading: CachedNetworkImage(
                                                          imageUrl: state
                                                              .characterListing
                                                              .characters[index]
                                                              .image,
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                          errorWidget:
                                                              (
                                                                _,
                                                                _,
                                                                _,
                                                              ) => const Icon(
                                                                Icons.person,
                                                              ),
                                                        ),
                                                        title: Text(
                                                          state
                                                              .characterListing
                                                              .characters[index]
                                                              .name,
                                                        ),
                                                        subtitle: Text(
                                                          state
                                                              .characterListing
                                                              .characters[index]
                                                              .status,
                                                        ),
                                                        trailing: IconButton(
                                                          icon: Icon(
                                                            state
                                                                    .characterListing
                                                                    .characters[index]
                                                                    .isFavorite
                                                                ? Icons.favorite
                                                                : Icons
                                                                      .favorite_border,
                                                            size: 16,
                                                          ),
                                                          onPressed: () {
                                                            characterListingCubit
                                                                .toggleFavoriteStatus(
                                                                  state
                                                                      .characterListing
                                                                      .characters[index]
                                                                      .id,
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (index !=
                                                    state
                                                            .characterListing
                                                            .characters
                                                            .length -
                                                        1)
                                                  Divider(
                                                    indent:
                                                        MediaQuery.sizeOf(
                                                          context,
                                                        ).width *
                                                        0.08,
                                                    endIndent:
                                                        MediaQuery.sizeOf(
                                                          context,
                                                        ).width *
                                                        0.08,
                                                  ),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 48,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                    },
                                    childCount:
                                        state.characterListing.hasReachedMax
                                        ? state
                                              .characterListing
                                              .characters
                                              .length
                                        : state
                                                  .characterListing
                                                  .characters
                                                  .length +
                                              1,
                                  ),
                                );

                        case CharacterListingStatus.initialError:
                          return SliverFillRemaining(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 48, color: Colors.red),
                                Text(
                                  state.errorMessage ??
                                      'An error occurred while fetching characters.',
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (isFavoriteFilterActive) {
                                      characterListingCubit
                                          .fetchFavoriteCharacters();
                                    } else {
                                      characterListingCubit.fetchCharacters(
                                        filtersCubit.state.filters,
                                      );
                                    }
                                  },
                                  child: Text('Try again.'),
                                ),
                              ],
                            ),
                          );

                        default:
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
