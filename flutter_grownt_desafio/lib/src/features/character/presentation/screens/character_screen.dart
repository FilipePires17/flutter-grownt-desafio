import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/character_cubit.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key, this.id = 2});

  final int id;

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late CharacterCubit characterCubit;

  @override
  void initState() {
    super.initState();
    characterCubit = BlocProvider.of<CharacterCubit>(context);
    characterCubit.fetchCharacter(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    characterCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterCubit, CharacterState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state.character == null
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back),
                        ),
                        Text(state.character!.name),
                        CachedNetworkImage(imageUrl: state.character!.image),
                        Text('Status: ${state.character!.status}'),
                        Text('Species: ${state.character!.species}'),
                        Text('Gender: ${state.character!.gender}'),
                        Text('Origin: ${state.character!.origin}'),
                        Text('Location: ${state.character!.location}'),
                        Text('Episodes:'),
                        ...state.character!.episode.map((ep) => Text(ep)),
                        Text(
                          state.character!.isFavorite
                              ? 'This character is a favorite!'
                              : 'This character is not a favorite.',
                        ),
                        ElevatedButton(
                          onPressed: () {
                            characterCubit.toggleFavoriteStatus();
                          },
                          child: Icon(
                            state.character!.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
