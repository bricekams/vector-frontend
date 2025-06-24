import 'package:frontend/models/entity.dart';
import 'package:frontend/res/translations.dart';
import 'package:frontend/utils/extensions/string.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:frontend/utils/helpers.dart';

extension ContextExtension on pw.Context {
  String t(String key) {
    return translations['@$key']!["fr"]!;
  }
}

Future<pw.Document> printEntity(Entity entity) async {
  Uint8List imageBytes = Uint8List(0);
  if (entity.image != null) {
    try {
      final url = getImageUrl(entity.image!, "entities");
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'ngrok-skip-browser-warning': 'true'},
        ),
      );
      imageBytes = response.data as Uint8List;
    } catch (e) {
      imageBytes = Uint8List(0);
    }
  }

  pw.Document doc = pw.Document();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              children: [
                pw.Container(
                  width: 80,
                  height: 80,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child:
                      imageBytes.isNotEmpty
                          ? pw.Image(
                            pw.MemoryImage(imageBytes),
                            fit: pw.BoxFit.cover,
                          )
                          : pw.Icon(
                            pw.IconData(0xe3f3), // Icons.person
                            size: 40,
                            color: PdfColors.grey600,
                          ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        entity.name,
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.blue100,
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Text(
                          context.t(entity.type.name),
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Date and Time Section
            pw.Container(
              padding: pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                children: [
                  pw.Icon(
                    pw.IconData(0xe878), // Icons.schedule
                    size: 16,
                    color: PdfColors.grey700,
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(
                    '${context.t('generatedOn')} ${_formatDateTime(DateTime.now(), context)}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Basic Information Section
            _buildSection(
              title: context.t('basicInformation'),
              children: [
                _buildInfoRow(context.t('name'), entity.name),
                _buildInfoRow(
                  context.t('category'),
                  context.t(entity.type.name),
                ),
                if (entity.gender != null)
                  _buildInfoRow(
                    context.t('gender'),
                    context.t(entity.gender!.name),
                  ),
                if (entity.religion != null)
                  _buildInfoRow(
                    context.t('religion'),
                    context.t(entity.religion!.name),
                  ),
                if (entity.region != null)
                  _buildInfoRow(
                    context.t('region'),
                    context.t(entity.region!.name),
                  ),
                if (entity.pseudos?.isNotEmpty == true)
                  _buildInfoRow(
                    context.t('pseudos'),
                    entity.pseudos!.where((e) => e.isNotEmpty).join(', '),
                  ),
                if (entity.birthDate != null)
                  _buildInfoRow(
                    context.t('birthDate'),
                    entity.birthDate!.toIso8601String().substring(0, 10),
                  ),
                if (entity.lastKnownLocation?.isNotEmpty == true)
                  _buildInfoRow(
                    context.t('lastKnownLocation'),
                    entity.lastKnownLocation!,
                  ),
                _buildInfoRow(context.t('description'), entity.description),
              ],
            ),
            pw.SizedBox(height: 20),

            _buildSection(
              title: context.t('contactInformation'),
              children: [
                if (entity.phone_1 != null)
                  _buildInfoRow('Phone (1)', '+${entity.phone_1}'),
                if (entity.phone_2 != null)
                  _buildInfoRow('Phone (2)', '+${entity.phone_2}'),
                if (entity.email_1?.isNotEmpty == true)
                  _buildInfoRow('Email (1)', entity.email_1!),
                if (entity.email_2?.isNotEmpty == true)
                  _buildInfoRow('Email (2)', entity.email_2!),
                if (entity.website?.isNotEmpty == true)
                  _buildInfoRow(context.t('website'), entity.website!),
              ],
            ),
            pw.SizedBox(height: 20),

            // Social Media Section
            _buildSection(
              title: context.t('socialMedia'),
              children: [
                if (entity.linkedin?.isNotEmpty == true)
                  _buildInfoRow('LinkedIn', entity.linkedin!),
                if (entity.twitter?.isNotEmpty == true)
                  _buildInfoRow('X (Twitter)', entity.twitter!),
                if (entity.instagram?.isNotEmpty == true)
                  _buildInfoRow('Instagram', entity.instagram!),
                if (entity.youtube?.isNotEmpty == true)
                  _buildInfoRow('YouTube', entity.youtube!),
                if (entity.facebook_1?.isNotEmpty == true)
                  _buildInfoRow('Facebook (1)', entity.facebook_1!),
                if (entity.facebook_2?.isNotEmpty == true)
                  _buildInfoRow('Facebook (2)', entity.facebook_2!),
              ],
            ),
            pw.SizedBox(height: 20),

            // Statistics Section
            _buildSection(
              title: context.t('statistics'),
              children: [
                _buildInfoRow(
                  context.t('uploads'),
                  entity.uploadsCount.toString(),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return doc;
}

pw.Widget _buildSection({
  required String title,
  required List<pw.Widget> children,
}) {
  return pw.Container(
    padding: pw.EdgeInsets.all(16),
    decoration: pw.BoxDecoration(
      color: PdfColors.grey100,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

pw.Widget _buildInfoRow(String label, String value) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.normal,
            color: PdfColors.black,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
          ),
        ),
      ],
    ),
  );
}

String _formatDateTime(DateTime dateTime, pw.Context context) {
  // Format: "January 15, 2024 at 14:30:25"
  final months = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  final month = months[dateTime.month - 1];
  final day = dateTime.day;
  final year = dateTime.year;
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final second = dateTime.second.toString().padLeft(2, '0');

  return '${context.t(month).capitalize()} $day, $year at $hour:$minute:$second';
}
