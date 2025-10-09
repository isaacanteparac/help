1. npm create vite@latest
   
   1. React > JS > no > yex

2. npm install tailwindcss @tailwindcss/vite
   
   1. vite.config.js
      
      ```
      import { defineConfig } from 'vite'
      import react from '@vitejs/plugin-react'
      import tailwindcss from '@tailwindcss/vite'
      
      // https://vite.dev/config/
      export default defineConfig({
        plugins: [react(),tailwindcss()],
      })
      ```
   2. index.css
      
      ```
      @import "tailwindcss";
      ```
   3. npm install react-router-dom

[niduslink](https://niduslink.pages.dev/)