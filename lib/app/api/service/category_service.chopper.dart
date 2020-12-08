// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$CategoryService extends CategoryService {
  _$CategoryService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = CategoryService;

  Future<Response> getAllCategories() {
    final $url = '/categories';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> addCategory(Map<String, dynamic> category) {
    final $url = '/categories/add';
    final $body = category;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response> deleteById(int id) {
    final $url = '/categories/id/${id}/delete';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
