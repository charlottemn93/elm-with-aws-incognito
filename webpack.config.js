module.exports = {
    // Example setup for your project:
    // The entry module that requires or imports the rest of your project.
    // Must start with `./`!
    entry: '/Users/charlotteneill/flashEm/src/entry',
    // Place output files in `./dist/my-app.js`
    output: {
        path: '/Users/charlotteneill/flashEm/dist',
        filename: 'my-app.js'
    },
    module: {
        rules: [
            {
                test: /\.json$/,
                loader: 'json'
            },
            {
                test: /\.(css|less)$/,
                use: ["style-loader", "css-loader"]
            }
        ]
    }
};