#!/bin/bash

# Script to create scaffold for interview prep tracker
mkdir -p src/components
mkdir -p src/pages
mkdir -p src/utils
mkdir -p public
mkdir -p tests

touch src/components/.gitkeep
#!/usr/bin/env bash
set -euo pipefail

echo "Creating scaffold files..."

# Backend dirs
mkdir -p backend/src/main/java/com/amruta/interviewtracker/model
mkdir -p backend/src/main/java/com/amruta/interviewtracker/repository
mkdir -p backend/src/main/java/com/amruta/interviewtracker/controller
mkdir -p backend/src/main/java/com/amruta/interviewtracker
mkdir -p backend/src/main/resources
mkdir -p backend/.github/workflows

cat > backend/pom.xml <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
           http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.amruta</groupId>
  <artifactId>interview-tracker</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>jar</packaging>

  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.12</version>
    <relativePath/>
  </parent>

  <properties>
    <java.version>17</java.version>
  </properties>

  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <scope>runtime</scope>
    </dependency>

    <dependency>
      <groupId>org.postgresql</groupId>
      <artifactId>postgresql</artifactId>
      <scope>runtime</scope>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
    </plugins>
  </build>
</project>
EOF

cat > backend/src/main/java/com/amruta/interviewtracker/InterviewTrackerApplication.java <<'EOF'
package com.amruta.interviewtracker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class InterviewTrackerApplication {
    public static void main(String[] args) {
        SpringApplication.run(InterviewTrackerApplication.class, args);
    }
}
EOF

cat > backend/src/main/java/com/amruta/interviewtracker/model/JobApplication.java <<'EOF'
package com.amruta.interviewtracker.model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "job_application")
public class JobApplication {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String company;
    private String roleTitle;
    private String stage; // e.g., applied, phone-screen, onsite, offer
    private LocalDate appliedDate;
    private String source; // e.g., LinkedIn, referral
    private Integer priority; // 1..5
    private String status; // open, closed, rejected, accepted

    public JobApplication() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }

    public String getRoleTitle() { return roleTitle; }
    public void setRoleTitle(String roleTitle) { this.roleTitle = roleTitle; }

    public String getStage() { return stage; }
    public void setStage(String stage) { this.stage = stage; }

    public LocalDate getAppliedDate() { return appliedDate; }
    public void setAppliedDate(LocalDate appliedDate) { this.appliedDate = appliedDate; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public Integer getPriority() { return priority; }
    public void setPriority(Integer priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
EOF

cat > backend/src/main/java/com/amruta/interviewtracker/repository/JobApplicationRepository.java <<'EOF'
package com.amruta.interviewtracker.repository;

import com.amruta.interviewtracker.model.JobApplication;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {
    Page<JobApplication> findByCompanyContainingIgnoreCaseOrRoleTitleContainingIgnoreCase(String company, String roleTitle, Pageable pageable);
}
EOF

cat > backend/src/main/java/com/amruta/interviewtracker/controller/ApplicationController.java <<'EOF'
package com.amruta.interviewtracker.controller;

import com.amruta.interviewtracker.model.JobApplication;
import com.amruta.interviewtracker.repository.JobApplicationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/applications")
@CrossOrigin(origins = "*")
public class ApplicationController {

    @Autowired
    private JobApplicationRepository repository;

    @GetMapping
    public Page<JobApplication> list(@RequestParam(value = "q", required = false) String q, Pageable pageable) {
        if (q == null || q.isBlank()) {
            return repository.findAll(pageable);
        }
        return repository.findByCompanyContainingIgnoreCaseOrRoleTitleContainingIgnoreCase(q, q, pageable);
    }

    @GetMapping("/{id}")
    public Optional<JobApplication> get(@PathVariable Long id) {
        return repository.findById(id);
    }

    @PostMapping
    public JobApplication create(@RequestBody JobApplication app) {
        return repository.save(app);
    }

    @PutMapping("/{id}")
    public JobApplication update(@PathVariable Long id, @RequestBody JobApplication app) {
        app.setId(id);
        return repository.save(app);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repository.deleteById(id);
    }

}
EOF

cat > backend/src/main/resources/application.properties <<'EOF'
# Dev - in-memory H2 DB
spring.datasource.url=jdbc:h2:mem:interviewdb;DB_CLOSE_DELAY=-1
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.hibernate.ddl-auto=update
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Production (example) - supply via env vars on deployment
# spring.datasource.url=${JDBC_DATABASE_URL}
# spring.datasource.username=${JDBC_DATABASE_USERNAME}
# spring.datasource.password=${JDBC_DATABASE_PASSWORD}
EOF

cat > backend/Dockerfile <<'EOF'
# Multi-stage Dockerfile
FROM maven:3.8.6-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/interview-tracker-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
EOF

cat > backend/.github/workflows/maven.yml <<'EOF'
name: Java CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 17
      - name: Build with Maven
        run: mvn -B -DskipTests package
      - name: Run tests
        run: mvn test
EOF

# Frontend dirs
mkdir -p frontend/src/app/services
mkdir -p frontend/src/app
mkdir -p frontend/src

cat > frontend/INSTRUCTIONS.md <<'EOF'
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
EOF

cat > frontend/src/app/services/api.service.ts <<'EOF'
import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface JobApplication {
  id?: number;
  company: string;
  roleTitle: string;
  stage?: string;
  appliedDate?: string;
  source?: string;
  priority?: number;
  status?: string;
}

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private base = '/api/applications';

  constructor(private http: HttpClient) { }

  getApplications(page = 0, size = 10, q?: string): Observable<any> {
    let params = new HttpParams().set('page', String(page)).set('size', String(size));
    if (q) params = params.set('q', q);
    return this.http.get<any>(this.base, { params });
  }

  getApplication(id: number) {
    return this.http.get<JobApplication>(`${this.base}/${id}`);
  }

  createApplication(app: JobApplication) {
    return this.http.post<JobApplication>(this.base, app);
  }

  updateApplication(id: number, app: JobApplication) {
    return this.http.put<JobApplication>(`${this.base}/${id}`, app);
  }

  deleteApplication(id: number) {
    return this.http.delete(`${this.base}/${id}`);
  }
}
EOF

cat > frontend/src/app/app.module.ts <<'EOF'
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
EOF

cat > frontend/src/app/app.component.ts <<'EOF'
import { Component, OnInit } from '@angular/core';
import { ApiService, JobApplication } from './services/api.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
  list: JobApplication[] = [];
  q = '';
  newApp: JobApplication = { company: '', roleTitle: '', priority: 3, status: 'open' };

  constructor(private api: ApiService) {}

  ngOnInit() {
    this.load();
  }

  load() {
    this.api.getApplications(0, 20, this.q).subscribe(res => {
      this.list = res.content || [];
    });
  }

  search() {
    this.load();
  }

  create() {
    this.api.createApplication(this.newApp).subscribe(() => {
      this.newApp = { company: '', roleTitle: '', priority: 3, status: 'open' };
      this.load();
    });
  }

  delete(id?: number) {
    if (!id) return;
    this.api.deleteApplication(id).subscribe(() => this.load());
  }
}
EOF

