# Frontend (Angular 13) — quick instructions

1. Install Angular CLI 13:
   npm i -g @angular/cli@13

2. Create project (from repo root):
   ng new frontend --routing --style=scss --strict=false
   cd frontend

3. Install dependencies:
   npm install

4. Copy the provided files into the generated project:
   - src/app/services/api.service.ts
   - src/app/app.component.ts
   - src/app/app.component.html
   - src/app/app.module.ts
   - src/index.html
   - src/styles.scss

5. Configure proxy to avoid CORS during local dev (create proxy.conf.json):
   {
     "/api": {
       "target": "http://localhost:8080",
       "secure": false
     }
   }
   Then run:
   ng serve --proxy-config proxy.conf.json

6. Build for production:
   ng build --configuration production

7. Deploy:
   - Vercel / Netlify support Angular static sites. Point to dist/frontend after build.
   - Ensure backend URL is set via environment variables or a simple reverse proxy.
