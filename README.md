# slidev4slidev

A [Slidev](https://sli.dev) deck about writing slides with Slidev and publishing them on [Vercel](https://vercel.com) — built and deployed the way it describes.

## Development

The toolchain (Node.js 24, pnpm, lefthook) comes from the Nix flake. With direnv:

```sh
direnv allow
pnpm install
pnpm dev
```

Without direnv, run `nix develop` first.

## Deployment

Production is deployed by the Vercel Git Integration on every push to `main`.
Pull requests get preview deployments.
