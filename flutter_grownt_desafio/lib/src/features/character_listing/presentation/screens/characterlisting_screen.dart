import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/character_listing_cubit.dart';

class CharacterListingScreen extends StatefulWidget {
  const CharacterListingScreen({super.key});

  @override
  State<CharacterListingScreen> createState() => _CharacterListingScreenState();
}

class _CharacterListingScreenState extends State<CharacterListingScreen> {
  late CharacterListingCubit characterListingCubit;

  final scrollController = ScrollController();
  final searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    characterListingCubit = BlocProvider.of<CharacterListingCubit>(context);
    characterListingCubit.fetchCharacters();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          scrollController.offset != 0) {
        characterListingCubit.fetchCharacters();
      }
    });

    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      // TODO: Implement search functionality
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
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        BlocBuilder<CharacterListingCubit, CharacterListingState>(
          builder: (context, state) {
            switch (state.status) {
              case CharacterListingStatus.loaded:
                return state.characterListing!.characters.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text('No characters found.')),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return index <
                                    state.characterListing!.characters.length
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Card(
                                          child: ListTile(
                                            leading: Image.network(
                                              state
                                                  .characterListing!
                                                  .characters[index]
                                                  .image,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text(
                                              state
                                                  .characterListing!
                                                  .characters[index]
                                                  .name,
                                            ),
                                            subtitle: Text(
                                              state
                                                  .characterListing!
                                                  .characters[index]
                                                  .status,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (index !=
                                          state
                                                  .characterListing!
                                                  .characters
                                                  .length -
                                              1)
                                        Divider(
                                          indent:
                                              MediaQuery.sizeOf(context).width *
                                              0.08,
                                          endIndent:
                                              MediaQuery.sizeOf(context).width *
                                              0.08,
                                        ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 48,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                          },
                          childCount:
                              state.characterListing?.hasReachedMax ?? false
                              ? state.characterListing!.characters.length
                              : state.characterListing!.characters.length + 1,
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
    );
  }
}
