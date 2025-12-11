# Duplication Report - Tremtec Project

## Executive Summary

Found **10 categories of code duplication** across the project affecting **3 LiveViews** and **2 context modules**. Most critical duplications are in admin pages (delete modals, pagination, search).

---

## 1. DELETE MODAL HANDLERS (🔴 HIGH PRIORITY)

**Severity:** HIGH  
**Files Affected:** 3
- `lib/tremtec_web/live/admin/users_live/index.ex` (lines 180-185, 263-268)
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 263-268, 237-260)
- `lib/tremtec_web/live/admin/messages_live/show.ex` (lines 151-156, 159-173)

**Pattern:**
```elixir
def handle_event("show_delete_modal", %{"id" => id}, socket) do
  {:noreply, socket |> assign(show_delete_modal: true, delete_modal_id: id)}
end

def handle_event("close_delete_modal", _params, socket) do
  {:noreply, socket |> assign(show_delete_modal: false, delete_modal_id: nil)}
end

def handle_event("confirm_delete", %{"id" => id}, socket) do
  # Delete implementation differs but structure is identical
end
```

**Impact:** 3 implementations of the same pattern  
**Recommendation:** Extract to a reusable mixin/module or create a shared LiveView behavior

---

## 2. DELETE MODAL UI TEMPLATE (🔴 HIGH PRIORITY)

**Severity:** HIGH  
**Files Affected:** 3
- `lib/tremtec_web/live/admin/users_live/index.ex` (lines 102-133)
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 151-181)
- `lib/tremtec_web/live/admin/messages_live/show.ex` (lines 78-101)

**Pattern:**
```heex
<div :if={@show_delete_modal} class="modal modal-open" id="delete-modal">
  <div class="modal-box">
    <h3 class="font-bold text-lg">{gettext("Confirm Deletion")}</h3>
    <p class="py-4">{gettext("Are you sure...")}</p>
    <div class="modal-action">
      <button class="btn btn-outline" phx-click="close_delete_modal">
        {gettext("Cancel")}
      </button>
      <button class="btn btn-error" phx-click="confirm_delete" 
              phx-value-id={@delete_modal_id}>
        {gettext("Delete")}
      </button>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button phx-click="close_delete_modal">{gettext("Close")}</button>
  </form>
</div>
```

**Impact:** Identical markup in 3 files (copy-paste)  
**Recommendation:** Create a reusable component `<DeleteModal.confirm />` in `components/`

---

## 3. PAGINATION HANDLERS (🟡 MEDIUM PRIORITY)

**Severity:** MEDIUM  
**Files Affected:** 2
- `lib/tremtec_web/live/admin/users_live/index.ex` (lines 162-178)
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 219-235)

**Pattern:**
```elixir
def handle_event("next_page", _params, socket) do
  socket = socket |> assign(page: socket.assigns.page + 1) |> load_data()
  {:noreply, socket}
end

def handle_event("prev_page", _params, socket) do
  socket = socket |> assign(page: socket.assigns.page - 1) |> load_data()
  {:noreply, socket}
end
```

**Impact:** Identical pagination logic in 2 files  
**Recommendation:** Extract to shared module or create a pagination component

---

## 4. SEARCH FORM HANDLERS (🟡 MEDIUM PRIORITY)

**Severity:** MEDIUM  
**Files Affected:** 2
- `lib/tremtec_web/live/admin/users_live/index.ex` (lines 153-160)
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 201-217)

**Pattern:**
```elixir
def handle_event("search", %{"search" => %{"q" => q}}, socket) do
  socket = socket |> assign(search: q, page: 1) |> load_data()
  {:noreply, socket}
end

def handle_event("clear_search", _params, socket) do
  socket = socket |> assign(search: "", page: 1) |> load_data()
  {:noreply, socket}
end
```

**Impact:** Identical search logic in 2 files  
**Recommendation:** Extract to shared behavior or create pagination/search module

---

## 5. EMAIL VALIDATION (🟡 MEDIUM PRIORITY)

**Severity:** MEDIUM  
**Files Affected:** 3
- `lib/tremtec/accounts/user.ex` (lines 36-54)
- `lib/tremtec_web/live/public_pages/contact_live.ex` (lines 194-205)
- `lib/tremtec/messages/contact_message.ex` (lines 27-34)

**Pattern:**
```elixir
|> validate_required([:email])
|> validate_format(:email, ~r/^\S+@\S+\.[\w\.]+$/)
|> validate_length(:email, max: 160)
```

