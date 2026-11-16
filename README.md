# docker-cicd-service

Production-ready **Node.js / Express** microservice wired up with:

- 🐳 **Multi-stage Dockerfile** (deps → test → release)
- 🔒 **Non-root user**, `HEALTHCHECK`, `SIGTERM` graceful shutdown
- ✅ **Jest + Supertest** test suite with coverage
- 🚀 **GitHub Actions CI/CD** – test → build → push to GHCR

## Quick start

```bash
# Install deps
npm install

# Run tests
npm test

# Start locally
npm start
```

## Docker

```bash
# Build release image
docker build --target release -t docker-cicd-service .

# Run
docker run -p 3000:3000 docker-cicd-service

# Hit the health endpoint
curl http://localhost:3000/health
```

## Project structure

```
.
├── src/
│   ├── app.js            # Express factory (no listen)
│   ├── server.js         # Entry point – binds port, graceful shutdown
│   └── __tests__/
│       └── app.test.js   # Jest + supertest integration tests
├── .github/
│   └── workflows/
│       └── ci-cd.yml     # GitHub Actions pipeline
├── Dockerfile            # Multi-stage build
├── .dockerignore
└── package.json
```
