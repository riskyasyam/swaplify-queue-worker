module.exports = {
  apps: [
    {
      name: 'nestjs-dev',
      script: 'npm',
      args: 'run start:dev',
      cwd: '/app',
      instances: 1,
      autorestart: true,
      watch: ['src'],
      ignore_watch: ['node_modules', 'logs', 'dist'],
      env: {
        NODE_ENV: 'development',
        PORT: 3000
      },
      error_file: '/app/logs/nestjs-dev-error.log',
      out_file: '/app/logs/nestjs-dev-out.log',
      log_file: '/app/logs/nestjs-dev-combined.log',
      time: true
    },
    {
      name: 'queue-worker-dev',
      script: 'npm',
      args: 'run dev',
      cwd: '/app/queue-worker',
      instances: 1,
      autorestart: true,
      watch: ['.'],
      ignore_watch: ['node_modules', 'logs'],
      env: {
        NODE_ENV: 'development'
      },
      error_file: '/app/logs/queue-worker-dev-error.log',
      out_file: '/app/logs/queue-worker-dev-out.log',
      log_file: '/app/logs/queue-worker-dev-combined.log',
      time: true
    }
  ]
};
