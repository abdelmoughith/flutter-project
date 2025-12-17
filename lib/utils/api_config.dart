class ApiConfig {
  static const String baseUrl = 'http://10.64.30.180:8880';
  // auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String username = '$baseUrl/api/user';
  static const String user = '$baseUrl/api/user/user';


  static const String allProjects = '$baseUrl/projects';
  static const String allFinancements = '$baseUrl/financement/formated';
  // mine
  static const String myProjects = '$baseUrl/projects/mine';
  static const String myFinancements = '$baseUrl/financement/formated/mine';
  // create project
  static const String createProject = '$baseUrl/projects';
  //financer un projet get and post in ONE
  static const String projectFinancements = '$baseUrl/financement/project';
}
