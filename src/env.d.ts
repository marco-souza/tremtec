declare namespace App {
  type CurrentUser = import("./domain/user/schema").UserSession;

  interface Locals {
    title: string;
    // Add other properties you might use
    user: CurrentUser | undefined;
  }
}
