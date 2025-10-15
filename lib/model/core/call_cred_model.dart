class CallCred {
  String displayName;
  String sessionIdleTimeoutMins;
  String role;
  String sessionName;
  String sessionPwd;

  CallCred({
    required this.displayName,
    required this.sessionIdleTimeoutMins,
    required this.role,
    required this.sessionName,
    required this.sessionPwd,

    // this.patientAge
  });
}
