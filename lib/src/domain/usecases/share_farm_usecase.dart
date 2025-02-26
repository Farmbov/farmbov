import 'package:farmbov/src/domain/models/firestore/share_model.dart';
import 'package:farmbov/src/domain/repositories/farm_repository.dart';
import 'package:farmbov/src/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareFarmUseCase {
  final FarmRepository _farmRepository = FarmRepositoryImpl();

  ShareFarmUseCase();

  Future<ShareModel?> call(String farmId, String documentOrEmail) async {
    try {
      if (documentOrEmail.isEmpty) {
        throw Exception('Informe o CPF ou e-mail do usuário');
      }

      final farm = await _farmRepository.getFarmById(farmId);

      if (farm == null) {
        throw Exception('Fazenda não encontrada');
      }

      final user =
          await UserRepository().findUserByDocumentOrEmail(documentOrEmail);

      final shareFarmData = createShareModelData(
        farmId: farmId,
        sharedBy: FirebaseAuth.instance.currentUser?.uid,
        sharedTo: user?.ffRef?.id,
        documentOrEmail: documentOrEmail,
        create: true,
      );
      await ShareModel.collection.doc().set(shareFarmData);

      return ShareModel.getDocumentFromData(shareFarmData);
    } catch (e) {
      rethrow;
    }
  }
}
