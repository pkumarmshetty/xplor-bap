import 'dart:developer';
import 'dart:io';

void main() {
  // Define the path to the pre-commit hook
  final hooksDir = '${Directory.current.path}/.git/hooks';
  final preCommitFilePath = '$hooksDir/pre-commit';

  // Ensure the hooks directory exists
  if (!Directory(hooksDir).existsSync()) {
    log('Error: .git/hooks directory does not exist. Make sure you are running this script from the root of your Git repository.');
    return;
  }

  // Define the content of the pre-commit hook
  const preCommitContent = '''
#!/bin/bash

echo "Running pre-commit hook..."

# Run Flutter analyze for static analysis
flutter analyze
analyze_status=\$?
echo "Flutter analyze status: \$analyze_status"

# Run Dart format to ensure code formatting
dart format --set-exit-if-changed .
format_status=\$?
echo "Dart format status: \$format_status"

# If any of the commands fail, exit with a non-zero status
if [ \$analyze_status -ne 0 ] || [ \$format_status -ne 0 ]; then
 echo "Code checks or build process failed. Please fix the issues before committing."
 exit 1
fi

# If all checks pass, allow the commit
echo "All checks passed. Proceeding with commit."
exit 0
''';

  // Write the pre-commit hook file
  final preCommitFile = File(preCommitFilePath);
  preCommitFile.writeAsStringSync(preCommitContent);

  // Make the pre-commit hook executable using a shell command
  Process.runSync('chmod', ['+x', preCommitFilePath]);

  log('Pre-commit hook created successfully.');
}
