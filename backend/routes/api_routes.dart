import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controllers/auth_controller.dart';
import '../controllers/permission_controller.dart';
import '../controllers/user_permission_controller.dart';
import '../controllers/user_page_controller.dart';
import '../controllers/race_controller.dart';
import '../controllers/ability_controller.dart';



final authController = AuthController();
final permissionController = PermissionController();
final userPermissionController = UserPermissionController();
final userPageController = UserPageController();
final raceController = RaceController();
final abilityController = AbilityController();



Router defineApiRoutes() {
  final router = Router();
  router.post('/register', (Request request) async => authController.register(request));
  router.post('/login', (Request request) async => authController.login(request));
  router.post('/logout', (Request request) async => authController.logout(request));
  router.get('/user/get-by-email/<email>', (Request request, String email) {return authController.getUserByEmail(email);});
  router.get('/user/get-by-username/<username>', (Request request, String username) {return authController.getUserByUsername(username);});
  router.post('/user-settings/update', (Request request) async => authController.updateUserSettings(request));




  router.post('/permissions/add', (Request request) async => permissionController.addPermission(request));
  router.post('/permissions/edit', (Request request) async => permissionController.editPermission(request));
  router.post('/permissions/disable', (Request request) async => permissionController.disablePermission(request));
  router.post('/permissions/get-id', (Request request) async => permissionController.getPermissionId(request));

  router.post('/user-permissions/assign', (Request request) async => userPermissionController.assignPermission(request));
  router.post('/user-permissions/remove', (Request request) async => userPermissionController.removePermission(request));
  router.get('/user-permissions/<user_id>', (Request request, String user_id) async => permissionController.getUserPermissions(request, user_id));

  router.post('/user-pages/assign', (Request request) async => userPageController.assignPageToUser(request));
  router.post('/user-pages/remove', (Request request) async => userPageController.removePageFromUser(request));
  router.get('/user-pages/<user_id>', (Request request) async => userPageController.getUserPages(request));
  router.post('/user-pages/get-id', (Request request) async => userPageController.getPageId(request));


  router.post('/race/add', (Request request) async => raceController.addRace(request));
  router.post('/race/edit', (Request request) async => raceController.editRace(request));
  router.post('/race/inactivate', (Request request) async => raceController.inactivateRace(request));
  router.get('/race/list', (Request request) async => raceController.getAllRaces(request));
  router.get('/race/<id>', (Request request, String id) async => raceController.getRaceById(request, id));

  router.post('/ability/add', (Request request) async => abilityController.addAbility(request));
  router.post('/ability/edit', (Request request) async => abilityController.editAbility(request));
  router.post('/ability/inactivate', (Request request) async => abilityController.inactivateAbility(request));
  router.get('/ability/list', (Request request) async => abilityController.getAllAbilities(request));
  router.get('/ability/{id}', (Request request, String id) async => abilityController.getAbilityById(request, id));













  return router;
}








