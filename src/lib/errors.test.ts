import { describe, expect, it } from "vitest";
import { raise } from "./errors";

describe("raise", () => {
  it("should throw in nullable chains", () => {
    const obj = {} as { anything?: string };
    const msg = "Data not found";

    try {
      obj?.anything ?? raise(msg);
    } catch (err) {
      if (err instanceof Error) {
        expect(err.message).toBe(msg);
      } else {
        throw err;
      }
    }
  });

  it("should not throw in nullable chains", () => {
    const obj = { something: true };
    const msg = "Data not found";

    const data = obj?.something ?? raise(msg);
    expect(data).toBeTruthy();
  });
});
