
### What?
You've claimed a CF environment from Shepherd and downloaded the CF CLI. Now you're going to connect to the environment with the CLI.

### How?

When claiming the environment from Shepherd, it displayed the ID of the lease. For example:
```sh
$ shepherd create lease ...
...
Lease ID: <lease-id>
```

You can use this lease id to get information about the environment, including user credentials. Use [`jq`](https://jqlang.org/) to retrieve the CF API address and admin password:
```sh
$ shepherd get lease <lease-id> --json | jq .output.cf.api_url
"<api-url>"

$ shepherd get lease <lease-id> --json | jq .output.cf.password
"<admin-password>"
```

Configure the CF CLI to target the Shepherd environment's API endpoint:
```sh
$ cf api <api-url> --skip-ssl-validation
```

Authenticate as the admin user:
```sh
$ cf auth admin <admin-password>
```

### Expected Result
Run `cf target`. You'll see a line that says `API endpoint:   https://<api-url>`, followed by your user.

### Resources
- [Getting started with the cf CLI](https://docs.cloudfoundry.org/cf-cli/getting-started.html)

### Relevant Repos
- **CLI:** [cloudfoundry/cli](https://github.com/cloudfoundry/cli)
- **Shepherd:** [TNZ/shepherd2](https://github.gwd.broadcom.net/TNZ/shepherd2)
