# Interview Prep Tracker (starter scaffold)

A minimal starter for an Interview Prep Tracker:
- Frontend: Angular 13 (instructions to generate and drop-in files)
- Backend: Spring Boot (REST API, JPA, H2 for dev, Postgres for production)
- Dockerfile and GitHub Actions included

Quick local run (backend)
1. cd backend
2. mvn clean package
3. mvn spring-boot:run
Backend will start at http://localhost:8080 and H2 console at http://localhost:8080/h2-console

Quick frontend setup (Angular 13)
1. Install Angular CLI v13 if needed:
   npm i -g @angular/cli@13
2. Create project:
   ng new frontend --routing --style=scss --strict=false
3. cd frontend
4. Copy the provided frontend files (src/app/* and src/index.html etc.) into the generated project.
5. ng serve
Frontend will run at http://localhost:4200 and proxy to backend using environment or proxy config.

Deployment notes
- Frontend: Vercel or Netlify (build and serve static files produced by `ng build --prod`).
- Backend: Railway / Render / Fly (connect a managed Postgres for production).
- Docker: a multi-stage Dockerfile is provided for container-based deploy.

EOF