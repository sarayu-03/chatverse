# ---- FRONTEND BUILD STAGE ----
FROM node:20 AS frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# ---- BACKEND STAGE ----
FROM node:20 AS backend
WORKDIR /app

# Copy backend code and install deps
COPY backend/package*.json ./backend/
RUN npm install --prefix backend
COPY backend ./backend

# Copy built frontend (React dist folder) into expected location
COPY --from=frontend /app/frontend/dist ./frontend/dist

# Expose backend port
EXPOSE 3000

# Set environment to production
ENV NODE_ENV=production

# Start backend server
CMD ["npm", "start", "--prefix", "backend"]
