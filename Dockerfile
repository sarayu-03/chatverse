# ---------- Stage 1: Build Frontend ----------
FROM node:18 AS frontend

WORKDIR /app
COPY chatify-master/frontend/package*.json ./frontend/
RUN npm install --prefix frontend
COPY chatify-master/frontend ./frontend
WORKDIR /app/frontend
RUN npm run build


# ---------- Stage 2: Build Backend ----------
FROM node:18 AS backend

WORKDIR /app
COPY chatify-master/backend/package*.json ./backend/
RUN npm install --prefix backend
COPY chatify-master/backend ./backend

# Copy built frontend to backend/public
COPY --from=frontend /app/frontend/dist ./backend/public

WORKDIR /app/backend
EXPOSE 3000
CMD ["npm", "start"]
