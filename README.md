
# Minimum bug reproduction

It is no longer possible to have two or more listeners on the `before:browser:launch` event.

```
    on('before:browser:launch', () => {
        console.log('before:browser:launch first callback');
    });

    on('before:browser:launch', () => {
        console.log('before:browser:launch second callback');
    });
```

Only `console.log('before:browser:launch second callback');` executes.

 
