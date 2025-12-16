class ApiConfig {
  static const String baseUrl = 'http://10.84.194.180:8880';
  // auth
  static const String login = '$baseUrl/auth/login';
  static const String username = '$baseUrl/api/user';
  static const String user = '$baseUrl/api/user/user';
  // all
  static const String allProjects = '$baseUrl/projects';
  static const String allFinancements = '$baseUrl/financement/formated';
  // mine
  static const String myProjects = '$baseUrl/projects/mine';
  static const String myFinancements = '$baseUrl/financement/formated/mine';
  // create project
  static const String createProject = '$baseUrl/projects';
}
