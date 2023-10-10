import 'package:meuappcep/models/viacepback_model.dart';
import 'back_custom_dio.dart';

class ViacepsBackRepositoy {
  final _customDio = BackCustomDio();

  ViacepsBackRepositoy();

  Future<ViacepsBackModel> obterCep() async {
    var url = "/viacepback";
    var result = await _customDio.dio.get(url);
    return ViacepsBackModel.fromJson(result.data);
  }

  Future<void> criar(ViacepBackModel viacepBackModel) async {
    try {
      await _customDio.dio
          .post("/viacepback", data: viacepBackModel.toJsonEndpoint()); //.toJsonEndpoint()
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ViacepBackModel viacepBackModel) async {
    try {
      var response = await _customDio.dio.put(
          "/viacepback/${viacepBackModel.objectId}}", //.objectId
          data: viacepBackModel.toJson()); //.toJsonEndpoint()
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      var response = await _customDio.dio.delete(
        "/viacepback/$objectId",
      );
    } catch (e) {
      rethrow;
    }
  }
}
