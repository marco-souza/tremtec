import { describe, expect, it } from "vitest";
import { UserService } from "./service";

describe("validate service was created", () => {
  it("has object", () => {
    expect(UserService).not.toBeNull();
  });

  it("has user schema", () => {
    expect(UserService.userSchema).not.toBeNull();
  });
});
