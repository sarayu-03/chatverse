# ========== Stage 1: Build frontend ==========
FROM node:18 AS builder

WORKDIR /app

# Copy only the package.json files we need (prevents copying everything early)
COPY package*.json ./
COPY chatify-master/frontend/package*.json ./chatify-master/frontend/
COPY chatify-master/backend/package*.json ./chatify-master/backend/

# Install dependencies for frontend and backend (build-time)
RUN npm install --prefix chatify-master/frontend
RUN npm install --prefix chatify-master/backend

# Build the frontend (outputs to chatify-master/frontend/dist)
RUN npm run build --prefix chatify-master/frontend

# ========== Stage 2: Production image ==========
FROM node:18

WORKDIR /app

# Copy backend source into final image (from repo)
COPY chatify-master/backend ./chatify-master/backend

# Copy built frontend from builder stage into same relative path
COPY --from=builder /app/chatify-master/frontend/dist ./chatify-master/frontend/dist

# Copy root package.json (optional, but harmless)
COPY package*.json ./

# Install backend runtime deps only
RUN npm install --prefix chatify-master/backend --omit=dev

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Start backend (which serves frontend/dist)
CMD ["npm", "start", "--prefix", "chatify-master/backend"]
