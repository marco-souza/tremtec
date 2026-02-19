/** Raises an error with the given message.
 *
 * Example:
 *
 * ```ts
 * returnsNullableValue() ?? raise("This is an error message");
 * ```
 *
 * @param message - The error message.
 * @returns Never.
 */
export function raise(message: string): never {
  throw new Error(message);
}
