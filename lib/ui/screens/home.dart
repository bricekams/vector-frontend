  import 'package:flutter/material.dart';
  import 'package:frontend/models/entity.dart';
  import 'package:frontend/ui/widgets/entity_card.dart';
  import 'package:frontend/ui/widgets/home_app_bar.dart';
  import 'package:frontend/utils/extensions/build_context.dart';

  List<Entity> entities = [
    Entity(
      id: "5",
      name: "Sandy Boston",
      description: "Commandant en chef de la BAS UK",
      type: EntityType.publicPerson,
      country: "Royaume-Uni",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Maurice KAMTO",
      description: "President du Mouvement pour la renaissance du Cameroun",
      type: EntityType.publicPerson,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Mouvement pour la renaissance du Cameroun (MRC)",
      description: "Parti politique du Cameroun, fondé le 22 juin 2012, par changement de dénomination de Mouvement populaire républicain. Son dirigeant est Maurice Kamto.",
      type: EntityType.politicalParty,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Sandy Boston",
      description: "Commandant en chef de la BAS UK",
      type: EntityType.publicPerson,
      country: "Royaume-Uni",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Maurice KAMTO",
      description: "President du Mouvement pour la renaissance du Cameroun",
      type: EntityType.publicPerson,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Mouvement pour la renaissance du Cameroun (MRC)",
      description: "Parti politique du Cameroun, fondé le 22 juin 2012, par changement de dénomination de Mouvement populaire républicain. Son dirigeant est Maurice Kamto.",
      type: EntityType.politicalParty,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Sandy Boston",
      description: "Commandant en chef de la BAS UK",
      type: EntityType.publicPerson,
      country: "Royaume-Uni",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Maurice KAMTO",
      description: "President du Mouvement pour la renaissance du Cameroun",
      type: EntityType.publicPerson,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Mouvement pour la renaissance du Cameroun (MRC)",
      description: "Parti politique du Cameroun, fondé le 22 juin 2012, par changement de dénomination de Mouvement populaire républicain. Son dirigeant est Maurice Kamto.",
      type: EntityType.politicalParty,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Sandy Boston",
      description: "Commandant en chef de la BAS UK",
      type: EntityType.publicPerson,
      country: "Royaume-Uni",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Maurice KAMTO",
      description: "President du Mouvement pour la renaissance du Cameroun",
      type: EntityType.publicPerson,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Mouvement pour la renaissance du Cameroun (MRC)",
      description: "Parti politique du Cameroun, fondé le 22 juin 2012, par changement de dénomination de Mouvement populaire républicain. Son dirigeant est Maurice Kamto.",
      type: EntityType.politicalParty,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Sandy Boston",
      description: "Commandant en chef de la BAS UK",
      type: EntityType.publicPerson,
      country: "Royaume-Uni",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Maurice KAMTO",
      description: "President du Mouvement pour la renaissance du Cameroun",
      type: EntityType.publicPerson,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Mouvement pour la renaissance du Cameroun (MRC)",
      description: "Parti politique du Cameroun, fondé le 22 juin 2012, par changement de dénomination de Mouvement populaire républicain. Son dirigeant est Maurice Kamto.",
      type: EntityType.politicalParty,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Sandy Boston",
      description: "Commandant en chef de la BAS UK",
      type: EntityType.publicPerson,
      country: "Royaume-Uni",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Maurice KAMTO",
      description: "President du Mouvement pour la renaissance du Cameroun",
      type: EntityType.publicPerson,
      country: "Cameroun",
      image: "",
    ),
    Entity(
      id: "5",
      name: "Mouvement pour la renaissance du Cameroun (MRC)",
      description: "Parti politique du Cameroun, fondé le 22 juin 2012, par changement de dénomination de Mouvement populaire républicain. Son dirigeant est Maurice Kamto.",
      type: EntityType.politicalParty,
      country: "Cameroun",
      image: "",
    ),
  ];

  class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: HomeAppBar(),
          body: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.t('entities'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 30, vertical: 5)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      icon: Icon(Icons.add),
                      label: Text(
                        context.t('create'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: SingleChildScrollView(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 10,
                            runSpacing: 10,
                            children: entities.map((item) {
                              return EntityCard(entity: item);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 580,
                      height: MediaQuery.of(context).size.height * 0.80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                )
,
              ],
            ),
          ),
      );
    }
  }
