### crear proyecto react

- django-admin startproject example_site
- python manage.py runserver
- python manage.py startapp polls
- configuras las urls
- python manage.py migrate
- pip install requests (consumir server)

### django

- python -m venv env
- python -m pip install Django==5.0.7

### server basico

- npm i cors express morgan prisma @prisma/client
- npm i nodemon -D

### ORM PRISMA

- npx prisma
- npx prisma init 
- se crea las tablas necesarias
- npx prisma migrate dev
- npx prisma generate
  
  

# REACTJS BASIC

- npm create vite@lastest 
  
  - option = vanilla

- directorio/ npm i @vitejs/plugin-react -E

- directorio/ npm i react react-dom -E

- crear vite.config.js
  
  - import {defineConfig} from "vite";
    import react from "@vitejs/plugin-react";
    export default defineConfig({
    
        plugins:[react()]
    
    })

- nos vamos donde main.js pero antes se lo cambia a jsx y add eso
  
  - import {createRoot} from "react-dom/client";
    const root =createRoot(document.getElementById('app'))
    root.render(<h1>Hola</h1>)
  
  - y se cambia el script del index a main.jsx

- instalar linkter npm install standard -D
  
  - configuracion en package json
    
    - "eslintConfig": {
      
          "extends": "./node_modules/standard/eslintrc.json"
      
      }
