# ========== Stage 1: Build Frontend ==========
FROM node:18 AS frontend

WORKDIR /app

# Copy frontend package files
COPY chatify-master/frontend/package*.json ./frontend/

# Install dependencies
RUN npm install --prefix frontend

# Copy all frontend source files
COPY chatify-master/frontend ./frontend

# Build the frontend (this will find index.html inside ./frontend)
WORKDIR /app/frontend
RUN npm run build


# ========== Stage 2: Build Backend ==========
FROM node:18 AS backend

WORKDIR /app

# Copy backend package files
COPY chatify-master/backend/package*.json ./backend/
RUN npm install --prefix backend

# Copy backend source
COPY chatify-master/backend ./backend

# Copy built frontend to backend/public (or wherever your backend serves static files)
COPY --from=frontend /app/frontend/dist ./backend/public


# ========== Stage 3: Production ==========
WORKDIR /app/backend
EXPOSE 3000
CMD ["npm", "start"]
