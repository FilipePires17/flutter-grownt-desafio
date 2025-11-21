import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../character_listing/presentation/cubit/character_listing_cubit.dart';
import '../../domain/entities/character.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key, required this.index});

  final int index;

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late CharacterListingCubit characterListingCubit;
  late Character character;

  @override
  void initState() {
    super.initState();
    characterListingCubit = BlocProvider.of<CharacterListingCubit>(context);
    character =
        characterListingCubit.state.characterListing.characters[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back),
              ),
              Text(character.name),
              CachedNetworkImage(imageUrl: character.image),
              Text('Status: ${character.status}'),
              Text('Species: ${character.species}'),
              Text('Gender: ${character.gender}'),
              Text('Origin: ${character.origin}'),
              Text('Location: ${character.location}'),
              Text('Episodes:'),
              ...character.episode.map((ep) => Text(ep)),
              BlocBuilder<CharacterListingCubit, CharacterListingState>(
                builder: (context, state) {
                  return Text(
                    state.characterListing.characters[widget.index].isFavorite
                        ? 'This character is a favorite!'
                        : 'This character is not a favorite.',
                  );
                },
              ),
              BlocBuilder<CharacterListingCubit, CharacterListingState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      characterListingCubit.toggleFavoriteStatus(character.id);
                    },
                    child: Icon(
                      state.characterListing.characters[widget.index].isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
