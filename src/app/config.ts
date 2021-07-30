import { InjectionToken } from '@angular/core';

export interface AppConfig {
  environment: string;
  apiUrl: string;
}

export const APP_CONFIG = new InjectionToken<AppConfig>('APP_CONFIG');
