import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment'; // adjust path if needed

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
  // Use configured base URL in production; during local dev keep '/api' (proxy) if environment.apiBaseUrl is empty
  private base = environment.apiBaseUrl?.length ? `${environment.apiBaseUrl}/api/applications` : '/api/applications';

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