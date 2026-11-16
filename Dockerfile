# =============================================================================
#  Stage 1 — deps: install production dependencies only
# =============================================================================
FROM node:20-alpine AS deps

WORKDIR /app

# Copy manifests first to leverage Docker layer cache
COPY package*.json ./

RUN npm ci --omit=dev --ignore-scripts \
    && npm cache clean --force

# =============================================================================
#  Stage 2 — test: install ALL deps and run tests
# =============================================================================
FROM node:20-alpine AS test

WORKDIR /app

COPY package*.json ./
RUN npm ci --ignore-scripts

COPY src/ ./src/

RUN npm test

# =============================================================================
#  Stage 3 — release: lean production image
# =============================================================================
FROM node:20-alpine AS release

# Security: run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy production node_modules from the deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy application source
COPY src/ ./src/
COPY package*.json ./

# Drop privileges
USER appuser

EXPOSE 3000

# Health-check (requires curl or wget; alpine ships wget)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/server.js"]
