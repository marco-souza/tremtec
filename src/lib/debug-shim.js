// Debug shim - provides a no-op debug implementation for Cloudflare Workers runtime
// The real debug package uses CommonJS module.exports which doesn't work in Workers

export default function debug() {
  return function() {};
}

export const init = () => {};
export const log = () => {};
export const formatArgs = () => {};
export const save = () => {};
export const load = () => {};
export const useColors = () => false;
export const colors = [];
export const destroy = () => {};
export const inspectOpts = {};
export const humanize = (n) => String(n);

export const formatters = {};
