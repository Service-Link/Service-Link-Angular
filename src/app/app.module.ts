import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import {NgxPageScrollModule} from 'ngx-page-scroll';

import { AppComponent } from './app.component';
import { MainHeaderComponent } from './main-header/main-header.component';
import { JumbotronComponent } from './jumbotron/jumbotron.component';
import { CustomersComponent } from './customers/customers.component';
import { ServicesComponent } from './services/services.component';
import { ContactComponent } from './contact/contact.component';
import { PortfolioComponent } from './portfolio/portfolio.component';


@NgModule({
  declarations: [
    AppComponent,
    MainHeaderComponent,
    JumbotronComponent,
    CustomersComponent,
    ServicesComponent,
    ContactComponent,
    PortfolioComponent
  ],

  imports: [
    BrowserModule,
    FontAwesomeModule,
    NgxPageScrollModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
