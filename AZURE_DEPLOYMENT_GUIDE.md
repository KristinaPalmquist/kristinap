# Azure App Service Deployment Guide for Django Portfolio

## Prerequisites

- Azure account with active subscription
- Azure App Service already created (kristinap.azurewebsites.net)
- GitHub repository connected to Azure App Service

## Files Created/Updated for Azure Deployment

### 1. startup.sh

- Custom startup script for Azure App Service
- Handles pip install, collectstatic, migrations, and Gunicorn startup
- Made executable with proper permissions

### 2. web.config

- Azure App Service configuration file
- Points to startup.sh script
- Configures logging and request handling

### 3. Updated settings.py

- Added Azure-specific ALLOWED_HOSTS
- Added CSRF_TRUSTED_ORIGINS for Azure domains
- Added security settings for HTTPS
- Added logging configuration
- Made DEBUG environment-variable configurable

### 4. Updated GitHub Actions workflow

- Changed Python version from 3.12 to 3.13 (required for dependencies)

## Environment Variables to Set in Azure App Service

Go to Azure Portal → Your App Service → Configuration → Application settings and add:

### Required Environment Variables:

```
SECRET_KEY=your-django-secret-key-here
DATABASE_URL=your-database-connection-string
DEBUG=False
WEBSITE_HOSTNAME=kristinap.azurewebsites.net
```

### Optional Environment Variables:

```
PYTHONPATH=/home/site/wwwroot
```

## Database Setup Options

### Option 1: Azure Database for PostgreSQL

1. Create Azure Database for PostgreSQL
2. Set DATABASE_URL environment variable:
   ```
   postgres://username:password@servername.postgres.database.azure.com:5432/databasename
   ```

### Option 2: SQLite (Simple, for testing)

- If no DATABASE_URL is set, Django will use SQLite
- Not recommended for production

## Deployment Steps

### 1. Commit and Push Changes

```bash
git add .
git commit -m "Configure for Azure App Service deployment"
git push origin main
```

### 2. GitHub Actions will automatically:

- Build the application with Python 3.13
- Install dependencies from requirements.txt
- Deploy to Azure App Service

### 3. Monitor Deployment

- Check GitHub Actions tab for build/deploy status
- Check Azure App Service logs for any issues

## Azure App Service Configuration

### Application Settings (in Azure Portal):

1. Go to Configuration → General settings
2. Set:
   - **Runtime stack**: Python 3.13
   - **Startup Command**: Leave empty (web.config handles this)

### Custom Domain (Optional):

- Configure custom domain in Azure App Service
- Update ALLOWED_HOSTS in settings.py accordingly

## Troubleshooting

### Check Logs:

```bash
# Azure CLI
az webapp log tail --name kristinap --resource-group your-resource-group
```

### Common Issues:

1. **Static files not loading**: Ensure collectstatic runs in startup.sh
2. **Database connection**: Verify DATABASE_URL format
3. **CSRF errors**: Check CSRF_TRUSTED_ORIGINS includes your domain
4. **Python version**: Ensure Azure uses Python 3.13

## Security Checklist

- ✅ DEBUG=False in production
- ✅ SECRET_KEY in environment variables
- ✅ HTTPS redirect enabled
- ✅ Secure cookies enabled
- ✅ CSRF protection configured
- ✅ ALLOWED_HOSTS restricted

## Next Steps After Deployment

1. Set up database (run migrations)
2. Create Django superuser (if needed)
3. Test all functionality
4. Set up monitoring and alerts
5. Configure backup strategy

## Useful Commands for Azure CLI

```bash
# Restart app
az webapp restart --name kristinap --resource-group your-resource-group

# View logs
az webapp log tail --name kristinap --resource-group your-resource-group

# SSH into container (if needed)
az webapp ssh --name kristinap --resource-group your-resource-group
```
