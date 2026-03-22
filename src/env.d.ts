declare namespace App {
  type CurrentUser = import("./domain/user/schema").UserSession;

  interface Locals {
    title: string;
    user: CurrentUser | undefined;
  }
}

// Cloudflare Worker Bindings
declare interface Bindings {
  EMAIL?: {
    send(message: { from: string; to: string; raw: Uint8Array }): Promise<void>;
  };
}

// Cloudflare Email module declaration
declare module "cloudflare:email" {
  export class EmailMessage {
    constructor(from: string, to: string, raw: Uint8Array);
    setReplyTo(addr: string): void;
    from: string;
    to: string;
    raw: Uint8Array;
  }
}
