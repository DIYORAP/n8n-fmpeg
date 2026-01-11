# n8n with FFmpeg on Railway

Production-ready setup for self-hosting n8n with FFmpeg and PostgreSQL on Railway.

## Features

- ✅ n8n workflow automation platform
- ✅ FFmpeg installed and ready to use
- ✅ PostgreSQL database for workflow storage (no SQLite)
- ✅ Persistent data storage via Railway volume
- ✅ Basic authentication enabled
- ✅ HTTPS webhooks support
- ✅ Safe for restarts and redeploys

## Prerequisites

- Railway account ([sign up here](https://railway.app))
- Railway CLI (optional, for local testing)

## Deployment Steps

### 1. Create a New Railway Project

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project"
3. Select "Deploy from GitHub repo" or "Empty Project"

### 2. Add PostgreSQL Service

1. In your Railway project, click "+ New"
2. Select "Database" → "Add PostgreSQL"
3. Railway will automatically create a PostgreSQL instance
4. Note the service name (you'll need it for volume configuration)

### 3. Add Volume for Data Persistence

1. In your Railway project, click "+ New"
2. Select "Volume"
3. Name it `n8n-data` (or any name you prefer)
4. Mount path: `/home/node/.n8n`
5. Link it to your n8n service

### 4. Deploy n8n Service

1. In your Railway project, click "+ New"
2. Select "GitHub Repo" (or use Railway CLI: `railway up`)
3. Select this repository
4. Railway will automatically detect the Dockerfile and build

### 5. Configure Environment Variables

In your n8n service settings, add these environment variables:

#### Required Variables

```bash
# Database (Auto-configured by Railway when PostgreSQL is linked)
DB_TYPE=postgresdb

# Basic Auth (REQUIRED)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=<hash-using-command-below>

# Generate password hash:
# node -e "console.log(require('bcryptjs').hashSync('YourSecurePassword', 10))"
# Or use: https://bcrypt-generator.com/ (rounds: 10)

# Webhook URL (Update with your Railway domain)
N8N_PROTOCOL=https
WEBHOOK_URL=https://<your-app-name>.railway.app/

# Encryption Key (REQUIRED - Generate a new one!)
N8N_ENCRYPTION_KEY=<generate-random-32-char-string>
# Generate with: openssl rand -hex 32
```

#### PostgreSQL Connection (Auto-set by Railway)

When you link the PostgreSQL service, Railway automatically sets:
- `DB_POSTGRESDB_HOST`
- `DB_POSTGRESDB_PORT`
- `DB_POSTGRESDB_DATABASE`
- `DB_POSTGRESDB_USER`
- `DB_POSTGRESDB_PASSWORD`

#### Optional Variables

```bash
# Host and Port
N8N_HOST=0.0.0.0
N8N_PORT=443

# Logging
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console

# Metrics
N8N_METRICS=true
```

### 6. Generate Required Secrets

#### Generate Basic Auth Password Hash

**Option 1: Using Node.js**
```bash
node -e "console.log(require('bcryptjs').hashSync('YourPasswordHere', 10))"
```

**Option 2: Using Docker (if Node.js not installed)**
```bash
docker run --rm node:18-alpine sh -c "npm install bcryptjs && node -e \"console.log(require('bcryptjs').hashSync('YourPasswordHere', 10))\""
```

**Option 3: Online Tool**
Visit https://bcrypt-generator.com/ (use 10 rounds)

#### Generate Encryption Key

```bash
openssl rand -hex 32
```

Or using Node.js:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 7. Link Services

1. Go to your n8n service settings
2. Under "Variables", you should see the PostgreSQL connection variables auto-populated
3. Ensure the volume is linked (check "Volumes" tab)

### 8. Deploy and Access

1. Railway will automatically deploy when you push to your repo
2. Once deployed, Railway will provide a public URL (e.g., `https://your-app.up.railway.app`)
3. Access n8n at the provided URL
4. Login with the basic auth credentials you configured

## Verification

### Check FFmpeg Installation

1. Open n8n UI
2. Create a test workflow with an "Execute Command" node
3. Run: `ffmpeg -version`
4. You should see FFmpeg version information

### Verify PostgreSQL Connection

1. In n8n, go to Settings → Database
2. You should see PostgreSQL connection details
3. Create a workflow and save it
4. Restart the service - your workflow should persist

## Security Best Practices

1. **Always use Basic Auth** - Never deploy without authentication
2. **Use strong passwords** - Generate secure random passwords
3. **Keep encryption key safe** - If lost, you'll need to re-encrypt all credentials
4. **Use Railway's built-in HTTPS** - Railway provides SSL certificates automatically
5. **Set up monitoring** - Use Railway's metrics and logs

## Troubleshooting

### n8n won't start

- Check environment variables are set correctly
- Verify PostgreSQL service is running and linked
- Check logs: `railway logs` or in Railway dashboard

### Workflows not persisting

- Verify volume is mounted at `/home/node/.n8n`
- Check volume is linked to the service
- Ensure `DB_TYPE=postgresdb` is set

### FFmpeg not found

- Check Dockerfile build logs
- Verify FFmpeg installation in container: `railway run ffmpeg -version`

### Webhooks not working

- Ensure `WEBHOOK_URL` is set to your Railway public URL
- Verify `N8N_PROTOCOL=https`
- Check Railway domain is publicly accessible

## File Structure

```
.
├── Dockerfile          # Extends n8n image and installs FFmpeg
├── railway.json        # Railway deployment configuration
├── .dockerignore       # Files to exclude from Docker build
├── .env.example        # Example environment variables
└── README.md           # This file
```

## Backup Strategy

1. **Workflows**: Stored in PostgreSQL (backup Railway PostgreSQL)
2. **Credentials**: Encrypted in PostgreSQL (included in DB backup)
3. **Data folder**: Stored in Railway volume at `/home/node/.n8n`
   - Can be exported via Railway CLI or dashboard

## Updating n8n

1. The Dockerfile uses `n8nio/n8n:latest`
2. Railway will rebuild on next deploy
3. For version pinning, change `latest` to specific version in Dockerfile

## Support

- [n8n Documentation](https://docs.n8n.io)
- [Railway Documentation](https://docs.railway.app)
- [n8n Community Forum](https://community.n8n.io)

## License

This setup configuration is provided as-is. n8n itself is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md).

