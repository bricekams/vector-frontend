import 'package:flutter/material.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/ui/screens/home/widgets/app_bar.dart';
import 'package:frontend/ui/screens/home/widgets/create_button.dart';
import 'package:frontend/ui/screens/home/widgets/create_entity_widget.dart';
import 'package:frontend/ui/screens/home/widgets/dropdown.dart';
import 'package:frontend/ui/screens/home/widgets/seach_bar.dart';
import 'package:frontend/ui/screens/home/widgets/side_container.dart';
import 'package:frontend/ui/screens/home/widgets/entity_card.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:provider/provider.dart';

import '../../../providers/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

List<Entity> entities = [];

enum HomeSideState { create, edit, view }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showBox = false;
  String? selectedEntityType;
  HomeSideState? selectedSideState = HomeSideState.create;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.02604,
          right: MediaQuery.of(context).size.width * 0.02604,
          top: MediaQuery.of(context).size.height * 0.03241,
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.86,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.t('entities'),
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HomeDropDown(
                                items:
                                    EntityType.values
                                        .map((e) => context.t(e.name))
                                        .toList(),
                                borderColor: Theme.of(context).colorScheme.onPrimary,
                                nullPlaceholder: context.t('allCategories'),
                              ),
                              const SizedBox(width: 20),
                              HomeSearchBar(),
                              if (selectedSideState != HomeSideState.create)
                                const SizedBox(width: 20),
                              if (selectedSideState != HomeSideState.create)
                                CreateEntityButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedSideState = HomeSideState.create;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildHomeBody(),
                  ],
                ),
              ),
            ),
            _buildSideContainer(),
          ],
        ),
      ),
    );
  }

  _onCloseSideContainer() {
    setState(() {
      selectedSideState = null;
    });
  }

  _buildHomeBody() {
    switch (context.watch<HomeProvider>().state) {
      case HomeProviderState.loading:
        return Expanded(
          child: Center(
            child: LoadingAnimationWidget.hexagonDots(
              color: Theme.of(context).colorScheme.primary,
              size: 100,
            ),
          ),
        );
      case HomeProviderState.loaded:
        return Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  entities.map((item) {
                    return EntityCard(entity: item);
                  }).toList(),
            ),
          ),
        );
      case HomeProviderState.error:
        return Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_outlined, size: 100, color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 20),
                Text(
                  context.t('wentWrong'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                   
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
                    ),
                    child: Center(
                      child: Text(
                        context.t('retry'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
    }
  }

  _buildSideContainer() {
    switch (selectedSideState) {
      case HomeSideState.create:
        return HomeSideContainer(
          onClose: _onCloseSideContainer,
          title: context.t('create'),
          body: CreateEntityWidget(),
        );
      case HomeSideState.edit:
        return HomeSideContainer(
          onClose: _onCloseSideContainer,
          title: context.t('edit'),
        );
      case HomeSideState.view:
        return HomeSideContainer(
          onClose: _onCloseSideContainer,
          title: context.t('view'),
        );
      default:
        return Container();
    }
  }
}
