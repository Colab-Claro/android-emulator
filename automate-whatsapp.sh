#!/bin/bash

# Start Appium server
appium &

# Install necessary Node.js packages
npm install wd

# Create a Node.js script for WhatsApp automation
cat <<EOF > whatsapp-automation.js
const wd = require('wd');
const fs = require('fs');

const driver = wd.promiseChainRemote({
    host: 'localhost',
    port: 4723
});

const capabilities = {
    platformName: 'Android',
    platformVersion: '11.0',
    deviceName: 'emulator-5554',
    appPackage: 'com.whatsapp',
    appActivity: '.Main',
    automationName: 'UiAutomator2'
};

driver
    .init(capabilities)
    .elementById('com.whatsapp:id/eula_accept').click() // Accept EULA if prompted
    .sleep(5000)
    .elementById('com.whatsapp:id/action_search').click()
    .sleep(3000)
    .elementByXPath("//android.widget.TextView[@text='Contact Name']").click()  // Replace with actual contact name
    .sleep(2000)
    .elementById('com.whatsapp:id/entry').sendKeys('Hello from Docker container!')
    .elementById('com.whatsapp:id/send').click()
    .sleep(5000)
    .quit();

driver
    .takeScreenshot()
    .then(function (screenshot) {
        fs.writeFileSync('screenshot.png', new Buffer.from(screenshot, 'base64'));
    });
EOF

# Run the Node.js automation script
node whatsapp-automation.js