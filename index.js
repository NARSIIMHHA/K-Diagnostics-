const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onReportUpload = functions.firestore.document('reports/{reportId}').onCreate(async (snap, context) => {
  const report = snap.data();
  const uid = report.user_id;
  const userDoc = await admin.firestore().collection('users').doc(uid).get();
  const token = userDoc.data() && userDoc.data().deviceToken;
  if (!token) return null;
  const message = {
    token,
    notification: { title: 'Report Ready', body: 'Your diagnostic report is now available.' }
  };
  return admin.messaging().send(message);
});
