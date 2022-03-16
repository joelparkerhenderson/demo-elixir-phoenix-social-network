# Fonts via webpack and SCSS


## Copy our fonts

Copy our fonts from our existing mockups:

```sh
mkdir -p assets/fonts
rsync -av ~/git/commissaryclub/commissary-ui/src/assets/fonts/ ~/git/commissaryclub/commissary_ux/assets/fonts/
```

```sh
git add --all && git commit -am "Add fonts"
```


## Add webpack file-loader

Add file-loader such as via `npm`:

```sh
npm --prefix=assets install file-loader --save-dev
```


## Add rule

Edit `assets/webpack.config.js`, see the section of `module.exports` and within that the section of `module` rules, then add the following rule:

```js
{
  test: /\.(woff|woff2|ttf|eot)(\?v=\d+\.\d+\.\d+)?$/,
  use: [
    {
      loader: 'file-loader',
      options: { name: '[name].[ext]', outputPath: '../fonts' }
    },
  ],
}
```


### Add SCSS font face

Edit `assets/css/app.sccs` and add the font face near the top:

```css
@font-face {
  font-family: 'Adieu-Black';
  src: url('../fonts/Adieu/Adieu-Black.woff2') format('woff2'),
       url('../fonts/Adieu/Adieu-Black.woff') format('woff');
}
```


## Verify

Verify that `mix` copies the fonts during a typical run:

```sh
mix phx.server
```

Then:

```sh
find priv/static/fonts
```

Output should show just the fonts that we use:

```sh
priv/static/fonts
priv/static/fonts/Adieu-Black.woff2
priv/static/fonts/Adieu-Black.woff
```


## Commit

Run:

```sh
git add --all && git commit -am "Add fonts via webpack and SCSS"
```
