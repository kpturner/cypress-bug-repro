
export function readImageFileToString(fileName: string, alias: string): void {
    cy.readFile(fileName, 'base64').then((file: string) => {
        cy.log(`Length of image '${alias}': ${file.length}`);
    }).as(alias);
}
