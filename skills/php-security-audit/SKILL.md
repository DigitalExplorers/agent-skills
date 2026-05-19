---
name: php-security-audit
description: Audits PHP codebases for critical security vulnerabilities including SQL injection, XSS, command injection, file inclusion, insecure deserialization, weak cryptography, CSRF, and misconfigured PHP settings
metadata:
  version: 1.0.0
---

# PHP Security Audit

## Provides

- Injection vulnerability detection (SQL, command, code, XML)
- XSS and output escaping review
- File security checks (inclusion, path traversal, uploads)
- Authentication, session, and CSRF review
- Cryptography and password handling audit
- Sensitive data and configuration exposure checks
- Severity-ranked findings with file references and fix guidance

## Use When

- Auditing a PHP application before release or deployment
- Reviewing legacy PHP code for security debt
- Investigating a reported vulnerability or incident
- Performing a security check on a Laravel, Symfony, WordPress, or plain PHP project
- Checking whether user input is safely handled throughout the codebase

---

## Instructions

### 1. Map the Attack Surface

- Identify all entry points where user input enters the application: `$_GET`, `$_POST`, `$_REQUEST`, `$_COOKIE`, `$_FILES`, `$_SERVER`, `php://input`, and request headers
- List routes, controllers, form handlers, file upload endpoints, and API endpoints
- Note which entry points are public, authenticated, or admin-only
- Prioritize reviewing code paths that touch the database, filesystem, shell, or external services

---

### 2. Check for SQL Injection

- Search for raw database queries built with string concatenation using user input
- Flag any use of `mysqli_query()`, `PDO::query()`, or ORM raw query methods with unparameterized input
- Confirm that all queries use prepared statements with bound parameters
- Review ORM usage for raw query escape hatches: `whereRaw()`, `selectRaw()`, `DB::statement()` in Laravel, or `createNativeQuery()` in Doctrine

Examples to flag:

- `"SELECT * FROM users WHERE id = " . $_GET['id']`
- `mysqli_query($conn, "SELECT * FROM orders WHERE user='" . $user . "'")`
- `DB::select("SELECT * FROM logs WHERE action = '$action'")`

---

### 3. Check for Cross-Site Scripting (XSS)

- Find every location where PHP variables are echoed or printed into HTML without escaping
- Flag direct output of `$_GET`, `$_POST`, `$_REQUEST`, or `$_COOKIE` values in templates or views
- Confirm that output is wrapped in `htmlspecialchars()` with `ENT_QUOTES` and the correct charset, or that a template engine auto-escapes by default
- Check for raw output in HTML attributes, JavaScript blocks, `href` values, and inline event handlers
- In Laravel Blade, flag `{!! !!}` unescaped output blocks used with user-controlled data

Examples to flag:

- `echo $_GET['name'];`
- `echo "<a href='" . $url . "'>"` without validation
- `{!! $userInput !!}` in Blade templates

---

### 4. Check for Command Injection

- Search for calls to `exec()`, `shell_exec()`, `system()`, `passthru()`, `popen()`, `proc_open()`, and backtick execution
- Flag any use of user-controlled input in these calls without `escapeshellarg()` or `escapeshellcmd()`
- Confirm that shell execution of user input is necessary and that safer alternatives do not exist

Examples to flag:

- `exec("convert " . $_POST['filename'])`
- `` `ping ` . $host ``
- `system("rm -rf " . $path)`

---

### 5. Check for Code Injection

- Flag `eval()` called with any user-supplied or externally loaded data
- Review `assert()` calls with string arguments, which execute as PHP code in older versions
- Check `preg_replace()` calls using the deprecated `/e` modifier
- Look for `create_function()` usage, which is equivalent to `eval()`

Examples to flag:

- `eval($_POST['code']);`
- `assert($_GET['expr'])`
- `preg_replace('/' . $pattern . '/e', $replacement, $subject)`

---

### 6. Check for File Inclusion Vulnerabilities

- Search for `include`, `require`, `include_once`, and `require_once` calls where the path is derived from user input
- Flag remote file inclusion risks when `allow_url_include` is enabled and the path can point to an external URL
- Check for path traversal sequences (`../`) that could let users escape the intended directory
- Review dynamic file loading patterns where a filename is constructed from a request parameter

Examples to flag:

- `include($_GET['page'] . '.php')`
- `require($_POST['module'])`
- `include("../includes/" . $file)`

---

### 7. Check File Upload Security

- Confirm that uploaded files are validated by both MIME type and file extension using a strict whitelist
- Flag reliance on `$_FILES['file']['type']` alone, which is client-controlled and untrusted
- Check whether uploaded files are stored in a web-accessible directory where they could be executed
- Confirm uploaded filenames are sanitized before being stored to prevent path traversal or overwrite attacks
- Verify that PHP execution is disabled in the upload directory via server configuration

Examples to flag:

- Accepting `.php`, `.phtml`, `.phar`, or `.shtml` extensions
- Storing uploads in `public/uploads/` without disabling PHP execution
- Using the original client filename directly as the stored filename

---

### 8. Check for CSRF Vulnerabilities

- Identify all forms and endpoints that perform state-changing operations: login, logout, password change, data deletion, payments, profile updates
- Confirm that each such endpoint validates a CSRF token tied to the user session
- Flag state-changing actions reachable via GET requests
- In Laravel, check that `VerifyCsrfToken` middleware is active and not excluded for sensitive routes

Examples to flag:

- `<form method="POST">` with no hidden CSRF token field
- Password reset or account delete endpoints with no token check
- Routes excluded from CSRF middleware without justification

---

### 9. Check for Insecure Deserialization

