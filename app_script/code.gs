const SHEET_NAME = "students_input";

function isRowComplete(student) {
  return (
    student.Name &&
    student.Email &&
    student.Year &&
    student.Dept
  );
}

function clearRowFormatting(sheet, row, statusCol) {
  Logger.log(`⚪ Clearing formatting for row ${row}`);

  // Clear data cell backgrounds
  sheet
    .getRange(row, 1, 1, statusCol - 1)
    .setBackground(null);

  // Clear status cell value AND background
  sheet
    .getRange(row, statusCol)
    .clearContent()
    .setBackground(null);
}




function handleStudentEdit(e) {
  Logger.log("🔔 Trigger fired");

  if (!e) {
    Logger.log("❌ No event object");
    return;
  }

  const sheet = e.range.getSheet();
  Logger.log("📄 Sheet name: " + sheet.getName());

  if (sheet.getName() !== SHEET_NAME) {
    Logger.log("⏭️ Ignored: not target sheet");
    return;
  }

  const row = e.range.getRow();
  const col = e.range.getColumn();

  Logger.log(`✏️ Edited cell → row: ${row}, col: ${col}`);

  if (row === 1) {
    Logger.log("⏭️ Header row edit ignored");
    return;
  }

  const headers = sheet
    .getRange(1, 1, 1, sheet.getLastColumn())
    .getValues()[0];

  const statusCol = headers.indexOf("Status") + 1;
  if (statusCol === 0) {
    Logger.log("❌ Status column not found");
    return;
  }

  // prevent infinite loop
  if (col === statusCol) {
    Logger.log("⏭️ Ignored: status column edit");
    return;
  }

  const values = sheet
    .getRange(row, 1, 1, headers.length)
    .getValues()[0];

  let student = {};
  headers.forEach((h, i) => {
    student[h] = values[i];
  });

  Logger.log("👤 Student object: " + JSON.stringify(student));
  
 if (!isRowComplete(student)) {
  Logger.log("⏳ Row incomplete — waiting for full input");
  clearRowFormatting(sheet, row, statusCol);
  return;
}


  const errors = validateStudent(student);

  if (errors.length === 0) {
    Logger.log("✅ Validation PASSED");
    markRowValid(sheet, row, statusCol);
    sendToBackend(student);
  } else {
    Logger.log("❌ Validation FAILED");
    Logger.log("🧨 Errors: " + JSON.stringify(errors));
    markRowInvalid(sheet, row, statusCol, errors);
    notifyInvalid(student, errors);
  }
}

function validateStudent(student) {
  const errors = [];

  if (!student.Name) {
    errors.push("Missing Name");
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!student.Email || !emailRegex.test(student.Email)) {
    errors.push("Invalid Email");
  }

  if (!student.Year || student.Year < 1 || student.Year > 5) {
    errors.push("Year must be between 1 and 5");
  }

  if (!student.Dept) {
    errors.push("Missing Department");
  }

  return errors;
}

function markRowValid(sheet, row, statusCol) {
  Logger.log(`🟢 Marking row ${row} as VALID`);

  sheet
    .getRange(row, 1, 1, statusCol - 1)
    .setBackground("#ccffcc");

  sheet
    .getRange(row, statusCol)
    .setValue("VALID");
}

function markRowInvalid(sheet, row, statusCol, errors) {
  Logger.log(`🔴 Marking row ${row} as INVALID`);

  sheet
    .getRange(row, 1, 1, statusCol - 1)
    .setBackground("#ffcccc");

  sheet
    .getRange(row, statusCol)
    .setValue("INVALID: " + errors.join(", "));
}

function sendToBackend(student) {
  const url = "https://eloisa-monohydroxy-loftily.ngrok-free.dev/ingest/student";


  Logger.log("📤 Sending to backend: " + JSON.stringify(student));

  try {
    const response = UrlFetchApp.fetch(url, {
      method: "post",
      contentType: "application/json",
      payload: JSON.stringify(student),
      muteHttpExceptions: true
    });

    Logger.log("📥 Backend response code: " + response.getResponseCode());
    Logger.log("📥 Backend response body: " + response.getContentText());

  } catch (err) {
    Logger.log("❌ Backend error: " + err.message);
  }
}
// function forceAuthorize() {
//   UrlFetchApp.fetch("https://www.google.com");
// }

function notifyInvalid(student, errors) {
  const email = Session.getActiveUser().getEmail();

  const subject = "🚨 Invalid Student Entry Detected";

  const body = `
An invalid student entry was detected in Google Sheets.

Student Details:
Name: ${student.Name || "N/A"}
Email: ${student.Email || "N/A"}
Year: ${student.Year || "N/A"}
Department: ${student.Dept || "N/A"}

Validation Errors:
- ${errors.join("\n- ")}

Please correct the row in the sheet.
`;

  MailApp.sendEmail(email, subject, body);

  Logger.log("📧 Invalid entry email sent to: " + email);
}