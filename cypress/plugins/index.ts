import * as browserify from '@cypress/browserify-preprocessor';
import * as cucumberPreprocessor from 'cypress-cucumber-preprocessor';
import * as resolve from 'resolve';
const cucumber: any = cucumberPreprocessor.default;
import * as os from 'os';

export interface IEventCallback {
    (event: string, callback: any): void;
}

export default (on: IEventCallback, config: Cypress.PluginConfigOptions): Cypress.PluginConfigOptions => {
    const options = browserify.defaultOptions;

    options.browserifyOptions.outfile = 'build';
    options.browserifyOptions.debug = true;
    options.browserifyOptions.plugin.unshift(['tsify']);
    options.typescript = resolve.sync('typescript', { basedir: config.projectRoot });

    on('file:preprocessor', cucumber.default(options));

    console.log(`Running on ${os.platform()}`);

    return config;
};
