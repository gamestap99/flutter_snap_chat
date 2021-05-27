class HandleError {
  static String authError(String code) {
    switch (code) {
      case "invalid-email":
        return "Your email address appears to be malformed.";
        break;
      case "wrong-password":
        return "Mật khẩu không chính xác.";
        break;
      case "user-not-found":
        return "Người dùng có email này không tồn tại.";
        break;
      case "user-disable":
        return "User with this email has been disabled.";
        break;
      case "too-many-requests":
        return "Quá nhiều yêu cầu. Thử lại sau.";
        break;
      case "operation-not-allowed":
        return "Signing in with Email and Password is not enabled.";
        break;
      default:
        return "Đã xảy ra lỗi không xác định. Vui lòng thử lại sau!";
    }
  }
}
