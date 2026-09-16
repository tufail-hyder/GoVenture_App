import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../models/blog_model.dart';
import '../services/blog_service.dart';
import '../widget/blog_card_horizontal.dart';
import '../../../core/constants/app_sizes.dart';
import 'blog_detail_screen.dart';

class AllBlogsScreen extends StatefulWidget {
  const AllBlogsScreen({super.key});

  @override
  State<AllBlogsScreen> createState() => _AllBlogsScreenState();
}

class _AllBlogsScreenState extends State<AllBlogsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late final Future<List<BlogModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = BlogService.getLatestBlogs(limit: 100);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('From the Blog')),
        body: FutureBuilder<List<BlogModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final all = snapshot.data ?? [];
            final query = _searchQuery.trim().toLowerCase();
            final blogs = all.where((b) => query.isEmpty || b.title.toLowerCase().contains(query)).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: const InputDecoration(
                      hintText: 'Search blogs...',
                      prefixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: blogs.isEmpty
                      ? const Center(child: Text('No blogs found'))
                      : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSizes.sm,
                      crossAxisSpacing: AppSizes.sm,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: blogs.length,
                    itemBuilder: (_, i) => BlogCardHorizontal(
                      blog: blogs[i],
                      onTap: () => Get.to(() => BlogDetailScreen(blog: blogs[i])),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}