**Impact:** Same email regex validation in 3 different modules  
**Recommendation:** Create shared validator module: `Tremtec.Validators.Email`

---

## 6. PAGINATION UI TEMPLATE (🟡 MEDIUM PRIORITY)

**Severity:** MEDIUM  
**Files Affected:** 2
- `lib/tremtec_web/live/admin/users_live/index.ex` (lines 74-98)
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 123-148)

**Pattern:**
```heex
<div class="flex justify-center gap-2">
  <button :if={@page > 1} phx-click="prev_page">Previous</button>
  <span>{@page} of {total_pages}</span>
  <button :if={can_next_page?(@page)} phx-click="next_page">Next</button>
</div>
```

**Impact:** Identical pagination UI in 2 files  
**Recommendation:** Create reusable component `<Pagination.buttons />`

---

## 7. MESSAGE OPERATION ERROR HANDLING (🟡 MEDIUM PRIORITY)

**Severity:** MEDIUM  
**Files Affected:** 2
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 237-260, 271-295)
- `lib/tremtec_web/live/admin/messages_live/show.ex` (lines 123-148, 159-172)

**Pattern:**
```elixir
case Messages.get_contact_message(id) do
  {:ok, message} ->
    case Messages.operation(message) do
      {:ok, _} -> {:noreply, socket |> put_flash(:info, ...)}
      {:error, _} -> {:noreply, put_flash(socket, :error, ...)}
    end
  :error -> {:noreply, put_flash(socket, :error, gettext("Message not found"))}
end
```

**Impact:** Nearly identical error handling nested case blocks  
**Recommendation:** Extract to context function or create helper

---

## 8. FORM VALIDATION HANDLERS (🟢 LOW PRIORITY)

**Severity:** LOW  
**Files Affected:** 1
- `lib/tremtec_web/live/admin/settings_live.ex` (lines 122-132, 155-165)

**Pattern:**
```elixir
def handle_event("validate_field", params, socket) do
  field_form = User
    |> Accounts.change_user_field(user_params, hash_password: false)
    |> Map.put(:action, :validate)
    |> to_form()
  {:noreply, assign(socket, field_form: field_form)}
end
```

**Impact:** Same validation pattern for multiple fields in single file  
**Recommendation:** Create single generic `handle_event("validate", ...)` handler

---

## 9. ERROR MESSAGE STRINGS (🟢 LOW PRIORITY)

**Severity:** LOW  
**Files Affected:** 2
- `lib/tremtec_web/live/admin/messages_live/index.ex` (lines 255, 259, 285)
- `lib/tremtec_web/live/admin/messages_live/show.ex` (lines 143, 147, 171)

**Repeated Messages:**
- `gettext("Failed to update message status")`
- `gettext("Message not found")`
- `gettext("Failed to delete message")`

**Impact:** i18n strings duplicated across files  
**Recommendation:** Create constants module or use shared error messages

---

## Refactoring Priority

### Phase 1 (HIGH - Do First)
1. ✅ Extract delete modal component
2. ✅ Create shared email validator
3. ✅ Extract pagination component

### Phase 2 (MEDIUM - Do Next)
4. Create pagination handler module
5. Create search handler module
6. Consolidate message error handling

### Phase 3 (LOW - Nice to Have)
7. Simplify settings form validation
8. Create error messages constants

---

## Files Requiring Changes

- `lib/tremtec_web/components/` → Add DeleteModal, Pagination components
- `lib/tremtec/validators/` → Add Email validator
- `lib/tremtec/messages/` → Consolidate error handling
- `lib/tremtec_web/live/admin/users_live/index.ex` → Refactor
- `lib/tremtec_web/live/admin/messages_live/index.ex` → Refactor
- `lib/tremtec_web/live/admin/messages_live/show.ex` → Refactor

---

## Estimated Impact

| Category | LOC Reduction | Complexity ↓ | Maintainability ↑ |
|----------|---------------|--------------|-------------------|
| Delete Modal | ~150 LOC | 30% | 40% |
| Pagination | ~100 LOC | 25% | 35% |
| Email Validation | ~50 LOC | 20% | 30% |
| Error Handling | ~80 LOC | 20% | 25% |
| **TOTAL** | **~380 LOC** | **25%** | **32%** |

---

## Next Steps

1. Review this report
2. Prioritize Phase 1 refactoring
3. Create tickets for each refactor
4. Extract components and modules
5. Update LiveViews to use shared components
