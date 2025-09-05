import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Real World Examples',
  type: RemixButton,
)
Widget buildButtonRealWorldExamples(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Real World Button Usage Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Form Integration
            _buildSection(
              'Form Integration',
              [
                _FormExample(),
              ],
            ),

            // Loading States
            _buildSection(
              'Async Operations & Loading States',
              [
                _LoadingStatesExample(),
              ],
            ),

            // Confirmation Flows
            _buildSection(
              'Confirmation & Destructive Actions',
              [
                _ConfirmationFlowExample(),
              ],
            ),

            // Navigation & Actions
            _buildSection(
              'Navigation & Action Patterns',
              [
                _NavigationExample(),
              ],
            ),

            // Accessibility Demo
            _buildSection(
              'Accessibility & Keyboard Navigation',
              [
                _AccessibilityExample(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}

class _FormExample extends StatefulWidget {
  @override
  State<_FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<_FormExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _agreedToTerms;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registration Form Example',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Email is required' : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Password is required' : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _agreedToTerms,
              onChanged: (value) =>
                  setState(() => _agreedToTerms = value ?? false),
              title: const Text('I agree to the Terms and Conditions'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                RemixButton(
                  label: _isSubmitting ? 'Submitting...' : 'Submit',
                  icon: _isSubmitting ? Icons.hourglass_empty : Icons.send,
                  style: RemixButtonStyles.solid,
                  loading: _isSubmitting,
                  enabled: _isFormValid && !_isSubmitting,
                  onPressed: _submitForm,
                ),
                const SizedBox(width: 12),
                RemixButton(
                  label: 'Reset',
                  icon: Icons.refresh,
                  style: RemixButtonStyles.outline,
                  enabled: !_isSubmitting,
                  onPressed: () {
                    _formKey.currentState?.reset();
                    _emailController.clear();
                    _passwordController.clear();
                    setState(() => _agreedToTerms = false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingStatesExample extends StatefulWidget {
  @override
  State<_LoadingStatesExample> createState() => _LoadingStatesExampleState();
}

class _LoadingStatesExampleState extends State<_LoadingStatesExample> {
  bool _downloadLoading = false;
  bool _uploadLoading = false;
  bool _syncLoading = false;

  Future<void> _simulateOperation(
      String operation, Function(bool) setLoading) async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 3));
    setLoading(false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$operation completed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        RemixButton(
          label: _downloadLoading ? 'Downloading...' : 'Download',
          icon: _downloadLoading ? Icons.download : Icons.download_rounded,
          style: RemixButtonStyles.solid,
          loading: _downloadLoading,
          onPressed: _downloadLoading
              ? null
              : () => _simulateOperation(
                    'Download',
                    (loading) => setState(() => _downloadLoading = loading),
                  ),
        ),
        RemixButton(
          label: _uploadLoading ? 'Uploading...' : 'Upload',
          icon: _uploadLoading ? Icons.upload : Icons.upload_rounded,
          style: RemixButtonStyles.solid,
          loading: _uploadLoading,
          onPressed: _uploadLoading
              ? null
              : () => _simulateOperation(
                    'Upload',
                    (loading) => setState(() => _uploadLoading = loading),
                  ),
        ),
        RemixButton(
          label: _syncLoading ? 'Syncing...' : 'Sync',
          icon: _syncLoading ? Icons.sync : Icons.sync_rounded,
          style: RemixButtonStyles.solid,
          loading: _syncLoading,
          onPressed: _syncLoading
              ? null
              : () => _simulateOperation(
                    'Sync',
                    (loading) => setState(() => _syncLoading = loading),
                  ),
        ),
      ],
    );
  }
}

class _ConfirmationFlowExample extends StatefulWidget {
  @override
  State<_ConfirmationFlowExample> createState() =>
      _ConfirmationFlowExampleState();
}

class _ConfirmationFlowExampleState extends State<_ConfirmationFlowExample> {
  bool _showDeleteConfirmation = false;
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_showDeleteConfirmation) ...[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              RemixButton(
                label: 'Save Changes',
                icon: Icons.save,
                style: RemixButtonStyles.solid,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved!')),
                  );
                },
              ),
              RemixButton(
                label: 'Delete Item',
                icon: Icons.delete,
                style: RemixButtonStyles.outline,
                onPressed: () => setState(() => _showDeleteConfirmation = true),
              ),
              RemixButton(
                label: 'Archive',
                icon: Icons.archive,
                style: RemixButtonStyles.outline,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item archived!')),
                  );
                },
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Confirm Deletion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                    'Are you sure you want to delete this item? This action cannot be undone.'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    RemixButton(
                      label: _isDeleting ? 'Deleting...' : 'Yes, Delete',
                      icon: _isDeleting
                          ? Icons.hourglass_empty
                          : Icons.delete_forever,
                      style: RemixButtonStyles.outline,
                      loading: _isDeleting,
                      onPressed: _isDeleting
                          ? null
                          : () async {
                              final messenger = ScaffoldMessenger.of(context);
                              setState(() => _isDeleting = true);
                              await Future.delayed(const Duration(seconds: 2));
                              if (mounted) {
                                setState(() {
                                  _isDeleting = false;
                                  _showDeleteConfirmation = false;
                                });
                                messenger.showSnackBar(
                                  const SnackBar(
                                      content: Text('Item deleted!')),
                                );
                              }
                            },
                    ),
                    const SizedBox(width: 12),
                    RemixButton(
                      label: 'Cancel',
                      icon: Icons.cancel,
                      style: RemixButtonStyles.outline,
                      enabled: !_isDeleting,
                      onPressed: () =>
                          setState(() => _showDeleteConfirmation = false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _NavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        RemixButton(
          label: 'Go Back',
          icon: Icons.arrow_back,
          style: RemixButtonStyles.outline,
          onPressed: () {
            final navigator = Navigator.of(context);
            final messenger = ScaffoldMessenger.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No previous page to go back to')),
              );
            }
          },
        ),
        RemixButton(
          label: 'Next Step',
          icon: Icons.arrow_forward,
          style: RemixButtonStyles.solid,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Moving to next step...')),
            );
          },
        ),
        RemixButton(
          label: 'Open Menu',
          icon: Icons.menu,
          style: RemixButtonStyles.outline,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        RemixButton(
          label: 'Show More Options',
          icon: Icons.more_vert,
          style: RemixButtonStyles.outline,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: const Text('Copy Link'),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.report),
                      title: const Text('Report'),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AccessibilityExample extends StatefulWidget {
  @override
  State<_AccessibilityExample> createState() => _AccessibilityExampleState();
}

class _AccessibilityExampleState extends State<_AccessibilityExample> {
  final int _focusedButtonIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.accessibility,
                      color: Colors.blue.shade700, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Accessibility Features:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Tab navigation between buttons\n'
                '• Space/Enter key activation\n'
                '• Screen reader support with semantic labels\n'
                '• Focus indicators\n'
                '• Proper button roles and states',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Try navigating with Tab key and activating with Space/Enter:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            RemixButton(
              label: 'First Button',
              icon: Icons.looks_one,
              style: RemixButtonStyles.solid,
              semanticLabel: 'First button for accessibility demo',
              semanticHint: 'Activate to perform first action',
              autofocus: true,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('First button activated!')),
                );
              },
            ),
            RemixButton(
              label: 'Second Button',
              icon: Icons.looks_two,
              style: RemixButtonStyles.outline,
              semanticLabel: 'Second button for accessibility demo',
              semanticHint: 'Activate to perform second action',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Second button activated!')),
                );
              },
            ),
            RemixButton(
              label: 'Third Button',
              icon: Icons.looks_3,
              style: RemixButtonStyles.outline,
              semanticLabel: 'Third button for accessibility demo',
              semanticHint: 'Activate to perform third action',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Third button activated!')),
                );
              },
            ),
            RemixButton(
              label: 'Disabled Button',
              icon: Icons.block,
              style: RemixButtonStyles.outline,
              enabled: false,
              semanticLabel: 'Disabled button example',
              semanticHint: 'This button is disabled and cannot be activated',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_focusedButtonIndex >= 0)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: Text(
              'Currently focused: Button ${_focusedButtonIndex + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
