export function getCSRFToken() {
  return document.querySelector("[name='csrf-token']").content;
}