import { Component, Inject } from '@angular/core';
import { APP_CONFIG, AppConfig } from './config';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'angular-build-once-deploy-anywhere';
  environment: string;

  constructor(@Inject(APP_CONFIG) private readonly config: AppConfig) {
    this.environment = config.environment;
  }
}
