import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:remix/remix.dart';

import 'preview_helper.dart';

@Preview(name: 'Basic Accordion', size: Size(400, 300))
Widget previewBasicAccordion() {
  return createRemixPreview(
    const SizedBox(
      width: 350,
      child: RemixAccordion<String>(
        children: [
          RemixAccordionItem(
            title: 'What is Remix?',
            value: 'about',
            child: Text(
              'Remix is a modern, expressive design system built on top of Mix and Flutter.',
            ),
          ),
          RemixAccordionItem(
            title: 'How to use components?',
            value: 'usage',
            child: Text(
              'Simply import remix and use any component with built-in styling and theming.',
            ),
          ),
          RemixAccordionItem(
            title: 'Customization options',
            value: 'customization',
            child: Text(
              'All components support extensive customization through Mix styling system.',
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Accordion with Icons', size: Size(400, 300))
Widget previewAccordionWithIcons() {
  return createRemixPreview(
    const SizedBox(
      width: 350,
      child: RemixAccordion<String>(
        defaultTrailing: Icons.expand_more,
        children: [
          RemixAccordionItem(
            title: 'Account Settings',
            value: 'account',
            leading: Icons.person,
            child: Text(
              'Manage your account preferences, profile information, and security settings.',
            ),
          ),
          RemixAccordionItem(
            title: 'Notifications',
            value: 'notifications',
            leading: Icons.notifications,
            child: Text(
              'Configure how and when you want to receive notifications.',
            ),
          ),
          RemixAccordionItem(
            title: 'Privacy & Security',
            value: 'privacy',
            leading: Icons.security,
            child: Text(
              'Control your privacy settings and security preferences.',
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Pre-expanded Accordion', size: Size(400, 400))
Widget previewPreExpandedAccordion() {
  return createRemixPreview(
    const SizedBox(
      width: 350,
      child: RemixAccordion<String>(
        initialExpandedValues: ['faq1'],
        children: [
          RemixAccordionItem(
            title: 'Frequently Asked Question 1',
            value: 'faq1',
            child: Text(
              'This accordion item starts expanded by default. You can specify initial expanded values to show important content immediately.',
            ),
          ),
          RemixAccordionItem(
            title: 'Frequently Asked Question 2',
            value: 'faq2',
            child: Text(
              'This item starts collapsed and can be expanded by the user.',
            ),
          ),
          RemixAccordionItem(
            title: 'Frequently Asked Question 3',
            value: 'faq3',
            child: Text(
              'Multiple sections can be configured independently.',
            ),
          ),
        ],
      ),
    ),
  );
}

@Preview(name: 'Rich Content Accordion', size: Size(400, 400))
Widget previewRichContentAccordion() {
  return createRemixPreview(
    const SizedBox(
      width: 350,
      child: RemixAccordion<String>(
        children: [
          RemixAccordionItem(
            title: 'Basic Information',
            value: 'basic',
            leading: Icons.info,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: John Doe',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text('Email: john.doe@example.com'),
                SizedBox(height: 4),
                Text('Phone: +1 (555) 123-4567'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
