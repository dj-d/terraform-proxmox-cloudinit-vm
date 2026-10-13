# Contributing

Contributions are welcome through GitHub pull requests.

## Development workflow

1. Create a branch from `dev`.
2. Make focused changes using Conventional Commit messages.
3. Add or update tests and examples when behavior changes.
4. Run the local quality checks.
5. Open a pull request targeting `dev`.

Use `!` or a `BREAKING CHANGE:` footer when a commit changes the public module
interface.

## Local checks

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
terraform test
```

Validate each example as well:

```bash
for example in examples/*; do
  terraform -chdir="$example" init -backend=false
  terraform -chdir="$example" validate
done
```

## Documentation

Regenerate the module reference after changing inputs, outputs, providers, or
resources. Use the same `terraform-docs` version as CI:

```bash
docker run --rm \
  --volume "$PWD:/terraform-docs" \
  --user "$(id -u)" \
  quay.io/terraform-docs/terraform-docs:0.20.0 \
  markdown table \
  --config /terraform-docs/.terraform-docs.yml \
  /terraform-docs
```

The CI workflow fails when generated documentation is out of date.

## Releases

Release Please analyzes Conventional Commits merged into `main`. It opens a
release pull request that updates the changelog and module version. Merging that
pull request creates the semantic version tag and GitHub Release consumed by
the Terraform Registry.
