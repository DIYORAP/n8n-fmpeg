# Environment Variables Setup Guide

Copy these variables into Railway's environment variables section.

## Required Variables

### Database Configuration (Auto-set by Railway PostgreSQL)

When you link a PostgreSQL service in Railway, these are automatically configured:

```bash
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=<auto-set>
DB_POSTGRESDB_PORT=<auto-set>
DB_POSTGRESDB_DATABASE=<auto-set>
DB_POSTGRESDB_USER=<auto-set>
DB_POSTGRESDB_PASSWORD=<auto-set>
```

**Action Required**: Make sure `DB_TYPE=postgresdb` is set manually.

### Basic Authentication (REQUIRED)

```bash
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=<hash-your-password>
```

**Generate password hash:**

**Option 1 - Using Node.js:**
```bash
node -e "console.log(require('bcryptjs').hashSync('YourPassword123', 10))"
```

**Option 2 - Using Docker:**
```bash
docker run --rm node:18-alpine sh -c "npm install bcryptjs && node -e \"console.log(require('bcryptjs').hashSync('YourPassword123', 10))\""
```

**Option 3 - Online Tool:**
Visit https://bcrypt-generator.com/ (use 10 rounds)

### Webhook Configuration

```bash
N8N_PROTOCOL=https
N8N_PORT=443
WEBHOOK_URL=https://your-app-name.up.railway.app/
```

**Action Required**: Replace `your-app-name` with your actual Railway app domain.

### Encryption Key (REQUIRED)

```bash
N8N_ENCRYPTION_KEY=<generate-random-32-char-string>
```

**Generate encryption key:**

**Option 1 - Using OpenSSL:**
```bash
openssl rand -hex 32
```

**Option 2 - Using Node.js:**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

**⚠️ IMPORTANT**: Save this key securely! If you lose it, you'll need to re-encrypt all credentials.

## Optional Variables

### Host Configuration

```bash
N8N_HOST=0.0.0.0
```

### Logging

```bash
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console
```

### Metrics

```bash
N8N_METRICS=true
```

### Email Configuration (Optional)

```bash
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=smtp.example.com
N8N_SMTP_PORT=587
N8N_SMTP_USER=user@example.com
N8N_SMTP_PASS=password
N8N_SMTP_SENDER=user@example.com
```

## Quick Setup Checklist

- [ ] Set `DB_TYPE=postgresdb`
- [ ] Generate and set `N8N_BASIC_AUTH_PASSWORD` hash
- [ ] Set `N8N_BASIC_AUTH_USER` (default: admin)
- [ ] Generate and set `N8N_ENCRYPTION_KEY`
- [ ] Set `WEBHOOK_URL` with your Railway domain
- [ ] Set `N8N_PROTOCOL=https`
- [ ] Verify PostgreSQL service is linked (auto-configures DB vars)

