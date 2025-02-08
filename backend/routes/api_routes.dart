import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/permission_controller.dart';
import '../controllers/user_permission_controller.dart';
import '../controllers/race_controller.dart';
import '../controllers/ability_controller.dart';
import '../controllers/class_controller.dart';

final authController = AuthController();
final permissionController = PermissionController();
final userPermissionController = UserPermissionController();
final raceController = RaceController();
final abilityController = AbilityController();
final classController = ClassController();

Router defineApiRoutes() {
  final router = Router();

  // Autenticazione
  router.post(
      '/register', (Request request) async => authController.register(request));
  router.post(
      '/login', (Request request) async => authController.login(request));
  router.post(
      '/logout', (Request request) async => authController.logout(request));
  router.get('/user/get-by-email/<email>',
      (Request request, String email) => authController.getUserByEmail(email));
  router.get(
      '/user/get-by-username/<username>',
      (Request request, String username) =>
          authController.getUserByUsername(username));
  router.post('/user-settings/update',
      (Request request) async => authController.updateUserSettings(request));

  // Permessi
  router.post('/permissions/add',
      (Request request) async => permissionController.addPermission(request));
  router.post('/permissions/edit',
      (Request request) async => permissionController.editPermission(request));
  router.post(
      '/permissions/disable',
      (Request request) async =>
          permissionController.disablePermission(request));
  router.post('/permissions/get-id',
      (Request request) async => permissionController.getPermissionId(request));

  // Permessi utente
  router.post(
      '/user-permissions/assign',
      (Request request) async =>
          userPermissionController.assignPermission(request));
  router.post(
      '/user-permissions/remove',
      (Request request) async =>
          userPermissionController.removePermission(request));
  router.get(
      '/user-permissions/<user_id>',
      (Request request, String user_id) async =>
          permissionController.getUserPermissions(request, user_id));

  // Razze
  router.post(
      '/race/add', (Request request) async => raceController.addRace(request));
  router.post('/race/edit',
      (Request request) async => raceController.editRace(request));
  router.post('/race/inactivate',
      (Request request) async => raceController.inactivateRace(request));
  router.get('/race/list',
      (Request request) async => raceController.getAllRaces(request));
  router.get(
      '/race/<id>',
      (Request request, String id) async =>
          raceController.getRaceById(request, id));

  router.post('/race/assign-ability',
      (Request request) async => raceController.assignRaceAbility(request));
  router.post('/race/remove-ability',
      (Request request) async => raceController.removeRaceAbility(request));
  router.post('/race/update-ability',
      (Request request) async => raceController.updateRaceAbility(request));
  router.post('/race/get-abilities',
      (Request request) async => raceController.getRaceAbilities(request));
  router.post('/race/get-races-by-ability',
      (Request request) async => raceController.getRacesByAbility(request));

  // Abilità
  router.post('/ability/add',
      (Request request) async => abilityController.addAbility(request));
  router.post('/ability/edit',
      (Request request) async => abilityController.editAbility(request));
  router.post('/ability/inactivate',
      (Request request) async => abilityController.inactivateAbility(request));
  router.get('/ability/list',
      (Request request) async => abilityController.getAllAbilities(request));
  router.get(
      '/ability/{id}',
      (Request request, String id) async =>
          abilityController.getAbilityById(request, id));




  router.get('/classes', classController.getAllClasses);
  router.get('/classes/<id>', classController.getClassById);
  router.post('/classes', classController.addClass);
  router.put('/classes/<id>', classController.updateClass);
  router.delete('/classes/<id>', classController.deactivateClass);

  return router;
}




