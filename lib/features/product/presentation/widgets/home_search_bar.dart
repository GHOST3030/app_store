import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/product_providers.dart';
import 'export_allthings.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit(String value) {
    ref.read(productNotifierProvider.notifier).search(value);
  }

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);

    return SizedBox(
      height: r.searchBarHeight,
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSubmit,
        style: TextStyle(fontSize: r.bodyFontSize, color: HomeColors.textDark),
        decoration: InputDecoration(
          filled: true,
          fillColor: HomeColors.bgGrey,
          hintText: 'Search any Product...',
          hintStyle: TextStyle(color: HomeColors.textMid, fontSize: r.bodyFontSize),
          prefixIcon: const Icon(Icons.search_rounded, color: HomeColors.textMid, size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    ref.read(productNotifierProvider.notifier).search('');
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close_rounded, color: HomeColors.textMid, size: 18),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.mic_none_rounded, color: HomeColors.primary, size: 20),
                onPressed: () {},
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(r.borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
