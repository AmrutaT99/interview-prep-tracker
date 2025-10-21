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
