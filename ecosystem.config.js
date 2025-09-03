module.exports = {
  apps: [
    {
      name: 'nestjs-app',
      script: 'dist/main.js',
      cwd: '/app',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: '/app/logs/nestjs-error.log',
      out_file: '/app/logs/nestjs-out.log',
      log_file: '/app/logs/nestjs-combined.log',
      time: true
    },
    {
      name: 'queue-worker',
      script: 'index.js',
      cwd: '/app/queue-worker',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '512M',
      env: {
        NODE_ENV: 'production'
      },
      error_file: '/app/logs/queue-worker-error.log',
      out_file: '/app/logs/queue-worker-out.log',
      log_file: '/app/logs/queue-worker-combined.log',
      time: true
    }
  ]
};
