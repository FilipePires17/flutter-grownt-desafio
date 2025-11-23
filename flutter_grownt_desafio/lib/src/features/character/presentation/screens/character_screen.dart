import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/favorite_icon.dart';
import '../../../character_listing/presentation/cubit/character_listing_cubit.dart';
import '../../domain/entities/character.dart';
import '../widgets/character_status_bar.dart';
import '../widgets/info_row.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
          color: AppColors.white,
        ),
        title: Text(character.name, style: TextStyle(color: AppColors.white)),
        centerTitle: true,
        actions: [
          BlocBuilder<CharacterListingCubit, CharacterListingState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  characterListingCubit.toggleFavoriteStatus(character.id);
                },
                icon: FavoriteIcon(isFavorite: character.isFavorite),
              );
            },
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.almostBlack,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: character.image,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        CharacterStatusBar(
                          characterStatusEnum: character.status,
                        ),
                      ],
                    ),
                    InfoRow(title: 'Species: ', info: character.species),
                    InfoRow(title: 'Gender: ', info: character.gender),
                    if (character.type != '')
                      InfoRow(title: 'Type: ', info: character.type),
                    InfoRow(title: 'Origin: ', info: character.origin),
                    InfoRow(title: 'Location: ', info: character.location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
