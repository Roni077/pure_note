abstract class BackupService {
  /// Creates a backup and returns the file path of the generated .purenote archive.
  Future<String> createBackup();
  
  /// Restores a backup from the given file path.
  Future<void> restoreBackup(String filePath);
}
