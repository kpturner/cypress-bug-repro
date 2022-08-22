import { defineConfig } from 'cypress';

import plugins from './cypress/plugins/index';

export default defineConfig({
    numTestsKeptInMemory: 0,
    video: true,
    retries: {
        runMode: 0,
        openMode: 0
    },
    reporter: 'spec',
    reporterOptions: {
        mochaFile: 'results/cypress-report.xml',
        toConsole: true
    },
    e2e: {
    // We've imported your old cypress plugins here.
    // You may want to clean this up later by importing these.
        setupNodeEvents(on, config) {
            return plugins(on, config);
        },
        baseUrl: 'http://localhost',
        excludeSpecPattern: [],
        specPattern: 'cypress/e2e/**/*.{feature,features}'
    }
});
