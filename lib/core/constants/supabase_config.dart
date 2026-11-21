class SupabaseConfig {
  SupabaseConfig._();

  // Supabase proje bilgileri (Geliştirici konsolundan alınacak yer tutucular)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xyzcompany.supabase.co',
  );

  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'public-anon-key-placeholder',
  );

  static bool get isConfigured =>
      supabaseUrl != 'https://xyzcompany.supabase.co' &&
      supabasePublishableKey != 'public-anon-key-placeholder';
}
