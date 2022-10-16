import { Component, Inject } from '@angular/core';
import { APP_CONFIG, AppConfig } from './config';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  readonly title = 'angular-build-once-deploy-anywhere';
  readonly environment = this.config.environment;
  readonly revision = this.config.revision;

  constructor(@Inject(APP_CONFIG) private readonly config: AppConfig) {}
}