cat > frontend/src/app/app.component.html <<'EOF'
<div class="container">
  <h1>Interview Prep Tracker (Demo)</h1>

  <div class="search">
    <input type="text" [(ngModel)]="q" placeholder="Search company or role" />
    <button (click)="search()">Search</button>
  </div>

  <div class="create">
    <h3>Add application</h3>
    <input [(ngModel)]="newApp.company" placeholder="Company" />
    <input [(ngModel)]="newApp.roleTitle" placeholder="Role" />
    <button (click)="create()">Add</button>
  </div>

  <table>
    <thead>
      <tr><th>Company</th><th>Role</th><th>Stage</th><th>Priority</th><th>Action</th></tr>
    </thead>
    <tbody>
      <tr *ngFor="let app of list">
        <td>{{app.company}}</td>
        <td>{{app.roleTitle}}</td>
        <td>{{app.stage || '-'}}</td>
        <td>{{app.priority}}</td>
        <td>
          <button (click)="delete(app.id)">Delete</button>
        </td>
      </tr>
    </tbody>
  </table>
</div>
EOF

cat > frontend/src/index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Interview Prep Tracker</title>
  <base href="/">
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
  <app-root></app-root>
</body>
</html>
EOF

cat > frontend/src/styles.scss <<'EOF'
body {
  font-family: Arial, sans-serif;
  padding: 1rem;
}
.container { max-width: 900px; margin: 0 auto; }
.search, .create { margin-bottom: 1rem; }
table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
th, td { border: 1px solid #ddd; padding: 0.5rem; text-align: left; }
EOF

# .gitignore and root README
cat > .gitignore <<'EOF'
/backend/target
/frontend/node_modules
/frontend/dist
/*.log
*.class
EOF

cat > README_ADD.md <<'EOF'
This commit adds the full scaffold: backend (Spring Boot) and frontend (Angular helper files).
After running this script, run 'cd backend && mvn clean package && mvn spring-boot:run' and create the Angular project as documented in frontend/INSTRUCTIONS.md.
EOF

git add .
git commit -m "Add full scaffold: Angular 13 frontend helper files + Spring Boot backend"
git push -u origin main

echo "Scaffold added and pushed. Done."