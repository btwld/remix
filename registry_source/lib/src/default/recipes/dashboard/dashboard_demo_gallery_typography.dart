import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../components/link.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class VanillaGalleryTypographyPage extends StatelessWidget {
  const VanillaGalleryTypographyPage({super.key});

  @override
  Widget build(BuildContext context) => VanillaGalleryPage(
    title: 'Typography',
    intro: 'Text, headings, code, keys, and links on one shared scale.',
    sections: [
      VanillaGallerySection(
        label: 'Text scale',
        description: 'The native scale from caption to display.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s1_5),
          children: [
            for (final (label, token) in const [
              ('12px', VanillaTokens.textXs),
              ('14px', VanillaTokens.textSm),
              ('16px', VanillaTokens.textBase),
              ('18px', VanillaTokens.textLg),
              ('20px', VanillaTokens.textXl),
              ('24px', VanillaTokens.text2xl),
              ('30px', VanillaTokens.text3xl),
            ])
              VanillaGalleryText('The quick brown fox · $label', token: token),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Weights',
        description: 'The complete native font-weight range.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s6)
              .runSpacing(VanillaTokens.s3),
          children: [
            for (final (label, weight) in const [
              ('Regular', FontWeight.w400),
              ('Medium', FontWeight.w500),
              ('Semibold', FontWeight.w600),
              ('Bold', FontWeight.w700),
            ])
              VanillaGalleryText(
                label,
                token: VanillaTokens.textLg,
                weight: weight,
              ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Heading level and size',
        description:
            'Semantic heading levels remain independent of visual scale.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s2),
          children: [
            Semantics(
              header: true,
              child: const VanillaGalleryHeading(
                'Level 1 heading at 30px',
                token: VanillaTokens.text3xl,
              ),
            ),
            Semantics(
              header: true,
              child: const VanillaGalleryHeading(
                'Level 2 heading at 20px',
                token: VanillaTokens.textXl,
              ),
            ),
            Semantics(
              header: true,
              child: const VanillaGalleryHeading(
                'Level 3 heading at 16px',
                token: VanillaTokens.textBase,
              ),
            ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Code',
        description: 'Inline code uses a distinct monospace surface.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s2),
          children: const [
            _Code('const x = 1;'),
            _Code('remix add dashboard_demo'),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Keyboard keys',
        description: 'Keyboard caps remain readable beside body copy.',
        child: WrapBox(
          style: WrapBoxStyler().spacing(VanillaTokens.s2),
          children: const [_Keycap('⌘'), _Keycap('K'), _Keycap('Enter')],
        ),
      ),
      VanillaGallerySection(
        label: 'Links',
        description: 'Interactive, disabled, and destination-bearing links.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s5)
              .runSpacing(VanillaTokens.s3),
          children: [
            VanillaLink(
              label: 'Interactive',
              onPressed: () =>
                  showVanillaGalleryToast(context, 'Link activated'),
            ),
            const VanillaLink(label: 'Disabled'),
            VanillaLink(
              label: 'Documentation',
              linkUrl: Uri.parse('https://docs.page/btwld/remix'),
              onPressed: () => showVanillaGalleryToast(
                context,
                'Navigation is the caller\'s',
              ),
            ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Accent and high contrast',
        description: 'Foreground and muted roles preserve useful contrast.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s5)
              .runSpacing(VanillaTokens.s3),
          children: const [
            VanillaGalleryText('Foreground'),
            VanillaGalleryText('Muted foreground', muted: true),
            VanillaGalleryHeading(
              'Strong heading',
              token: VanillaTokens.textBase,
            ),
          ],
        ),
      ),
      VanillaGallerySection(
        label: 'Wrapping and truncation',
        description: 'Long text demonstrates both wrapping strategies.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(VanillaTokens.s8)
              .runSpacing(VanillaTokens.s4),
          children: [
            Box(
              style: BoxStyler().width(260),
              child: const VanillaGalleryText(
                'Wrap keeps the complete sentence, across as many lines as it needs.',
              ),
            ),
            Box(
              style: BoxStyler().width(260),
              child: const VanillaGalleryText(
                'Truncate keeps exactly one line, across as many lines as it needs.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Code extends StatelessWidget {
  const _Code(this.value);
  final String value;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .color(VanillaTokens.muted())
        .borderRadius(.all(VanillaTokens.radiusSm()))
        .padding(
          .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1),
        ),
    child: StyledText(
      value,
      style: TextStyler()
          .style(VanillaTokens.textMono.mix())
          .color(VanillaTokens.foreground()),
    ),
  );
}

class _Keycap extends StatelessWidget {
  const _Keycap(this.value);
  final String value;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .color(VanillaTokens.background())
        .border(
          .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
        )
        .borderRadius(.all(VanillaTokens.radiusSm()))
        .padding(
          .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1),
        ),
    child: VanillaGalleryText(
      value,
      token: VanillaTokens.textXs,
      emphasized: true,
    ),
  );
}
