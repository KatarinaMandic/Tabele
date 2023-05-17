
/*
	Promeniti path do foldera u kome ce se nalaziti token i 
	odakle cete raditi
*/
%let config_root=C:\Users\kamand\OneDrive - SAS\Documents\Projects\PBZ\Radionica1\PR1 Personalizovani;
/* 
	Pre pokretanja ovog narednog dela koda, u odabrani folder
	kopirajte fajlove onedrive_config.sas i onedrive_macros.sas
*/
%include "&config_root./onedrive_config.sas";
%include "&config_root./onedrive_macros.sas";

/*
	U fajl token.json upisite informacije iz azure zahteva pre pokretanja narednog dela koda.
*/
filename token "&config_root./token.json";

/* 
	Ovo radite samo jedanput. Pokrenite naredni deo koda i nadjite u logu URL.
*/

%let authorize_url=https://login.microsoftonline.com/&tenant_id./oauth2/authorize?client_id=&client_id.%nrstr(&response_type)=code%nrstr(&redirect_uri)=&redirect_uri.%nrstr(&resource)=&resource.;
options nosource;
%put Paste this URL into your web browser:;
%put -- START -------;
%put &authorize_url;
%put ---END ---------;
options source;

/* 
	Kada ste pronasli URL, copy-paste ga u web browser. Tu cete dobiti izgenerisani novi URL.
	Potrebno je kopirati sve nakon nativeclient?code=
	Kada ste to kopirali, pastujte ga u auth_code i pokrenite ostatak programa.
*/
%let auth_code=0.AVcAXE3BsSU2s0WkMJVSNzoML4XauSVqFUdCngC28L381stXAG0.AgABAAIAAAD--DLA3VO7QrddgJg7WevrAgDs_wUA9P-Quqdx-Sh9lkfO42FmmMVedJfQTeoqj3ev4FLdIEMct9MXzIvCiI9IYT2rtyK0S7uJ5TxYtms_RVUbTfqHeHD74t5gckblGncKwkhMmjp9ubH-cKF822v1XnRybh7ckxJIGal2rLY1Zpr-d9s76kviTM7VwFh2n7Thk_PG7fdUNoRJaaQmp1GGi4ZB1LGL8QGeXelakkpywtAatHmneN92pLJ6hdFK8UB7R5_QYp1NXdQ3Nq3mW2zKWybhf5Qw58z0q_JslITDsvo-2IVyIF5aKp7GlPlbucxMQFr6AxUjo3Q5yqmlYyOWL-x8uLWzZPESAMONfe2JYwaqleNYn6tjuO5thqw0_AFySTIO4yxmDnqOvmXytXGYvEFA7VZ9BKBlO6AcVxYi5UX706qDxM4gimbci6hnV9eZnOBjVR6Yxi8Emz7Od8QPAMOGPJzfus8sqlh5riVzaL4IgdstrK7hZu516whTYsoDWSwro161pHER36rddjVZvQdV_fgND6ChG9oiucrycJnB1Vq8acs1lwLUhzUYq3wRRCFuslFGuCNy2AbrEWKvAB7kaZC1YWwH2hjeFOKGiKzvya0_42GJ6rZn655egFYYyPdg0rHyEcOvpCYWnLOSCXftL7qmPN8Nxw31rrslwjoO7L_agDxWxe2QEdqSS2fupNqj91hPR4qsKrq3uKAK473fTs2qlX-fRlJfHkoyF-GkSe1KWC9IsKcGrEaDMW3p2xhXdI_4-tx3Q1IiD1Vcr321fLnwNBERhpX6BghyHmv7K2SDKolfNATZcr_BJE-WYsAjnKMXaGfnB8ltF3q5Dy7jlaE_E537tMxSsWIaatPALagOP6pIYCcwk5lscFSQNMV0MZ56iVZx74l8XNtGfw&session_state=898c4673-c14a-40b7-9a02-2964ae50b911;

/*
  Now that we have an authorization code we can get the access token
  This step will write the tokens.json file that we can use in our
  production programs.
*/
%get_token(&client_id.,&auth_code,&resource.,token,tenant=&tenant_id,debug=3);