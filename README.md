
# Minimum bug reproduction

This repro repo demonstrates that a test that works in 10.2.0 is broken with 10.6.0.   `cy.readfile` specifying an alias cannot subsequently be retrieved with `cy.get` using that alias. 

Simply run `./run-cypress.sh` to see the test failing.  Downgrade to `10.2.0` to see the test working.
 