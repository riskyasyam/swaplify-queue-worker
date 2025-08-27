require('dotenv').config();
const { Reader } = require('nsqjs');
const axios = require('axios');

const NSQ_TOPIC = process.env.NSQ_TOPIC || 'facefusion_jobs';
const NSQ_CHANNEL = process.env.NSQ_CHANNEL || 'facefusion_worker';
const NSQ_HOST = process.env.NSQ_HOST || '127.0.0.1';
const NSQ_PORT = process.env.NSQ_PORT || '4150';
const NEST_API_URL = process.env.NEST_API_URL || 'http://localhost:3000';
const WORKER_URL = process.env.WORKER_URL || 'http://127.0.0.1:8081/worker/facefusion';
const WORKER_SECRET = process.env.WORKER_SHARED_SECRET || 'supersecret';
const INTERNAL_SECRET = process.env.INTERNAL_SECRET || 'internalsecret';

const reader = new Reader(NSQ_TOPIC, NSQ_CHANNEL, {
  nsqdTCPAddresses: `${NSQ_HOST}:${NSQ_PORT}`,
});

console.log('🚀 Swaplify Queue Worker started. Waiting for jobs from NSQ...');
console.log(`📡 NSQ: ${NSQ_HOST}:${NSQ_PORT} | Topic: ${NSQ_TOPIC} | Channel: ${NSQ_CHANNEL}`);
console.log(`🔗 NestJS: ${NEST_API_URL} | Worker: ${WORKER_URL}`);

reader.connect();

reader.on('message', async (msg) => {
  try {
    const job = JSON.parse(msg.body.toString());
    console.log('📨 Received job from NSQ:', job);

    // Get asset details from NestJS API
    console.log('🔄 Fetching asset details from NestJS...');
    const sourceAsset = await axios.get(`${NEST_API_URL}/media-assets/${job.sourceAssetId}`, {
      headers: { 'X-Internal-Secret': INTERNAL_SECRET }
    });
    const targetAsset = await axios.get(`${NEST_API_URL}/media-assets/${job.targetAssetId}`, {
      headers: { 'X-Internal-Secret': INTERNAL_SECRET }
    });

    // Send job to FastAPI worker
    const payload = {
      jobId: job.jobId,
      sourceKey: sourceAsset.data.objectKey,
      targetKey: targetAsset.data.objectKey,
      options: {
        processors: job.processors || [],
        faceSwapperModel: job.options?.faceSwapperModel || 'inswapper_128',
        useCuda: job.options?.useCuda || true,
        deviceId: parseInt(job.options?.deviceId) || 0,
        extraArgs: []
      }
    };

    console.log('🚀 Sending job to FastAPI worker:', payload);
    
    // Update status ke RUNNING saat mulai kirim ke worker
    await axios.post(`${NEST_API_URL}/jobs/${job.jobId}/internal-status`, {
      status: 'RUNNING',
      progressPct: 10,
    }, {
      headers: { 'X-Internal-Secret': INTERNAL_SECRET }
    });
    console.log('🔄 Job status updated to RUNNING');
    
    const response = await axios.post(WORKER_URL, payload, {
      headers: {
        'Content-Type': 'application/json',
        'X-Worker-Secret': WORKER_SECRET,
      },
    });

    console.log('✅ FastAPI worker response:', response.data);
    console.log('✅ Job sent to worker, waiting for callback from FastAPI worker');
    msg.finish();
    
  } catch (err) {
    console.error('❌ Error processing job:', err.message);
    console.error('❌ Full error:', err);
    msg.requeue(30000); // Requeue after 30s
  }
});

reader.on('error', (err) => {
  console.error('NSQ Reader error:', err);
});

reader.on('discard', (msg) => {
  console.log('⚠️ Message discarded:', msg.body.toString());
});

reader.on('nsqd_connected', () => {
  console.log('✅ Connected to NSQ');
});

reader.on('nsqd_closed', () => {
  console.log('❌ NSQ connection closed');
});