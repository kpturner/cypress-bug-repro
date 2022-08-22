import { Given, Then } from 'cypress-cucumber-preprocessor/steps';

import { readImageFileToString } from '../../../../support/utils';

Given('we visit the homepage', () => {
    cy.visit('/');
});

Then('readfile by alias should work', () => {
    let path1 = '';
    let path2 = '';
    cy.screenshot('firstScreenshot', {
        onAfterScreenshot(_$el, props) {
            path1 = props.path;
        }
    }).then(() => {
        readImageFileToString(path1, 'file1');
        cy.wait(2000);
        cy.screenshot('secondScreenshot', {
            onAfterScreenshot(_$el, props) {
                path2 = props.path;
            }
        }).then(() => {
            readImageFileToString(path2, 'file2');
            // compare two screenshot files
            cy.get('@file1').then(file1 => {
                cy.get('@file2').then(file2 => {
                    // expect(file1).not.to.be.null;
                     expect(file2).not.to.be.null;
                });
            });  
        });
    });
    
});
