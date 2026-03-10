import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/datasources/product_api_datasource.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/product_supabase_datasource.dart';
import '../data/product_model.dart';
import '../data/product_repository.dart';
import 'product_controller.dart';

// ──────────────────────────────────────────────────────────────────────────────
// 1.  Backend selector — change ONE line to switch the entire backend
// ──────────────────────────────────────────────────────────────────────────────

enum BackendType { api, supabase }

/// ⬇️  CHANGE THIS to switch backend. Nothing else needs to change.
const BackendType activeBackend = BackendType.supabase;

// ──────────────────────────────────────────────────────────────────────────────
// 2.  Datasource provider
// ──────────────────────────────────────────────────────────────────────────────

final productRemoteDatasourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  switch (activeBackend) {
    case BackendType.api:
      return ProductApiDataSource(client: http.Client());
    case BackendType.supabase:
      return ProductSupabaseDataSource(client: Supabase.instance.client);
  }
});

// ──────────────────────────────────────────────────────────────────────────────
// 3.  Repository provider
// ──────────────────────────────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final datasource = ref.watch(productRemoteDatasourceProvider);
  return ProductRepository(dataSource: datasource);
});

// ──────────────────────────────────────────────────────────────────────────────
// 4.  Controller provider
// ──────────────────────────────────────────────────────────────────────────────

final productControllerProvider =
    AsyncNotifierProvider<ProductController, List<ProductModel>>(
  ProductController.new,
);
