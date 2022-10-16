import { TestBed } from '@angular/core/testing';
import { AppComponent } from './app.component';
import { APP_CONFIG, AppConfig } from './config';

describe('AppComponent', () => {
  let appConfig: AppConfig;

  beforeEach(async () => {
    appConfig = {
      apiUrl: 'http://localhost:3000',
      environment: 'unit-test',
      revision: 'a23de67'
    }

    await TestBed.configureTestingModule({
      declarations: [
        AppComponent
      ],
      providers: [
        {provide: APP_CONFIG, useValue: appConfig}
      ]
    }).compileComponents();
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

  it(`should have as title 'angular-build-once-deploy-anywhere'`, () => {
    const fixture = TestBed.createComponent(AppComponent);
    const app = fixture.componentInstance;
    expect(app.title).toEqual('angular-build-once-deploy-anywhere');
  });

  it('should render title', () => {
    const fixture = TestBed.createComponent(AppComponent);
    fixture.detectChanges();
    const compiled = fixture.nativeElement;
    expect(compiled.querySelector('.content span').textContent).toContain('angular-build-once-deploy-anywhere app is running!');
  });

  it('should show the environment on the page', () => {
    const fixture = TestBed.createComponent(AppComponent);
    fixture.detectChanges();
    const compiled = fixture.nativeElement;
    expect(compiled.querySelector('[data-test-id="welcome-message"]').textContent).toContain(`Welcome to ${appConfig.environment} (revision ${appConfig.revision})`);
  })
});
