import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../components/link.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_gallery_scaffold.dart';

class PlaygroundGalleryTypographyPage extends StatelessWidget {
  const PlaygroundGalleryTypographyPage({super.key});

  @override
  Widget build(BuildContext context) => PlaygroundGalleryPage(
    title: 'Typography',
    intro: 'Text, headings, code, keys, and links on one shared scale.',
    sections: [
      PlaygroundGallerySection(
        label: 'Text scale',
        description: 'The native scale from caption to display.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s1_5),
          children: [
            for (final (label, token) in const [
              ('12px', PlaygroundTokens.textXs),
              ('14px', PlaygroundTokens.textSm),
              ('16px', PlaygroundTokens.textBase),
              ('18px', PlaygroundTokens.textLg),
              ('20px', PlaygroundTokens.textXl),
              ('24px', PlaygroundTokens.text2xl),
              ('30px', PlaygroundTokens.text3xl),
            ])
              PlaygroundGalleryText(
                'The quick brown fox · $label',
                token: token,
              ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Weights',
        description: 'The complete native font-weight range.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s6)
              .runSpacing(PlaygroundTokens.s3),
          children: [
            for (final (label, weight) in const [
              ('Regular', FontWeight.w400),
              ('Medium', FontWeight.w500),
              ('Semibold', FontWeight.w600),
              ('Bold', FontWeight.w700),
            ])
              PlaygroundGalleryText(
                label,
                token: PlaygroundTokens.textLg,
                weight: weight,
              ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Heading level and size',
        description:
            'Semantic heading levels remain independent of visual scale.',
        child: ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s2),
          children: [
            Semantics(
              header: true,
              child: const PlaygroundGalleryHeading(
                'Level 1 heading at 30px',
                token: PlaygroundTokens.text3xl,
              ),
            ),
            Semantics(
              header: true,
              child: const PlaygroundGalleryHeading(
                'Level 2 heading at 20px',
                token: PlaygroundTokens.textXl,
              ),
            ),
            Semantics(
              header: true,
              child: const PlaygroundGalleryHeading(
                'Level 3 heading at 16px',
                token: PlaygroundTokens.textBase,
              ),
            ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Code',
        description: 'Inline code uses a distinct monospace surface.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s3)
              .runSpacing(PlaygroundTokens.s2),
          children: const [
            _Code('const x = 1;'),
            _Code('remix add dashboard_demo'),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Keyboard keys',
        description: 'Keyboard caps remain readable beside body copy.',
        child: WrapBox(
          style: WrapBoxStyler().spacing(PlaygroundTokens.s2),
          children: const [_Keycap('⌘'), _Keycap('K'), _Keycap('Enter')],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Links',
        description: 'Interactive, disabled, and destination-bearing links.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s5)
              .runSpacing(PlaygroundTokens.s3),
          children: [
            PlaygroundLink(
              label: 'Interactive',
              onPressed: () =>
                  showPlaygroundGalleryToast(context, 'Link activated'),
            ),
            const PlaygroundLink(label: 'Disabled'),
            PlaygroundLink(
              label: 'Documentation',
              linkUrl: Uri.parse('https://docs.page/btwld/remix'),
              onPressed: () => showPlaygroundGalleryToast(
                context,
                'Navigation is the caller\'s',
              ),
            ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Accent and high contrast',
        description: 'Foreground and muted roles preserve useful contrast.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s5)
              .runSpacing(PlaygroundTokens.s3),
          children: const [
            PlaygroundGalleryText('Foreground'),
            PlaygroundGalleryText('Muted foreground', muted: true),
            PlaygroundGalleryHeading(
              'Strong heading',
              token: PlaygroundTokens.textBase,
            ),
          ],
        ),
      ),
      PlaygroundGallerySection(
        label: 'Wrapping and truncation',
        description: 'Long text demonstrates both wrapping strategies.',
        child: WrapBox(
          style: WrapBoxStyler()
              .spacing(PlaygroundTokens.s8)
              .runSpacing(PlaygroundTokens.s4),
          children: [
            Box(
              style: BoxStyler().width(260),
              child: const PlaygroundGalleryText(
                'Wrap keeps the complete sentence, across as many lines as it needs.',
              ),
            ),
            Box(
              style: BoxStyler().width(260),
              child: const PlaygroundGalleryText(
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
        .color(PlaygroundTokens.muted())
        .borderRadius(.all(PlaygroundTokens.radiusSm()))
        .padding(
          .symmetric(
            horizontal: PlaygroundTokens.s2,
            vertical: PlaygroundTokens.s1,
          ),
        ),
    child: StyledText(
      value,
      style: TextStyler()
          .style(PlaygroundTokens.textMono.mix())
          .color(PlaygroundTokens.foreground()),
    ),
  );
}

class _Keycap extends StatelessWidget {
  const _Keycap(this.value);
  final String value;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .color(PlaygroundTokens.background())
        .border(
          .color(
            PlaygroundTokens.border(),
          ).width(PlaygroundTokens.strokeHairline),
        )
        .borderRadius(.all(PlaygroundTokens.radiusSm()))
        .padding(
          .symmetric(
            horizontal: PlaygroundTokens.s2,
            vertical: PlaygroundTokens.s1,
          ),
        ),
    child: PlaygroundGalleryText(
      value,
      token: PlaygroundTokens.textXs,
      emphasized: true,
    ),
  );
}
