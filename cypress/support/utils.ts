
export function readImageFileToString(fileName: string, alias: string): void {
    
    cy.readFile(fileName, 'base64').then((file: string) => {
     
    }).as(alias);
}
