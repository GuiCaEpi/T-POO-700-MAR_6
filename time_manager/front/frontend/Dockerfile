# Utiliser une image Node.js pour le développement
FROM node:18

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm install --force
RUN npm install axios --force
RUN npm i vue-chartjs chart.js --force
RUN npm install @vitejs/plugin-vue
RUN npm install @fortawesome/fontawesome-free
Run npm install date-fns
RUN npm install -D tailwindcss postcss autoprefixer
RUN npx tailwindcss init 
# Copier tout le code source dans le conteneur
COPY . .

# Exposer le port sur lequel Vite sert l'application (par défaut 5173)
EXPOSE 5173

# Lancer l'application en mode développement
CMD ["npm", "run", "dev"]
