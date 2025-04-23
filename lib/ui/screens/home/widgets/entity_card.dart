import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/models/entity.dart';

class EntityCard extends StatelessWidget {
  final Entity entity;

  const EntityCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.20833,
      height: MediaQuery.of(context).size.height * 0.20709,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    blurRadius: 0.5,
                    spreadRadius: 1,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                color: Theme.of(context).colorScheme.primary,
                image: entity.image != null
                    ? DecorationImage(
                  image: NetworkImage("${dotenv.env['BASE_API_URL']}/media/${entity.image}/entities"),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              width: MediaQuery.of(context).size.width * 0.09,
              height: MediaQuery.of(context).size.height,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entity.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      entity.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
