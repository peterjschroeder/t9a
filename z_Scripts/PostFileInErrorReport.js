import http from "k6/http";
import { sleep, check } from "k6";
const baseURL = "https://www.the-ninth-age.com/community/";

const delayBetweenRequests = 1
const username = __ENV.username;
const password = __ENV.password;
const filebaseId = __ENV.filebaseId;
const errorReportId = __ENV.errorReportId;

const pdfFile = open('C:/Projects/9th-age-latex/__PdfOutput/T9A-FB_2ed_Test_Upload_EN.pdf', 'b');

export default function () {
  var securityToken = ""

  var res = http.get(baseURL);
  sleep(delayBetweenRequests);
  const inputElemen = res.html().find('input[name=t]');
  var securityToken = inputElemen.attr('value');
  var checkRes = check(res, {
    "Get security Token": (r) => securityToken.length >= 10
  });

  let loginData = {
    t: securityToken,
    username: username,
    password: password
  };

  res = http.post(baseURL + 'index.php?login', loginData);
  sleep(delayBetweenRequests);
  checkRes = check(res, {
    "Login": (r) => r.body.includes('You have been successfully logged in.')
  });

  res = http.get(baseURL + "filebase/index.php?version-add/" + filebaseId + "/");
  sleep(delayBetweenRequests);

  checkRes = check(res, {
    "Has access to add version": (r) => r.status === 200
  });
/*
  let uploadData = {
    t: securityToken,
    fileType: "upload",
    uploadID: 0,
    versionNumber: "T9A-FB_2ed_Test_Upload_EN" + new Date().getTime(),
    text: "T9A-FB_2ed_Test_Upload_EN",
    __files[0]: http.file(pdfFile, 'T9A-FB_2ed_Test_Upload_EN.pdf'),
  };
  
  res = http.post(baseURL + "filebase/index.php?version-add/" + filebaseId + "/", uploadData);
  sleep(delayBetweenRequests);

  checkRes = check(res, {
    "Upload pdf to filebase": (r) => r.status === 302
  });

  */
};



