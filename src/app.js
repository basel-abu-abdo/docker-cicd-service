'use strict';

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');

const app = express();

// ── Security & Middleware ────────────────────────────────────────────────────
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// ── Routes ───────────────────────────────────────────────────────────────────

/** Health-check – used by Docker HEALTHCHECK and load balancers */
app.get('/health', (_req, res) => {
  res.status(200).json({
    status: 'ok',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
  });
});

/** Root */
app.get('/', (_req, res) => {
  res.status(200).json({
    message: 'docker-cicd-service is running 🚀',
    version: process.env.npm_package_version || '1.0.0',
  });
});

/** 404 catch-all */
app.use((_req, res) => {
  res.status(404).json({ error: 'Not Found' });
});

/** Global error handler */
// eslint-disable-next-line no-unused-vars
app.use((err, _req, res, _next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({ error: err.message || 'Internal Server Error' });
});

module.exports = app;
