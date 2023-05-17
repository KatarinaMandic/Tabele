/******************************************************
					START OF FIND DRIVE
*******************************************************/

/* Gde ce fajlovi da se cuvaju (sherani folder) */
%let config_root=C:\Users\kamand\OneDrive - SAS\Documents\Projects\PBZ\Radionica1\PR1 Personalizovani;

/* Predefinisani programi */
%include "&config_root./onedrive_config.sas";
%include "&config_root./onedrive_macros.sas";

/* Pristup tokenu */
filename token "&config_root./token.json";

/* Upozorenje ako token ne postoji */
%if (%sysfunc(fexist(token)) eq 0) %then %do;
	%put ERROR: &config_root./token.json not found.  Run the setup steps to create the API tokens.;
%end;

/* Pozivanje tokena putem makro funkcije */
%process_token_file(token);

/* Provera da li treba ovbnoviti token */
%if &expires_on < %sysevalf(%sysfunc(datetime()) - %sysfunc(gmtoff())) %then %do;
	%refresh(&client_id.,&refresh_token.,&resource.,token,tenant=&tenant_id.);
%end;

filename resp temp;

/* Pristup root folderu na SharePointu */
%let hostname = sasoffice365.sharepoint.com;
%let sitepath = /sites/TestKM;
proc http url="https://graph.microsoft.com/v1.0/sites/&hostname.:&sitepath.:/drive"
     oauth_bearer="&access_token"
     out = resp;
	 run;

libname jresp json fileref=resp;

/* Pronalazak driveID root foldera */
data drive;
	set jresp.root;
run;

/* Cuvanje driveID u promenljivu driveID */
proc sql noprint;
	select id into: driveId from drive;
quit;


/* Prikaz foldera */
filename resp TEMP;
proc http url="https://graph.microsoft.com/v1.0/me/drives/&driveId./items/root/children"
     oauth_bearer="&access_token"
     out = resp;
	 run;

libname jresp json fileref=resp;

/* Kreairanje tabele */
data paths;
	set jresp.value;
run;

/******************************************************
					END OF FIND DRIVE
*******************************************************/

proc sql noprint;
	select id into: driveId from drive;
quit;

proc sql noprint;
	select id into: folderid from paths
	where name = "Radionica";
quit;

filename resp TEMP;
proc http url="https://graph.microsoft.com/v1.0/me/drives/&driveId./items/&folderid./children"
     oauth_bearer="&access_token"
     out = resp;
	 run;

libname jresp json fileref=resp;

/* Kreairanje tabele */
data paths_final;
	set jresp.value;
run;

 
/* Biranje imena fajla koji se ucitava */
proc sql noprint;
 select id into: fileId from paths_final
  where name="Countries.xlsx";
quit;

/* Upisivanje u folder */
 
filename fileout "&config_root./Countries.xlsx";
proc http url="https://graph.microsoft.com/v1.0/me/drives/&driveId./items/&fileId./content"
     oauth_bearer="&access_token"
     out = fileout;
	 run;
 
/* Importovanje tabele u SAS */
%let sasgf = %scan("Countries.xlsx", 1, ".");

proc import file=fileout 
 out=&sasgf
 dbms=xlsx replace;
run;

/* Biranje imena fajla koji se ucitava */
proc sql noprint;
 select id into: fileId from paths_final
  where name="Employees.xlsx";
quit;

/* Upisivanje u folder */
 
filename fileout "&config_root./Employees.xlsx";
proc http url="https://graph.microsoft.com/v1.0/me/drives/&driveId./items/&fileId./content"
     oauth_bearer="&access_token"
     out = fileout;
	 run;
 
/* Importovanje tabele u SAS */
%let sasgf = %scan("Employees.xlsx", 1, ".");

proc import file=fileout 
 out=&sasgf
 dbms=xlsx replace;
run;