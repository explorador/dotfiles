export default {
    plugins: [
        {
            name: 'preset-default',
            params: {
                overrides: {
                    // disable a default plugin
                    cleanupIds: true,

                    // customize the params of a default plugin
                    inlineStyles: {
                        onlyMatchedOnce: false,
                    },
                },
            },
        },
        {
            name: 'prefixIds',
            params: {
                delim: '__',
                prefixIds: true,
                prefixClassNames: true
            },
        },
        "removeDimensions"
    ],
};
