import 'package:flutter/material.dart';
import 'export_allthings.dart';
class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  int _page = 0;
  final _ctrl = PageController();

  static const _slides = [
    _Slide(
      headline: '50–40% OFF',
      sub: 'Now in (product)\nAll colours',
      cta: 'Shop Now',
      gradient: HomeColors.promoBannerGradient,
      icon: Icons.shopping_bag_rounded,
    ),
    _Slide(
      headline: 'New Arrivals',
      sub: "Summer '25\nFresh Collections",
      cta: 'Explore',
      gradient: LinearGradient(
        colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      icon: Icons.auto_awesome_rounded,
    ),
    _Slide(
      headline: 'Flash Sale',
      sub: 'Limited time\nUp to 70% off',
      cta: 'Grab Now',
      gradient: LinearGradient(
        colors: [Color(0xFFEF6C00), Color(0xFFFF9800)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      icon: Icons.bolt_rounded,
    ),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = HomeResponsive.of(context);

    return Column(
      children: [
        SizedBox(
          height: r.promoBannerHeight,
          child: PageView.builder(
            controller: _ctrl,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _SlideWidget(slide: _slides[i], r: r),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _page == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _page == i
                    ? HomeColors.primary
                    : HomeColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideWidget extends StatelessWidget {
  const _SlideWidget({required this.slide, required this.r});
  final _Slide slide;
  final HomeResponsive r;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.hPad),
      child: Container(
        decoration: BoxDecoration(
          gradient: slide.gradient,
          borderRadius: BorderRadius.circular(r.borderRadius),
        ),
        padding: EdgeInsets.all(r.isPhone ? 20 : 28),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slide.headline,
                    style: TextStyle(
                      color: HomeColors.white,
                      fontSize: r.isPhone ? 24 : 30,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slide.sub,
                    style: TextStyle(
                      color: HomeColors.white.withOpacity(0.88),
                      fontSize: r.captionFontSize,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: r.isPhone ? 14 : 18),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.isPhone ? 16 : 20,
                        vertical: r.isPhone ? 8 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: HomeColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            slide.cta,
                            style: TextStyle(
                              color: HomeColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: r.captionFontSize,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              color: HomeColors.primary, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: r.isPhone ? 80 : 110,
              height: r.isPhone ? 80 : 110,
              decoration: BoxDecoration(
                color: HomeColors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                slide.icon,
                color: HomeColors.white,
                size: r.isPhone ? 40 : 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final String headline;
  final String sub;
  final String cta;
  final Gradient gradient;
  final IconData icon;
  const _Slide({
    required this.headline,
    required this.sub,
    required this.cta,
    required this.gradient,
    required this.icon,
  });
}
