// Headless DOM verification for the built Obscuro extension.
//
// Usage: NODE_PATH=/path/to/node_modules node verify-dom.js /path/to/obscuro
//
// Loads the real test page and the compiled content/scrambler scripts inside
// jsdom, mocks the chrome.storage API, and checks that blur and scramble modes
// actually touch the expected elements. Requires the `jsdom` package.

const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const repo = process.argv[2];
if (!repo) {
  console.error('usage: node verify-dom.js /path/to/obscuro');
  process.exit(2);
}

const html = fs.readFileSync(path.join(repo, 'test_obscuro.html'), 'utf8');
const config = JSON.parse(fs.readFileSync(path.join(repo, 'dist/config.json'), 'utf8'));
const scramblerJs = fs.readFileSync(path.join(repo, 'dist/scrambler.js'), 'utf8');
const contentJs = fs.readFileSync(path.join(repo, 'dist/content.js'), 'utf8');
const css = fs.readFileSync(path.join(repo, 'dist/content.css'), 'utf8');

const failures = [];
const check = (ok, message) => {
  if (!ok) failures.push(message);
};

async function run(mode) {
  const errors = [];
  const dom = new JSDOM(html, {
    url: 'http://127.0.0.1:8000/test_obscuro.html',
    runScripts: 'outside-only',
    pretendToBeVisual: true,
  });
  const { window } = dom;

  window.console.error = (...args) => errors.push(args.join(' '));
  window.addEventListener('error', (event) => errors.push(String(event.error || event.message)));

  const store = { config, enabled: true, mode };
  window.chrome = {
    storage: {
      sync: {
        get: async () => ({ ...store }),
        set: async (values) => Object.assign(store, values),
      },
      onChanged: { addListener: () => {} },
    },
    runtime: { getURL: (file) => `http://127.0.0.1:8000/${file}` },
  };

  // One eval keeps the top-level `const obscuroScrambler` visible to content.js,
  // the same way two <script> tags share a global lexical environment.
  window.eval(`${scramblerJs}\n${contentJs}`);
  await new Promise((resolve) => setTimeout(resolve, 250));

  const doc = window.document;
  const blurred = doc.querySelectorAll('.blurred');
  const censored = doc.querySelectorAll('[data-censor="1"]');
  const scrambled = doc.querySelectorAll('.scrambled');
  const password = doc.querySelector('#password');
  const apiKey = doc.querySelector('#api-key');
  const username = doc.querySelector('#username');
  const creditCard = doc.querySelector('.credit-card');
  const ssn = doc.querySelector('.ssn');
  const sensitiveSpan = doc.querySelector('span[data-sensitive="true"]');
  const sensitiveTextarea = doc.querySelector('textarea[data-sensitive="true"]');
  const safe = doc.querySelector('.safe');
  const label = `[${mode}]`;

  check(errors.length === 0, `${label} console errors: ${errors.join(' | ')}`);
  check(
    password && apiKey && username && creditCard && ssn && sensitiveSpan && sensitiveTextarea && safe,
    `${label} test page elements missing`
  );

  if (mode === 'blur') {
    check(blurred.length >= 10, `${label} expected many .blurred elements, got ${blurred.length}`);
    check(censored.length >= 10, `${label} expected many censored spans, got ${censored.length}`);
    check(password.classList.contains('blurred'), `${label} password input not blurred`);
    check(apiKey.classList.contains('blurred'), `${label} data-sensitive input not blurred`);
    check(username.classList.contains('blurred'), `${label} username input with email not blurred`);
    check(creditCard.classList.contains('blurred'), `${label} .credit-card not blurred`);
    check(ssn.classList.contains('blurred'), `${label} .ssn not blurred`);
    check(sensitiveSpan.classList.contains('blurred'), `${label} span[data-sensitive] not blurred`);
    check(sensitiveTextarea.classList.contains('blurred'), `${label} textarea[data-sensitive] not blurred`);
    check(safe.textContent.includes('support@mycompany.com'), `${label} ignored email missing`);
    check(!doc.querySelector('.safe [data-censor], .safe.blurred, .safe.scrambled'), `${label} ignored email was masked`);
  } else {
    check(scrambled.length >= 10, `${label} expected many .scrambled elements, got ${scrambled.length}`);
    check(password.classList.contains('scrambled'), `${label} password input not marked .scrambled`);
    check(apiKey.classList.contains('scrambled'), `${label} data-sensitive input not marked .scrambled`);
    check(creditCard.classList.contains('scrambled'), `${label} .credit-card not scrambled`);
    check(ssn.classList.contains('scrambled'), `${label} .ssn not scrambled`);
    check(sensitiveSpan.classList.contains('scrambled'), `${label} span[data-sensitive] not scrambled`);
    check(sensitiveTextarea.classList.contains('scrambled'), `${label} textarea[data-sensitive] not scrambled`);
    check(!doc.body.textContent.includes('alice@example.com'), `${label} email still visible in text`);
    check(!doc.body.textContent.includes('4111 1111 1111 1111'), `${label} credit card still visible in text`);
    check(
      doc.querySelector('[data-obscuro-original="alice@example.com"]') !== null,
      `${label} original email not preserved for restore`
    );
    check(safe.textContent.includes('support@mycompany.com'), `${label} ignored email missing`);
    check(!doc.querySelector('.safe [data-censor], .safe.blurred, .safe.scrambled'), `${label} ignored email was masked`);
  }

  const summary = { blurred: blurred.length, censored: censored.length, scrambled: scrambled.length, errors: errors.length };
  dom.window.close();
  return summary;
}

(async () => {
  const blur = await run('blur');
  const scramble = await run('scramble');
  console.log('blur mode:    ', JSON.stringify(blur));
  console.log('scramble mode:', JSON.stringify(scramble));
  const fallback = /input\.scrambled[\s\S]*filter: blur/.test(css);
  console.log('css form-control fallback:', fallback ? 'present' : 'MISSING');
  check(fallback, 'CSS form-control scramble fallback missing');

  if (failures.length) {
    console.error('\nDOM verification failed:');
    for (const failure of failures) console.error(`  - ${failure}`);
    process.exit(1);
  }
  console.log('\nDOM verification OK');
})();
