import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/constants/app_colors.dart';
import '../services/pdf_service.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _isLoading = true;
  bool _isDownloading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    if (widget.pdfUrl.trim().isEmpty) {
      setState(() {
        _error = 'No itinerary PDF is available for this trip yet.';
        _isLoading = false;
      });
      return;
    }

    try {
      final fileName = '${widget.title.replaceAll(' ', '_')}_itinerary.pdf';
      final path = await PdfService.downloadAndCache(widget.pdfUrl, fileName);

      // ---- Diagnostic: confirm the downloaded file is actually a PDF ----
      // A real itinerary PDF should be many KB at least. If this prints a
      // tiny size (a few hundred bytes) or the header isn't "%PDF", the
      // "download" succeeded but what got saved is an error page (HTML/XML
      // from an auth-gated Storage URL, a 404 page, etc.), not a real PDF —
      // that's exactly the "loads fine, shows nothing" symptom.
      final file = File(path);
      final exists = await file.exists();
      final length = exists ? await file.length() : -1;
      String header = '';
      if (exists && length > 0) {
        final bytes = await file.openRead(0, length < 4 ? length : 4).first;
        header = String.fromCharCodes(bytes);
      }
      debugPrint(
        'PDF file check -> exists: $exists, size: $length bytes, header: "$header" (should start with %PDF)',
      );

      if (!exists || length == 0) {
        setState(() {
          _error = 'The downloaded file is empty. Please try again.';
          _isLoading = false;
        });
        return;
      }
      if (!header.startsWith('%PDF')) {
        setState(() {
          _error = 'This link did not return a valid PDF file.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _localPath = path;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('PDF load error: $e');
      setState(() {
        _error = 'Could not load PDF. Please check your connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPdf() async {
    if (widget.pdfUrl.trim().isEmpty || _isDownloading) return;

    setState(() => _isDownloading = true);
    try {
      final fileName = '${widget.title.replaceAll(' ', '_')}_itinerary.pdf';
      final path = await PdfService.downloadToDevice(widget.pdfUrl, fileName);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to: $path')),
      );
    } catch (e) {
      debugPrint('PDF download error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} — Itinerary'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        actions: [
          if (!_isLoading && _error == null)
            IconButton(
              icon: _isDownloading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.download_rounded),
              onPressed: _isDownloading ? null : _downloadPdf,
              tooltip: 'Download PDF',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textSecondaryLight),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
            ],
          ),
        ),
      )
          : SfPdfViewer.file(
        File(_localPath!),
        canShowScrollHead: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (details) {
          debugPrint('SfPdfViewer failed to load: ${details.description}');
          if (mounted) {
            setState(() {
              _error = 'This PDF could not be displayed: ${details.description}';
            });
          }
        },
      ),
    );
  }
}