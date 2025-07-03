import 'package:flutter/material.dart';
import 'package:frontend/api/entity.dart';
import 'package:frontend/config/routes.dart';
import 'package:frontend/models/entity.dart';
import 'package:frontend/providers/home.dart';
import 'package:frontend/utils/extensions/build_context.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'delete_entity_dialog.dart';

class SummaryEntityWidget extends StatefulWidget {
  const SummaryEntityWidget({super.key});

  @override
  State<SummaryEntityWidget> createState() => _SummaryEntityWidgetState();
}

class _SummaryEntityWidgetState extends State<SummaryEntityWidget> {
  bool deleting = false;
  bool downloading = false;

  @override
  Widget build(BuildContext context) {
    final selectedEntity = context.watch<HomeProvider>().selectedEntity;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.77,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(selectedEntity!),
            const SizedBox(height: 20),

            _buildSection(
              title: context.t('basicInformation'),
              icon: Icons.info_outline,
              children: [
                _buildInfoRow(context.t('name'), selectedEntity.name),
                _buildInfoRow(
                  context.t('category'),
                  context.t(selectedEntity.type.name),
                ),
                if (selectedEntity.gender != null)
                  _buildInfoRow(
                    context.t('gender'),
                    context.t(selectedEntity.gender!.name),
                  ),
                if (selectedEntity.religion != null)
                  _buildInfoRow(
                    context.t('religion'),
                    context.t(selectedEntity.religion!.name),
                  ),
                if (selectedEntity.region != null)
                  _buildInfoRow(
                    context.t('region'),
                    context.t(selectedEntity.region!.name),
                  ),
                if (selectedEntity.pseudos?.isNotEmpty == true)
                  _buildInfoRow(
                    context.t('pseudos'),
                    selectedEntity.pseudos!
                        .where((e) => e.isNotEmpty)
                        .join(', '),
                  ),
                if (selectedEntity.birthDate != null)
                  _buildInfoRow(
                    context.t('birthDate'),
                    selectedEntity.birthDate!.toIso8601String().substring(
                      0,
                      10,
                    ),
                  ),
                if (selectedEntity.lastKnownLocation?.isNotEmpty == true)
                  _buildInfoRow(
                    context.t('location'),
                    selectedEntity.lastKnownLocation!,
                  ),
                _buildInfoRow(
                  context.t('description'),
                  selectedEntity.description,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              title: context.t('contactInformation'),
              icon: Icons.contact_phone,
              children: [
                if (selectedEntity.phone_1 != null)
                  _buildInfoRow(
                    selectedEntity.phone_2 != null
                        ? 'Phone (1)'
                        : context.t('phoneNumber'),
                    '+${selectedEntity.phone_1}',
                  ),
                if (selectedEntity.phone_2 != null)
                  _buildInfoRow('Phone (2)', '+${selectedEntity.phone_2}'),
                if (selectedEntity.email_1?.isNotEmpty == true)
                  _buildInfoRow('Email (1)', selectedEntity.email_1!),
                if (selectedEntity.email_2?.isNotEmpty == true)
                  _buildInfoRow('Email (2)', selectedEntity.email_2!),
                if (selectedEntity.website?.isNotEmpty == true)
                  _buildInfoRow(context.t('website'), selectedEntity.website!),
              ],
            ),

            const SizedBox(height: 16),

            // Social Media Section
            _buildSection(
              title: context.t('socialMedia'),
              icon: Icons.share,
              children: [
                if (selectedEntity.linkedin?.isNotEmpty == true)
                  _buildInfoRow('LinkedIn', selectedEntity.linkedin!),
                if (selectedEntity.twitter?.isNotEmpty == true)
                  _buildInfoRow('X (Twitter)', selectedEntity.twitter!),
                if (selectedEntity.instagram?.isNotEmpty == true)
                  _buildInfoRow('Instagram', selectedEntity.instagram!),
                if (selectedEntity.youtube?.isNotEmpty == true)
                  _buildInfoRow('YouTube', selectedEntity.youtube!),
                if (selectedEntity.facebook_1?.isNotEmpty == true)
                  _buildInfoRow('Facebook (1)', selectedEntity.facebook_1!),
                if (selectedEntity.facebook_2?.isNotEmpty == true)
                  _buildInfoRow('Facebook (2)', selectedEntity.facebook_2!),
              ],
            ),

            const SizedBox(height: 16),

            // Statistics Section
            _buildSection(
              title: context.t('statistics'),
              icon: Icons.analytics_outlined,
              children: [
                _buildInfoRow(
                  context.t('uploads'),
                  selectedEntity.uploadsCount.toString(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(selectedEntity),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Entity entity) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.10416,
          height: MediaQuery.of(context).size.height * 0.20709,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.inversePrimary.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(
                getImageUrl(entity.image!, "entities"),
                headers: {'ngrok-skip-browser-warning': 'true'},
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  entity.type.name.replaceAll('_', ' ').toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Entity entity) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.edit,
          foreground: Theme.of(context).colorScheme.primary,
          onTap: () {
            context.read<HomeProvider>().setSelectedSideState(
              HomeSideState.edit,
            );
            if (!context.read<HomeProvider>().showSideBox) {
              context.read<HomeProvider>().setShowSideBox(true);
            }
          },
          color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPrimaryButton(
            text: context.t('discuss'),
            onTap: () {
              context.push(AppRoutes.chat, extra: entity);
            },
          ),
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.delete,
          foreground: Colors.white,
          onTap: () async {
            bool confirm = await showDialog(
              context: context,
              builder: (context) {
                return DeleteEntityDialog(entity: entity);
              },
            );
            if (!confirm) return;
            setState(() => deleting = true);
            EntityApi.delete(entity.id)
                .then((value) {
                  if (!context.mounted) return;
                  setState(() => deleting = false);
                  context.read<HomeProvider>().setShowSideBox(false);
                  context.read<HomeProvider>().removeEntity(entity);
                  notify(
                    context,
                    NotificationType.success,
                    context.t('entityDeleted'),
                  );
                })
                .onError((err, trace) {
                  if (!context.mounted) return;
                  setState(() => deleting = false);
                  notify(
                    context,
                    NotificationType.error,
                    context.t('failedEntityDeletion'),
                  );
                });
          },
          color: Colors.red,
          isLoading: deleting,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    Color? foreground,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foreground ?? color,
                    ),
                  )
                  : Icon(icon, color: foreground ?? color, size: 20),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
