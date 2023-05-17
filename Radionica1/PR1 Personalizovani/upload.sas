/* 
Naziv tabela moze da ide do 13 karaktera!
*/
%let targetFile=num_c.xlsx;
%let sasgf=num_c;

filename &sasgf "%sysfunc(getoption(WORK))/&targetFile.";
ods excel(id=upload) file=&sasgf;
%put &=sasgf;
proc print data=&sasgf;
run;
ods excel(id=upload) close;

filename details temp;
proc http url="https://graph.microsoft.com/v1.0/me/drives/&driveId./items/&folderId.:/&targetFile.:/content"
  method="PUT"
  in=&sasgf
  out=details
  oauth_bearer="&access_token";
run;

libname attrs json fileref=details;
data newfileDetails (keep=filename createdDate modifiedDate filesize);
 length filename $ 100 createdDate 8 modifiedDate 8 filesize 8;
 set attrs.root;
 filename = name;
 modifiedDate = input(lastModifiedDateTime,anydtdtm.);
 createdDate  = input(createdDateTime,anydtdtm.);
 format createdDate datetime20. modifiedDate datetime20.;
 filesize = size;
run;

