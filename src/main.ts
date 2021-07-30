import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AppModule } from './app/app.module';
import { APP_CONFIG } from './app/config';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

fetch('/assets/config.json')
  .then(response => response.json())
  .then(config => {
    platformBrowserDynamic([{provide: APP_CONFIG, useValue: config}]).bootstrapModule(AppModule)
      .catch(err => console.error(err));
  });


