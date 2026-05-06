---
name: api-integration-frontend
description: Handles frontend API calls, response mapping, auth-aware request flow, and safe UI binding for production-oriented applications
metadata:
  version: 1.0.0
---

## Provides

- Shared API client patterns
- Data mapping and transformation
- Auth-aware request handling
- Loading, error, and cancellation handling
- Safer UI binding for async data

## Use When

- Connecting frontend with backend APIs
- Fetching and displaying dynamic data
- Handling async operations in UI
- Building dashboards, lists, detail pages, or authenticated app flows

---

## Instructions

### 1. Centralize API Access

- Create a shared API client or reusable request helper
- Keep base URL, headers, credentials, and common parsing logic in one place
- Avoid scattering raw `fetch` or `axios` calls across many components

Example:

```javascript
const apiRequest = async (path, options = {}) => {
  const res = await fetch(`${API_BASE_URL}${path}`, {
    headers: {
      "Content-Type": "application/json",
      ...options.headers,
    },
    ...options,
  });

  if (!res.ok) {
    throw new Error(`Request failed with status ${res.status}`);
  }

  return res.json();
};
```

---

### 2. Handle Auth and Shared Headers

- Attach auth tokens, cookies, or credentials consistently
- Keep token lookup or session handling inside the shared client where possible
- Avoid repeating authorization logic in every feature module

Example:

```javascript
const apiRequest = async (path, options = {}) => {
  const token = localStorage.getItem("token");

  return fetch(`${API_BASE_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });
};
```

---

### 3. Normalize Errors

- Convert server, network, and parsing failures into a predictable error shape
- Distinguish validation errors, auth failures, and unexpected server errors
- Prefer reusable error handling over ad hoc generic messages

Example:

```javascript
const parseError = async (res) => {
  let details = null;

  try {
    details = await res.json();
  } catch {}

  return {
    status: res.status,
    message: details?.message || "Request failed",
    details,
  };
};
```

---

### 4. Map Responses Before UI Binding

- Transform raw API responses into UI-friendly shapes before rendering
- Keep mapping logic near the API layer or feature service
- Avoid binding backend response structure directly to every component

Example:

```javascript
const mapUser = (user) => ({
  id: user.id,
  name: user.full_name,
  email: user.email_address,
});
```

---

### 5. Handle Loading, Error, and Empty States Safely

- Track loading, success, error, and empty states explicitly
- Avoid rendering stale or partial data without making the state clear
- Reset or preserve data intentionally when refetching

Standard flow:

1. Start request
2. Set loading state
3. Parse and map response
4. Update success or empty state
5. Show normalized error on failure

---

### 6. Prevent Race Conditions and Leaks

- Cancel or ignore outdated requests when components unmount or inputs change
- Use `AbortController` or equivalent cancellation support
- Prevent slower old requests from overwriting newer results

Example:

```javascript
useEffect(() => {
  const controller = new AbortController();

  apiRequest("/users", { signal: controller.signal })
    .then(setUsers)
    .catch((error) => {
      if (error.name !== "AbortError") {
        setError(error);
      }
    });

  return () => controller.abort();
}, []);
```

---

### 7. Support Query Params and Pagination Cleanly

- Build query strings consistently for filters, search, sort, and pagination
- Keep request-building logic reusable
- Avoid manual string concatenation in many places

Example:

```javascript
const createQueryString = (params) =>
  new URLSearchParams(params).toString();
```

---

### 8. Respect Environment and Runtime Boundaries

- Read API base URLs and environment-specific settings from shared config
- Keep browser-only behavior separate from server-rendered or hybrid runtime paths
- For frameworks like Next.js, be careful about client/server data-fetching boundaries

---

### 9. Retry and Reporting

- Retry only when the failure type justifies it
- Avoid blind retries for validation or auth errors
- Log or surface failures in a consistent way for debugging

---

### 10. Safety Notes

- Do not expose secrets in frontend request code or environment variables
- Prefer one shared client over duplicated request logic
- Validate assumptions about response shape before binding to UI
- Distinguish confirmed production needs from optional optimizations like caching or retries

## Standard Flow

```javascript
build request with shared client
-> attach auth and config
-> send request
-> normalize errors
-> map response for UI
-> update loading, success, empty, or error state
```