- Search for `unserialize()` called on user-supplied input from requests, cookies, or external sources
- Flag object injection risks through PHP magic methods: `__wakeup()`, `__destruct()`, `__toString()`, `__call()`
- Review whether `serialize()` and `unserialize()` are used for session or cache storage with user-controlled keys
- Recommend replacing `unserialize()` with `json_decode()` for data exchange where object types are not needed

Examples to flag:

- `$data = unserialize($_COOKIE['cart']);`
- `$obj = unserialize(base64_decode($_GET['token']));`

---

### 10. Check Cryptography and Password Handling

- Confirm passwords are hashed with `password_hash()` using `PASSWORD_BCRYPT` or `PASSWORD_ARGON2ID`
- Flag use of `md5()`, `sha1()`, or `sha256()` for password storage
- Verify password comparison uses `password_verify()` and not `==` or `===` on raw hashes
- Confirm security tokens (password reset links, API tokens, CSRF values) are generated with `random_bytes()` or `random_int()` and not `rand()`, `mt_rand()`, or `uniqid()`
- Check for hardcoded secrets, API keys, or passwords in source files

Examples to flag:

- `md5($password)` or `sha1($password . $salt)`
- `$token = uniqid();` used as a secure reset token
- `$apiKey = "sk_live_abc123";` hardcoded in source

---

### 11. Check Session Security

- Confirm `session_regenerate_id(true)` is called after successful login to prevent session fixation
- Check session cookie configuration: `HttpOnly`, `Secure`, and `SameSite` flags should be set
- Confirm session IDs are not exposed in URLs via `SID` constant or `session.use_trans_sid`
- Review session lifetime and logout behavior to ensure sessions are fully destroyed on logout

Configuration to verify in `php.ini` or `ini_set()`:

- `session.cookie_httponly = 1`
- `session.cookie_secure = 1`
- `session.cookie_samesite = Strict` or `Lax`
- `session.use_strict_mode = 1`

---

### 12. Check for XML External Entity (XXE) Injection

- Search for `simplexml_load_string()`, `DOMDocument::loadXML()`, `XMLReader`, and `SimpleXMLElement` usage
- Confirm that external entity loading is disabled before parsing untrusted XML
- Flag any XML parsing that processes user-supplied or externally fetched XML without entity restrictions

Safe pattern to confirm:

```php
libxml_disable_entity_loader(true);
$dom = new DOMDocument();
$dom->loadXML($xml, LIBXML_NONET | LIBXML_NOENT);
```

---

### 13. Check for Open Redirect

- Search for `header("Location: ...")` where the redirect target includes user-supplied input
- Confirm redirect targets are validated against a whitelist of allowed domains or are relative paths only
- Flag redirects that could send users to attacker-controlled URLs

Examples to flag:

- `header("Location: " . $_GET['redirect']);`
- `header("Location: " . $_POST['return_url']);`

---

### 14. Check for Mass Assignment

- In Laravel, confirm all Eloquent models define `$fillable` or `$guarded` and do not use `$guarded = []` carelessly
- Flag `$model->fill($request->all())` or `Model::create($request->all())` without field restriction
- In other frameworks, check whether request data is mapped to model properties without an explicit allowlist

Examples to flag:

- `User::create($request->all());` with no `$fillable` defined
- `$user->fill($request->input());` on a model with `$guarded = []`

---

### 15. Check PHP Configuration and Sensitive Exposure

- Flag `display_errors = On` in production environments
- Check for `phpinfo()` calls accessible via web routes
- Confirm `allow_url_include = Off` and `allow_url_fopen` is restricted where not needed
- Look for `.env` files, `config.php`, or credential files accessible from the web root
- Check for debug output left in production: `var_dump()`, `print_r()`, `dd()`, `die()` with sensitive data
- Confirm error logging writes to a file rather than displaying to users

---

### 16. Report Findings by Severity

Group all findings under the following severity levels based on exploitability and impact:

- **Critical** — direct remote code execution, SQL injection with full data access, file inclusion, insecure deserialization
- **High** — XSS, CSRF on sensitive actions, command injection, weak password storage, XXE
- **Medium** — session fixation, path traversal, open redirect, mass assignment, missing CSRF on lower-risk actions
- **Low** — debug output in production, weak token generation, missing security headers, `phpinfo()` exposure

Standard audit flow:

1. Map entry points and user-controlled data sources
2. Trace input through injection-prone functions
3. Review output handling for XSS
4. Check file, session, and cryptography handling
5. Review framework-level protections and PHP configuration
6. Report findings with file, line, explanation, and fix

---

### 17. Safety Notes

- Do not flag a pattern as vulnerable unless the user input can actually reach the dangerous function without safe sanitization
- Distinguish confirmed vulnerabilities from suspicious patterns that require runtime context to verify
- Framework-provided protections (Laravel query builder, Blade escaping, CSRF middleware) reduce but do not eliminate risk — verify they are active and not bypassed
- Security findings should reference specific files and lines, not general observations

## Output Format

### Critical Vulnerabilities

- **Type** — e.g. SQL Injection
- **File** — path and line number
- **Explanation** — what is wrong and why it is exploitable
- **Fix** — specific code-level recommendation

### High Severity

- **Type**
- **File**
- **Explanation**
- **Fix**

### Medium Severity

- **Type**
- **File**
- **Explanation**
- **Fix**

### Low Severity / Hardening Recommendations

- **Type**
- **Suggestion**

### Passed Checks

- Security controls that were reviewed and confirmed working correctly

## Standard Flow

```
map entry points and user input sources
-> check injection vulnerabilities (SQL, command, code, XML)
-> review output escaping and XSS risks
-> audit file handling (inclusion, traversal, uploads)
-> check CSRF, session, and authentication controls
-> review cryptography and password handling
-> inspect PHP configuration and sensitive exposure
-> report findings by severity with file references and fixes
```
